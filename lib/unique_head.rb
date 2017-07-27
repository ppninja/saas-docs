# Unique header generation
require 'middleman-core/renderers/redcarpet'
class UniqueHeadCounter < Middleman::Renderers::MiddlemanRedcarpetHTML
  def initialize
    super
    @head_count = {}
  end
  def header(text, header_level)
    # 使用 || 分隔英文和中文，用于支持toc锚点
    text, title = text.split(' || ')
    title ||= text

    friendly_text = text.parameterize
    @head_count[friendly_text] ||= 0
    @head_count[friendly_text] += 1
    if @head_count[friendly_text] > 1
      friendly_text += "-#{@head_count[friendly_text]}"
    end
    return "<h#{header_level} id='#{friendly_text}'>#{title}</h#{header_level}>"
  end
end
