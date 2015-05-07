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
    options = {
        filter_html: true,
        hard_wrap: true, 
        link_attributes: { rel: 'nofollow', target: "_blank" },
        space_after_headers: true, 
        fenced_code_blocks: true
    }
    extensions = {
        autolink: true,
        superscript: true,
        prettify: true
    }
    renderer = Redcarpet::Render::HTML.new(options)
    @markdown = Redcarpet::Markdown.new(renderer, extensions)
  end

  def parse_markdown(text)
    @markdown.render(text || '').html_safe
  end
end
