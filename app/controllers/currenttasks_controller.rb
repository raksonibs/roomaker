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

		@currentguy.currenttasks.each do |task|
			task.user_id
			@currentguy.completedtasks.create!({text:task[:text],
				                           completer_id:task[:completer_id]})
			User.all.each do |user|
				user.acceptedtasks.each do |atask|
					if atask[:text]==task[:text]
						user.completedtasks.create!({text:task[:text],
				                           completer_id:task[:completer_id]})
					end
				end
			end
			task.destroy
		end
		redirect_to @currentguy
	end

	private
	def currenttask_params
		params.require(:currenttask).permit(:text, :user_id, :completer_id)
	end
end

