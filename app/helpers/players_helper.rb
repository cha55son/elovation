module PlayersHelper
  def player_badge(player, options={}, &block)
    options = {
      html_options: { class: '' },
      img_size: 24,
      list_group_item: false,
      has_link: true,
      link: player_path(player)
    }.deep_merge options
    options[:html_options][:class] += ' player-badge'
    html = render partial: 'shared/player_badge', locals: {
      player: player,
      options: options
    }
    yield html if block_given?
    html unless block_given?
  end
end
