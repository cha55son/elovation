class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable
  before_validation :downcase_username
  before_destroy :destroy_results
  has_and_belongs_to_many :teams
  validates :username, allow_blank: false, presence: true
  validates_uniqueness_of :username, case_sensitive: false

  has_many :ratings, dependent: :destroy do
    def find_or_create(game)
      where(game: game).first || create({game: game, pro: false}.merge(game.rater.default_attributes))
    end
  end

  has_many :results, through: :teams do
    def against(opponent)
      joins("INNER JOIN teams AS other_teams ON results.id = other_teams.result_id")
        .where("other_teams.id != teams.id")
        .joins("INNER JOIN players_teams AS other_players_teams ON other_teams.id = other_players_teams.team_id")
        .where("other_players_teams.player_id = ?", opponent)
    end

    def losses
      where("teams.rank > ?", Team::FIRST_PLACE_RANK)
    end

    def wins
      where(teams: {rank: Team::FIRST_PLACE_RANK})
    end
  end

  def downcase_username
    self.username = self.username.downcase
  end

  def self.find_by_username(username)
      find(:all, :conditions => ["username = lower(?)", username]) 
  end

  def detroy_results
    results.each { |result| result.destroy }
  end

  def as_json
    {
      name: name,
      email: email,
      username: username
    }
  end

  def recent_results
    results.order("created_at DESC").limit(5)
  end

  def rewind_rating!(game)
    rating = ratings.where(game_id: game.id).first
    rating.rewind!
  end

  # Hold over to satisfy devise's :database_authenticatable
  def encrypted_password; end
  def encrypted_password=(val); end
end
