require 'test_helper'

class PageTest < ActiveSupport::TestCase
  test "validity of factory page" do
    assert new_page.valid?
  end
  
  test "won't create without body" do
    page = new_page(:revision_attributes => {:body => nil})
    assert !page.valid?
  end
  
  test "won't update without body" do
    page = create_page
    page.revision_attributes = {:body => nil}
    assert !page.valid?
  end
  
  test "incrementing revision number" do
    page = create_page
    assert_equal 1, page.revisions.last.number
    
    update_page(page, {:body => "updated"})
    page.save
    assert_equal 2, page.revisions.last.number
    
    update_page(page, {:body => "updated, again!"})
    page.save
    assert_equal 3, page.revisions.last.number
  end
  
  test "revision numbers across pages" do
    page_a = create_page(:title => "Page A")
    assert_equal 1, page_a.revisions.last.number
    
    page_b = create_page(:title => "Page B")
    assert_equal 1, page_b.revisions.last.number
  end
  
  test "reverting to a specific revision" do
    page = create_page(:title => "A Page")
    assert_equal page.title, "A Page"
    update_page(page, { :body => "updated" })
    update_page(page, {:body => "updated, again!"})
    puts page.revisions.inspect 
    assert_equal 2, page.revisions.count
    
  end
  
  def new_page(attrs = {})
    Page.new(attrs.reverse_merge!(:title => "A new page!", :revision_attributes => {:body => "ai"}))
  end
  
  def create_page(attrs = {})
    page = new_page(attrs)
    page.save
    page
  end
  
  def update_page(page, attrs={})
    page.revision_attributes = attrs
  end
end
