class MarkdownController < ApplicationController
  def create
    render text: parse_markdown(params[:text])
  end
end
