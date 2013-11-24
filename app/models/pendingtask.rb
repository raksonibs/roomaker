class Pendingtask < ActiveRecord::Base
	has_and_belongs_to_many :users
	validates :assignee_id, :text, presence: true
	has_many :pendingvotes
	has_many :nods
	has_many :nos
end
