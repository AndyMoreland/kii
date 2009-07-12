module ApplicationHelper
  def last_updated_at(page)
    %{Last updated #{page_timestamp(page.updated_at)}}
  end
  
  def page_timestamp(time)
    %{#{time.strftime("%B %d %Y, %H:%M")}}
  end
end