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

	private
	def currenttask_params
		params.require(:currenttask).permit(:text, :user_id)
	end
end
end
