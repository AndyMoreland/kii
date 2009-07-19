class Revision < ActiveRecord::Base
  default_scope :order => "#{quoted_table_name}.number desc"
  
  named_scope :with_user, :include => [:user]
  named_scope :for_page, lambda {|page_id| {:conditions => {:page_id => page_id}}}
  
  attr_readonly :body
  
  acts_as_tree
  
  belongs_to :page
  belongs_to :user
  
  before_create :set_parent_and_make_current
  before_create :increment_number
  after_create :set_current_revision_id
  
  validates_presence_of :body
  
  def to_param
    number
  end
  
  def revert_to!
    # To ensure we're never left without at least 1 current page.
    orig_current = page.revisions.current
    self.update_attribute(:current, true)
    page.current_revision_id = self.id
    orig_current.update_attribute(:current, false)
  end
    
    
  
  private
  
  # Dupe code from revert_to... fix later.
  def set_parent_and_make_current
    orig_current = page.revisions.current
    self.parent = page.revisions.current
    self.current = true
    
    # There may not be one.
    if orig_current
      orig_current.current = false
      orig_current.save!
    end
  end
  
  def set_current_revision_id
    self.page.current_revision_id = self.id
    self.page.save if self.page.new_record?
  end
  
  # WARNING: May induce race conditions, be wary.
  def increment_number
    self.number = page.revisions.maximum(:number).to_i + 1
  end
end
