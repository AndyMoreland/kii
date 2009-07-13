require 'test_helper'

class MarkupTest < ActiveSupport::TestCase
  test "page links to none existing pages" do
    @html = parse("Hello, world. [[Home]]")
    assert_html("a.pagelink.exists")
  end
  
  test "page links to existing pages" do
    @html = parse("Hello, world. [[Does not exist]]")
    assert_html("a.pagelink:not(.exists)")
  end
  
  test "page links with custom link text" do
    @html = parse("Hello, world. [[Custom text|Home]]")
    assert_html("a.pagelink.exists")
    assert @html =~ /<a[^>]+>Custom text<\/a>/
  end
  
  private
  
  def parse(markup)
    Kii::Markup.new(markup, ActionView::Base.new).to_html
  end
  
  def assert_html(selector)
    assert count_nodes(@html, selector) > 0
  end
  
  def count_nodes(html, selector)
    HTML::Selector.new(selector).select(HTML::Document.new(html).root).size
  end
end
