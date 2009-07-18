require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  def setup
    Kii::CONFIG[:public_write] = true
    activate_authlogic
  end
  
  test "to_homepage" do
    get :to_homepage
    assert_response :redirect
  end
  
  test "index/all pages" do
    get :index
    assert_response :success
  end
  
  test "showing existing page" do
    get :show, :id => pages(:sandbox).to_param
    assert_response :success
    assert_template "pages/show"
  end
  
  test "showing none existing page" do
    get :show, :id => "Does Not Exist".to_permalink
    assert_response :success
    assert_template "pages/404"
  end
  
  test "new" do
    get :new, :id => "New Page".to_permalink
    assert_response :success
  end
  
  test "successful create" do
    ActionController::TestRequest.any_instance.expects(:remote_ip).returns("1.2.3.4").at_least_once
    ActionController::TestRequest.any_instance.expects(:referrer).returns("/testing").at_least_once
    
    assert_difference("Page.count") do
      post :create, :page => {
        :title => "New Page",
        :revision_attributes => {:body => "The body"}
      }
    end
    
    assert_redirected_to page_path("New Page".to_permalink)
    
    assert_equal "1.2.3.4", assigns(:page).revisions.current.remote_ip
    assert_equal "/testing", assigns(:page).revisions.current.referrer
    assert_equal nil, assigns(:page).revisions.current.user
  end
  
  test "successful create when logged in" do
    UserSession.create(users(:admin))
    
    assert_difference("Page.count") do
      post :create, :page => {
        :title => "New Page",
        :revision_attributes => {:body => "The body"}
      }
    end
    
    assert_equal users(:admin), assigns(:page).revisions.current.user
  end
  
  test "preview on create" do
    PagesController.any_instance.expects(:used_preview_button?).returns(true)
    
    assert_no_difference("Page.count") do
      post :create, :page => {
        :title => "New Page",
        :revision_attributes => {:body => "The body"}
      }
    end
    
    assert_equal "The body", assigns(:revision).body
    assert_response :success
    assert_template "pages/preview"
  end
  
  test "ajax preview on create" do
    PagesController.any_instance.expects(:used_preview_button?).returns(true)
    
    assert_no_difference("Page.count") do
      xhr :post, :create, :page => {
        :title => "New Page",
        :revision_attributes => {:body => "The body"}
      }
    end
    
    assert_response :success
    assert_template nil
  end
  
  test "edit" do
    get :edit, :id => pages(:sandbox).to_param
    assert_response :success
    assert_equal pages(:sandbox).revisions.current.body, assigns(:revision).body
    assert assigns(:revision).message.blank?
  end
  
  test "successful update" do
    ActionController::TestRequest.any_instance.expects(:remote_ip).returns("6.6.6.6").at_least_once
    ActionController::TestRequest.any_instance.expects(:referrer).returns("/foo").at_least_once
    
    post :update, :id => pages(:sandbox).to_param, :page => {
      :revision_attributes => {:body => "A new body"}
    }
    
    assert_equal "6.6.6.6", assigns(:page).revisions.current.remote_ip
    assert_equal "/foo", assigns(:page).revisions.current.referrer
    assert_equal nil, assigns(:page).revisions.current.user
  end
  
  test "successful update when logged in" do
    UserSession.create(users(:admin))
    
    post :update, :id => pages(:sandbox).to_param, :page => {
      :revision_attributes => {:body => "A new body"}
    }
    
    assert_equal users(:admin), assigns(:page).revisions.current.user
  end
  
  test "preview on update" do
    PagesController.any_instance.expects(:used_preview_button?).returns(true)
    
    post :update, :id => pages(:sandbox).to_param, :page => {
      :revision_attributes => {:body => "A new body"}
    }
    
    assert_equal "A new body", assigns(:revision).body
    assert_response :success
    assert_template "pages/preview"
  end
  
  test "ajax preview on update" do
    PagesController.any_instance.expects(:used_preview_button?).returns(true)
    
    xhr :put, :update, :id => pages(:sandbox).to_param, :page => {
      :revision_attributes => {:body => "A new body"}
    }
    
    assert_response :success
    assert_template nil
  end
  
  test "pretty permalinks" do
    get :show, :id => "Not a pretty permalink"
    assert_redirected_to page_path("Not a pretty permalink".to_permalink)
    
    get :new, :id => "Not so pretty either"
    assert_redirected_to new_page_path("Not so pretty either".to_permalink)
  end
  
  test "without write access" do
    Kii::CONFIG[:public_write] = false
    assert_raises(ApplicationController::LacksWriteAccess) {
      get :new, :id => "New Page".to_permalink
    }
  end
end
