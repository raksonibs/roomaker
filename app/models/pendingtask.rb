class Pendingtask < ActiveRecord::Base
	belongs_to :user
	validates :assignee_id,:presence=>true
	has_many :pendingvotes
	has_many :nods
	has_many :nos
end
