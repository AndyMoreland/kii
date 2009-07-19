require 'test_helper'

class PageTest < ActiveSupport::TestCase
  test "validity of factory page" do
    assert new_page.valid?
  end
  
  test "won't create without body content" do
    page = new_page(:revision_attributes => {:body => ''})
    assert !page.valid?
  end
  
  test "won't update without body content" do
    page = create_page
    page.revision_attributes = {:body => ''}
    assert !page.valid?
  end
  
  test "incrementing revision number" do
    page = create_page
    assert_equal 1, page.revisions.last.number
    
    update_page(page, {:body => "updated"})
    assert_equal 2, page.revisions.last.number
    
    update_page(page, {:body => "updated, again!"})
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
    update_page(page, { :body => "updated" })
    assert_equal 2, page.revisions.count
  end

  test "bumping updated at regardless of there being changes to the page itself" do
    page = pages(:home)
    was_updated_at = page.updated_at

    page.revision_attributes = {:body => "Yep!"}
    page.save
  end

  test "won't create a new revision if old content is the same as new and message is blank" do
    page = create_page(:title => "A new page!", :revision_attributes => { :body => "foo" })
    revision_id = page.current_revision_id
    page.update_attributes(:title => "A new page!", :revision_attributes => { :body => "foo"})
    page.save
    assert_equal revision_id, page.current_revision_id
  end

 test "will create a new revision if old content is the same as new and message is not blank" do
   page = create_page(:title => "A new page!", :revision_attributes => { :body => "foo" })
   revision_id = page.current_revision_id
   page.update_attributes(:title => "A new page!", :revision_attributes => { :body => "foo", :message => "we're making lots of changes round here."})
   page.save
   assert_not_equal revision_id, page.current_revision_id
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
    page.save
    page.current_revision_id = page.revisions.current.id
  end
end
