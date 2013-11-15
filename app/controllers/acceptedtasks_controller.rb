class AcceptedtasksController < ApplicationController
	def new
	end

	def create
		@user=User.find(params[:user_id])
		@acceptedtask=@user.acceptedtasks.build(acceptedtask_params)
		@acceptedtask.user_id=current_user.id #need user id to give review.user something
		#since reviews belong to users they get the id from current
		if @acceptedtask.save
			redirect_to @user
		else
			
		end
	end

	private
	def acceptedtask_params
		params.require(:acceptedtask).permit(:text, :user_id)
	end
end
