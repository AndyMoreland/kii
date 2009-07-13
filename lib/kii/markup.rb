module Kii
  # Rolling our own. Not sure if this is a good idea.
  class Markup
    def initialize(markup, helper)
      @markup, @helper = markup, helper
    end
    
    def to_html
      return @html if defined?(@html)
      
      @html = @markup.dup
      @html.gsub!(/\[\[([^\]\]\|]+)\|?([^\]\]]+)?\]\]/) { page_link($~[1], ($~[2] || $~[1])) }
      @html.gsub!(/\n+/, "<br/>")
      
      return @html
    end
    
    private
    
    def page_link(link_text, permalink)
      page = Page.find_by_permalink(permalink.to_permalink)
      options = {}

      if page
        options[:class] = "pagelink exists"
        options[:href] = "/" + page.permalink
      else
        options[:class] = "pagelink void"
        options[:href] = "/" + permalink.to_permalink
      end

      @helper.content_tag(:a, link_text, options)
    end
  end
end