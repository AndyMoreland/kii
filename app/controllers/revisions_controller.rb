class RevisionsController < ApplicationController
  
  before_filter :find_page
  before_filter :find_revision, :only => [:show, :edit, :revert]
  
  def index
    @revisions = @page.revisions.with_user
  end
  
  def show
  end
  
  def confirm_revert
  end
  
  def revert
    @revision.revert_to!
    redirect_to @page
  end
    
  private
  
    def find_page
      @page = Page.find_by_permalink!(params[:page_id])
    end
    
    def find_revision
      @revision = @page.revisions.find_by_number(params[:id])
    end
end
