class ActivitiesController < ApplicationController
  def index
    @revisions = Revision.find(:all, :order => "created_at DESC", :limit => 50, :include => [:page, :user])
  end
end
