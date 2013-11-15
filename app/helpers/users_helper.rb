module UsersHelper
	def smallimage 
      "http://graph.facebook.com/#{self.uid}/picture?type=small" 
    end
end
