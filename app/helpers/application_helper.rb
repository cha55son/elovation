module ApplicationHelper
  def gravatar_url(player, options = {})
    options.assert_valid_keys :size
    size = options[:size] || 32
    digest = player.email.blank? ? "0" * 32 : Digest::MD5.hexdigest(player.email)
    "//www.gravatar.com/avatar/#{digest}?d=mm&s=#{size}"
  end

  def format_time(time)
    "#{time_ago_in_words(time)} ago"
  end

  def player_options
    Player.order("name ASC").all.map { |player| [player.name, player.id] }
  end
end
