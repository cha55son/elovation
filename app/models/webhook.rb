class Webhook < ActiveRecord::Base
    belongs_to :game

    validates :url, presence: true
    validates :url, format: { with: URI.regexp }, if: Proc.new { |a| a.url.present? }
end
