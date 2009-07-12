class Revision < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  
  before_create :increment_revision_number
  attr_readonly :body
  
  validates_presence_of :body
  
  named_scope :ordered, :order => "revision_number DESC"
  named_scope :with_user, :include => [:user]
  named_scope :for_page, lambda {|page_id| {:conditions => {:page_id => page_id}}}

  def current
    self.class.ordered.for_page(page_id).first
  end
  
  def to_param
    revision_number
  end
  
  private
  
  def increment_revision_number
    previous_revision = current
    self.revision_number = previous_revision.try(:revision_number)
    increment(:revision_number)
  end
end
