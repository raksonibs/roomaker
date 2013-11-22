class CurrenttasksController < ApplicationController
	def show
		@user=User.find_by_id(params[:id])
		@currenttasks=@user.currenttasks
	end

	def new
	end

	def create
		@user=User.find(params[:user_id])
		@currenttasks=@user.currenttasks.build(currenttask_params)
		@currenttasks.user_id=current_user.id #need user id to give review.user something
		#since reviews belong to users they get the id from current
		if @currenttasks.save
			redirect_to @user
		else
			
		end
	end

	def delete
		@currentguy = User.find_by_id(current_user.id)
		# if currenttask has been validated then delete.
		#currenttask has valid, belongs to current. so if valid exits for currenttask
		#and guy clicked delete, only then deletes
		#once he clicks confirm, must go on the accepted. SO find all accepted with some text
		#and completer id and group name. THen give them a link to verify if he confirms. 
		# if he clicks confirm, needs to tell him he is waiting.
		#currenttask needs verifiers (voter ids)
		@currentguy.currenttasks.each do |task|
			# check task, taskid, and the guy below

			if task.id == params[:id].to_i #&& task.verified?
				@currentguy.completedtasks.create!({text:task[:text],
												group:task[:group],
				                           		completer_id:task[:completer_id]})
			
			#double here on the other user
				User.all.each do |user|
					user.acceptedtasks.each do |atask|
						if atask[:text]==task[:text] && @currentguy!=user


							user.completedtasks.create!({text:task[:text],
							               		group:task[:group],
				                           		completer_id:task[:completer_id]})
							atask.destroy
						end

					end
				end

			task.destroy
			redirect_to @currentguy
			else
				task

			end


		end
		
	end

	private
	def currenttask_params
		params.require(:currenttask).permit(:text, :user_id, :completer_id, :group)
	end
end

