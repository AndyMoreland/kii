module ApplicationHelper
  def render_body(body)
    preliminary_page_body_parser(body)
  end
  
  def preliminary_page_body_parser(body)
    body.gsub(/\[\[([^\]\]]+)\]\]/) {|link| inline_page_link($~[1]) }.gsub(/\n+/, "<br/>")
  end
  
  def inline_page_link(permalink)
    page = Page.find_by_permalink(permalink.to_permalink)
    
    if page
      content_tag(:a, page.title, :class => "pagelink exists", :href => page.permalink)
    else
      content_tag(:a, permalink, :class => "pagelink void", :href => permalink.to_permalink)
    end
  end

  def page_title(title)
    @page_title = title
  end
end
