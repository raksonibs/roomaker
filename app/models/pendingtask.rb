class Pendingtask < ActiveRecord::Base
	has_many :users
	validates :assignee_id,:presence=>true
	has_many :pendingvotes
	has_many :nods
	has_many :nos
end
