class CompletedtasksController < ApplicationController
	def new
	end

	def show
		
	end

	def create
		@user=User.find(params[:user_id])
		@completedtask=@user.completedtasks.build(completedtask_params)
		@completedtask.user_id=current_user.id #need user id to give review.user something
		#since reviews belong to users they get the id from current
		if @completedtask.save
			redirect_to @user
		else
			render 'new'
		end
	end

	private
	def completedtask_params
		params.require(:completedtask).permit(:text, :user_id)
	end
end
