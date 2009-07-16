class PagesController < ApplicationController
  before_filter :require_write_access, :except => [:index, :show]
  
  def to_homepage
    redirect_to page_path(Kii::CONFIG[:home_page])
  end
  
  def index
    @pages = Page.find(:all, :order => "title")
  end
  
  def show
    @page = Page.find_by_permalink(params[:id])
    
    if permalink_is_pretty?(params[:id])
      if @page
        render
      else
        @page = Page.new(:title => params[:id].from_permalink)
        render :action => "404"
      end
    else
      redirect_to page_path(params[:id].to_permalink)
    end
  end
  
  def new
    if permalink_is_pretty?(params[:title])
      @page = Page.new(:title => params[:title].from_permalink)
    else
      redirect_to new_page_path(params[:title].to_permalink)
    end
  end
  
  def create
    track_request_metadata
    @page = Page.new(params[:page])
    
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
    
    if used_preview_button?
      @page.attributes = params[:page]
      preview
    else
      track_request_metadata
      @page.update_attributes!(params[:page])
      redirect_to page_path(@page)
    end
  end
  
  private
  
  def used_preview_button?
    !params[:preview].blank?
  end
  
  def preview
    @revision = Revision.new(params[:page][:revision_attributes])
    render :action => "preview"
  end
  
  def permalink_is_pretty?(permalink)
    CGI.unescape(permalink).to_permalink == permalink
  end
  
  def track_request_metadata
    params[:page][:revision_attributes].merge!({
      :remote_ip => request.remote_ip,
      :referrer => request.referrer,
      :user_id => current_user.try(:id)
    })
  end
end
