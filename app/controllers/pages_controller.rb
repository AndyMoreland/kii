class PagesController < ApplicationController
  before_filter :require_write_access, :except => [:index, :show]
  before_filter :ensure_pretty_permalink, :only => [:show, :new]
  
  def to_homepage
    redirect_to page_path(Kii::CONFIG[:home_page])
  end
  
  def index
    @pages = Page.find(:all, :order => "title")
  end
  
  def show
    @page = Page.find_by_permalink(params[:id])
    
    if @page
      render
    else
      @page = Page.new(:title => params[:id].from_permalink)
      render :action => "404"
    end
  end
  
  def new
    @page = Page.new(:title => params[:id].from_permalink)
  end
  
  def create
    @page = Page.new(params[:page])
    append_request_metadata_to_page
    
    if used_preview_button?
      preview
    else
      @page.save!
      redirect_to page_path(@page)
    end
  end
  
  def edit
    @page = Page.find_by_permalink!(params[:id])
    @revision = @page.revisions.current.clone
    @revision.message = nil
  end
  
  def update
    @page = Page.find_by_permalink!(params[:id])
    @page.attributes = params[:page]
    
    if used_preview_button?
      preview
    else
      append_request_metadata_to_page
      @page.save
      redirect_to page_path(@page)
    end
  end
  
  private
  
  def used_preview_button?
    !params[:preview].blank?
  end
  
  def preview
    @revision = Revision.new(params[:page][:revision_attributes])
    
    if request.xhr?
      # Using render :inline is a bit tacky, but it saves us from creating a
      # separate view for this, or monving the helper into the application
      # controller.
      render :inline => "<%= render_body(@revision.body) %>"
    else
      render :action => "preview"
    end
  end
  
  def ensure_pretty_permalink
    if CGI.unescape(params[:id]).to_permalink != params[:id]
      redirect_to :id => params[:id].to_permalink
    end
  end

  def append_request_metadata_to_page
    @page.revision_attributes.merge!({
      :remote_ip => request.remote_ip,
      :referrer => request.referrer,
      :user_id => current_user.try(:id)
    })
  end
end
