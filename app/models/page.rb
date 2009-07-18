class Page < ActiveRecord::Base
  has_many :revisions do
    def current
      first
    end
  end
  
  before_save :create_permalink
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
  
  def build_revision
    revisions.build(revision_attributes)
  end
end
