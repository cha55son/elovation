class Game < ActiveRecord::Base
  has_many :ratings,  dependent: :destroy
  has_many :results,  dependent: :destroy
  has_many :webhooks, dependent: :destroy
  belongs_to :player

  accepts_nested_attributes_for :webhooks, allow_destroy: true
  before_validation :default_values

  RATER_MAPPINGS = {
    "elo" => Rater::EloRater.new,
    "trueskill" => Rater::TrueSkillRater.new
  }

  validates :player_id, presence: true
  validates :name, presence: true
  validates :rating_type, inclusion: { in: RATER_MAPPINGS.keys, message: "must be a valid rating type" }
  validate do |game|
    if game.rater
      game.rater.validate_game game
    end
  end

  validates :min_number_of_teams, numericality: { only_integer: true, greater_than_or_equal_to: 2 }
  validates :max_number_of_teams, numericality: { only_integer: true, allow_nil: true }
  validate do |game|
    if game.min_number_of_teams && 
       game.max_number_of_teams && 
       game.min_number_of_teams > game.max_number_of_teams
      game.errors.add(:max_number_of_teams, "cannot be less than the minimum")
    end
  end

  validates :min_number_of_players_per_team, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :max_number_of_players_per_team, numericality: { only_integer: true, allow_nil: true }
  validate do |game|
    if game.min_number_of_players_per_team && 
       game.max_number_of_players_per_team && 
       game.min_number_of_players_per_team > game.max_number_of_players_per_team
      game.errors.add(:max_number_of_teams, "cannot be less than the minimum")
    end
  end

  validate do |game|
    if game.rating_type_was && game.rating_type_changed?
      game.errors.add(:rating_type, "cannot be changed")
    end
  end

  validates :allow_ties, inclusion: { in: [true, false], message: "must be selected" }

  def default_values
    if self.rating_type == 'elo'
        self.min_number_of_teams = 2
        self.max_number_of_teams = 2
        self.min_number_of_players_per_team = 1
        self.max_number_of_players_per_team = 1
    end
  end

  def owner; self.player; end

  def all_ratings
    ratings.order(value: :desc)
  end

  def players
    ratings.map(&:player)
  end

  def recent_results
    results.order("created_at DESC").limit(20)
  end

  def top_ratings
    ratings.order("value DESC").limit(5)
  end

  def rater
    RATER_MAPPINGS[rating_type]
  end

  def recalculate_ratings!
    RatingHistoryEvent.joins(:rating).where(ratings: {game_id: self.id}).destroy_all
    Rating.where(game_id: self.id).destroy_all

    results.order("id ASC").all.each do |result|
      rater.update_ratings self, result.teams.order("rank ASC")
    end
  end

  def can_edit?(user)
    user.is_admin == true || user.id == player_id
  end
end
