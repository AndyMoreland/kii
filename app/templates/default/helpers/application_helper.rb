module ApplicationHelper
  def last_updated_at(page)
    %{Last updated #{page_timestamp(page.updated_at)}}
  end
  
  def page_timestamp(time)
    %{#{time.strftime("%B %d %Y, %H:%M")}}
  end
  
  def revision_author_stamp(revision)
    revision.user_id ? link_to(revision.user.login, user_path(revision.user)) : revision.remote_ip
  end
end