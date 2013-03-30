class Tasklist < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  has_many :tasks, :dependent => :destroy
  validates_presence_of :title
  attr_accessible :title, :key
end