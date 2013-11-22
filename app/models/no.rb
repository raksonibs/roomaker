class No < ActiveRecord::Base
	belongs_to :pendingtask
	belongs_to :user
end
