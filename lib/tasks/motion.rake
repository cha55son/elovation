namespace :motion do
  desc "Clear any motion on games that longer than [seconds]."
  task :clear, [:seconds] => :environment do |t, args|
    seconds = (args[:seconds] || 30).to_i
    Rails.logger.info "Clearing games with motion greater than #{seconds} seconds..."
    Game.all.find_each do |game|
      next if game.motion_active_at.nil?
      game.motion_active_at = nil if (Time.new - game.motion_active_at) >= seconds
      game.save
    end
    Rails.logger.info "Finished clearing games."
  end
end
