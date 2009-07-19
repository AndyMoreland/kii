class Page < ActiveRecord::Base
  # TODO: When Rails 2.3.3 comes out use :touch => true on the association
  has_many :revisions do
    def current
      find_by_current(true)
    end
  end
  
  before_save :create_permalink, :bump_timestamps
  before_validation :build_revision
  before_validation_on_update :detect_stale_revision
  
  validates_presence_of :title, :revision_attributes
  validates_associated :revisions
  
  attr_accessor :revision_attributes
  
  def to_param
    permalink
  end
  
  attr_writer :current_revision_id
  def current_revision_id
    new_record? ? nil : (@current_revision_id ||= revisions.current.id)
  end
  
  private
  
  def create_permalink
    self.permalink = self.title.to_permalink
  end
  
  # TODO: When Rails 2.3.3 comes out use :touch => true on the association
  # Saving a page normally involves creating a new revision, and leaving the
  # page itself unchanged. AR won't update the timestamps, so we force it to
  # here.
  def bump_timestamps
    self.updated_at = Time.now.utc
  end
  
  # We could have used the existing lock_version functionality, but since we
  # already have these revisions we can might as well use them to detect
  # staleness.
  def detect_stale_revision
    puts "current"
    puts current_revision_id
    puts "real current"
    puts revisions.current.id
    puts "*" * 50
    if current_revision_id.to_i != revisions.current.id
      raise ActiveRecord::StaleObjectError
    end
  end
  
  def build_revision
    revisions.build(revision_attributes)
  end
end
