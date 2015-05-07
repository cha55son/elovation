class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_player!
  layout 'lumen'

  def initialize
    super
    init_markdown
  end

  private

  def init_markdown
    renderer = Redcarpet::Render::HTML.new({
        filter_html: true,
        no_styles: true,
        hard_wrap: true,
        prettify: true,
        link_attributes: { rel: 'nofollow', target: "_blank" }
    })
    @markdown = Redcarpet::Markdown.new(renderer, {
        autolink: true,
        superscript: true,
        space_after_headers: true, 
        fenced_code_blocks: true
    })
  end

  def parse_markdown(text)
    @markdown.render(text || '').html_safe
  end
end
