class RevisionsController < ApplicationController
  def index
    @page = Page.find_by_permalink!(params[:page_id])
    @revisions = @page.revisions.with_user
  end
  
  def show
    @page = Page.find_by_permalink!(params[:page_id])
    @revision = @page.revisions.find_by_revision_number(params[:id])
  end
  
  def confirm_revert
    @page = Page.find_by_permalink!(params[:page_id])
    @revision = @page.revisions.find_by_revision_number(params[:id])
  end
end
