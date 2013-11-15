class PendingtasksController < ApplicationController
	def new
		@user=User.find(params[:user_id])
		@pendingtask=Pendingtask.new
	end

	def create
		@user=User.find(params[:user_id])
		@pendingtask=@user.pendingtasks.build(pendingtask_params)
		@pendingtask.user_id=current_user.id #need user id to give review.user something
		#since reviews belong to users they get the id from current
		@pendingtask.points=0
		if @pendingtask.save
			redirect_to @user
		else
			render 'new'
		end
	end

	def yes
		@user=User.find(params[:user_id])
		@pendingtask=@user.pendingtasks.find_by_id(params[:id])
		@pendingtask.points+=1
		@pendingtask.save

		redirect_to @user
	end

	def no
		@user=User.find(params[:user_id])
		@pendingtask=@user.pendingtasks.find_by_id(params[:id])
		@pendingtask.points-=1
		@pendingtask.save
		redirect_to @user
	end

	private
	def pendingtask_params
		params.require(:pendingtask).permit(:text, :assignee_id, :voter_ids)
	end
end
