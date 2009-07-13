module ApplicationHelper
  def render_body(body)
    Kii::Markup.new(body, self).to_html
  end
  
  def preliminary_page_body_parser(body)
    body.gsub(/\[\[([^\]\]\|]+)\|?([^\]\]]+)?\]\]/) {|link| inline_page_link($~[1], ($~[2] || $~[1])) }.gsub(/\n+/, "<br/>")
  end
  
  def inline_page_link(link_text, permalink)
    page = Page.find_by_permalink(permalink.to_permalink)
    options = {}
    
    if page
      options[:class] = "pagelink exists"
      options[:href] = page.permalink
    else
      options[:class] = "pagelink void"
      options[:href] = permalink.to_permalink
    end
    
    content_tag(:a, link_text, options)
  end

  def page_title(title)
    @page_title = title
  end
end
