class Friend < ActiveRecord::Base

attr_accessible :user_id, :invitetoken
belongs_to :user
default_scope :order => 'created_at DESC'
validates_presence_of :user_id

end
