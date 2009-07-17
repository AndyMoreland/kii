require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  def setup
    Kii::CONFIG[:public_write] = true
  end
  
  test "root redirects to home page" do
    get :to_homepage
    assert_redirected_to page_path(Kii::CONFIG[:home_page])
  end
  
  test "page creation form" do
    get :new, :id => "My New Page".to_permalink
    assert_response :success
    
    Kii::CONFIG[:public_write] = false
    assert_raises(ApplicationController::LacksWriteAccess) {
      get :new, :id => "My New Page".to_permalink
    }
  end
  
  test "prettifying permalinks" do
    get :new, :id => "My New Page"
    assert_redirected_to new_page_path("My New Page".to_permalink)
    
    get :show, :id => "Another Page"
    assert_redirected_to page_path("Another Page".to_permalink)
  end
  
  test "previewing" do
    post :create, :preview => "Anything", :page => {
      :title => "Ya",
      :revision_attributes => {:body => "Ay"}
    }
    assert_template "pages/preview"

    post :update, :preview => "Anything", :id => pages(:home).to_param, :page => {
      :revision_attributes => {:body => "Anew."}
    }
    assert_template "pages/preview"
  end
  
  test "previewing via ajax" do
    xhr :post, :create, :preview => "Anything", :page => {
      :title => "Ya",
      :revision_attributes => {:body => "Ay"}
    }
    assert_response :success
    assert_template nil
  end
  
  test "404" do
    get :show, :id => "Does Not Exist".to_permalink
    assert_response :success
    assert_template "pages/404"
  end
  
  test "successful show" do
    get :show, :id => pages(:home).to_param
    assert_response :success
    assert_template "pages/show"
  end
  
  test "editing" do
    get :edit, :id => pages(:home).to_param
    assert_response :success
    assert_template "pages/edit"
  end
  
  test "not persisting message when editing" do
    post :create, :page => {:title => "Ya", :revision_attributes => {:body => "Ay", :message => "Wat."}}
    created_page = assigns(:page)
    
    get :edit, :id => created_page.to_param
    assert_response :success
    assert !assigns(:revision).message
  end
  
  test "successfully creating" do
    assert_difference("Page.count") do
      post :create, :page => {:title => "Ya", :revision_attributes => {:body => "Ay"}}
    end
    
    assert_equal "0.0.0.0", assigns(:page).revisions.current.remote_ip
    assert_equal "/", assigns(:page).revisions.current.referrer
  end
end
