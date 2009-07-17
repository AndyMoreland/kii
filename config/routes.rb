ActionController::Routing::Routes.draw do |map|
  map.root :controller => "pages", :action => "to_homepage", :conditions => {:method => :get}
  
  # Everything that isn't page related gets a prefix, so that we don't get
  # conflicting page names and internal routes.
  map.with_options :path_prefix => "_" do |m|
    m.resource :search, :only => [:show]
    m.resource :profile, :only => [:edit, :update]
    m.resource :session
    m.logout 'logout', :controller => "sessions", :action => "destroy"
    m.resources :users
    
    m.resources :activities, :only => [:index]
  end
  
  # Can't do map.resources here, since we want /foo, not /pages/foo.
  map.with_options :controller => "pages" do |m|
    m.all_pages "all_pages", :path_prefix => "_", :action => "index"
    
    m.page ":id", :action => "show",            :conditions => {:method => :get}
    m.new_page "new/:id", :action => "new",  :conditions => {:method => :get}
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
