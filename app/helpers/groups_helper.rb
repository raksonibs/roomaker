module GroupsHelper
	def themost(group)
		max=0
		maxuser="bob"
 		group.users.each do |u| 
     		usertotal=0 
     		u.completedtasks.each do |ct|
        		if ct.group == group.name
           			usertotal+=1 if u.id==ct.completer_id
        		end
        	end
        	if usertotal>=max
        		max=usertotal 
        		maxuser=u
        	end
		end
		return maxuser

	end

	def theleast(group)
		min=10000
		minuser=nil
		unless group.users.size==1

 			group.users.each do |u| 
     			usertotal=0 
     			u.completedtasks.each do |ct|
        			if ct.group == group.name
           				usertotal+=1 if u.id==ct.completer_id
        			end
        		end
        		if usertotal<=min
        			min=usertotal 
        			minuser=u
        		end
			end
		end
		return minuser
	end


	def mostrecent(group)
		min=0
		minuser=nil
		minid=-1
 		group.users.each do |u| 
     		usertotal=0 
     		u.completedtasks.each do |ct|
        		if ct.group == group.name

        			if min==0 || ct.created_at > min
    
        				min=ct.created_at
        				minid=ct.id

        				minuser=u

        			end
        		end
        	end
        	answer=[minuser,minid]

        	return answer
		end

		
	end

	def leastrecent(group)
		val=[]
		group.users.each do |u|
			val << u.completedtasks.where(group: group.name).first unless u.completedtasks.where(group: group.name).first==nil
		end


		answer=[val.min_by{ |x| x.id }.user_id, val.min_by{ |x| x.id }]
		return answer
	end

	def never(group)
		val={}
		group.users.each do |u|
			val[u]= u.completedtasks.where(group: group.name).first
		end
		
		answer=val.select{|c| val[c]==nil}

		
		return answer
	end
end
