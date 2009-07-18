module Kii
  # Mostly using the wikitext gem. Post-parsing to get those red links.
  class Markup
    PARSER = Wikitext::Parser.new
    # We look for this prefix in the post parsing, so that we can separate page links from
    # other <a> tags. 
    PARSER.internal_link_prefix = "internal_prefix"
    
    def initialize(markup, helper)
      @markup, @helper = markup, helper
    end
    
    def to_html
      return @html if defined?(@html)
      
      # base_heading_level lets us start on h2, since there's already a h1 on all pages.
      @html = PARSER.parse(@markup, :base_heading_level => 1)
      @html.gsub!(%r{<a href="internal_prefix(.*?)">(.*?)</a>}) { page_link(($~[2] || $~[1]), $~[1]) }
      
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
      
      options[:href] = CGI.unescape(options[:href])
      options[:href].force_encoding("UTF-8") if options[:href].respond_to?(:force_encoding)

      @helper.content_tag(:a, link_text, options)
    end
  end
end