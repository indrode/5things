class Tasklist < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  has_many :tasks, :dependent => :destroy
  validates_presence_of :title


  # not ActiveRecord; move out:
  def self.new_key(length=20)
    s = ''
    length.times do
      s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr
    end
    s
  end
end