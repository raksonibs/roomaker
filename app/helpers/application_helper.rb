module ApplicationHelper
	def selectmax(pendingtasks,acceptedtasks,completedtasks,currenttasks,incompletetasks)
      arr=[pendingtasks,acceptedtasks,completedtasks,currenttasks,incompletetasks]
      return arr.max_by {|x| x.size }.size
    end
end
