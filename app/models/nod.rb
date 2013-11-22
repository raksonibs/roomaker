class Nod < ActiveRecord::Base
	belongs_to :pendingtask
	belongs_to :user
end
