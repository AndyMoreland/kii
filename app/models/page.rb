class Page < ActiveRecord::Base
  has_many :revisions do
    def current
      ordered.first
    end
  end
  
  before_save :create_permalink, :bump_timestamps
  before_validation :build_revision
  
  validates_presence_of :title, :revision_attributes
  validates_associated :revisions
  
  attr_accessor :revision_attributes
  
  def to_param
    permalink
  end
  
  private
  
  def create_permalink
    self.permalink = self.title.to_permalink
  end
  
  # Saving a page normally involves creating a new revision, and leaving the
  # page itself unchanged. AR won't update the timestamps, so we force it to
  # here.
  def bump_timestamps
    self.updated_at = Time.now.utc
  end
  
  def build_revision
    revisions.build(revision_attributes)
  end
end
