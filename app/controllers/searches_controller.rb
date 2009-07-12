class SearchesController < ApplicationController
  # It's just a lookup now. No search implemented yet.
  def show
    redirect_to page_path(params[:q])
  end
end
