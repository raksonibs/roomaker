class Pendingtask < ActiveRecord::Base
	belongs_to :user
	validates :assignee_id,:presence=>true
	has_many :pendingvotes
end
