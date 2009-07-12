ActionController::Routing::Routes.draw do |map|
  map.root :controller => "pages", :conditions => {:method => :get}
  
  map.resource :search, :only => [:show]
  map.resource :profile, :only => [:edit, :update]
  map.resource :session
  map.logout 'logout', :controller => "sessions", :action => "destroy"
  map.resources :users
  
  # Can't do map.resources here, since we want /foo, not /pages/foo.
  map.with_options :controller => "pages" do |m|
    m.page ":id", :action => "show",            :conditions => {:method => :get}
    m.new_page "new/:title", :action => "new",  :conditions => {:method => :get}
    m.edit_page ":id/edit", :action => "edit",  :conditions => {:method => :get}
    
    m.pages "", :action => "create",            :conditions => {:method => :post}

    m.connect ":id", :action => "update", :conditions => {:method => :put}
  end
  
  map.with_options :controller => "revisions", :path_prefix => ":page_id" do |m|
    m.page_revisions "revisions", :action => "index",     :conditions => {:method => :get}
    m.page_revision "revisions/:id", :action => "show",   :conditions => {:method => :get}
    m.confirm_revert_page_revision "revisions/:id/confirm_revert", :action => "confirm_revert", :conditions => {:method => :get}
  end  
end
