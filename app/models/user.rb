class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :revisions
  
  attr_readonly :login
  
  def to_param
    login
  end
end
