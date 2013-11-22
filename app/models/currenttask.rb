class Currenttask < ActiveRecord::Base
	belongs_to :user

	def verified?
		self.verifed>0
	end
end
