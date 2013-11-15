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
		stringofids=params[:pendingtask][:voter_ids]+  " "+params[:pendingtask][:assignee_id]
		#2 4 5 


		@pendingtask.points=0
		if @pendingtask.save
			stringofids.split(" ").each do |id|
				#check id
				User.all.each do |user|
					#connects to id condition so not four times
					if (user.id).to_i==id.to_i
	
						User.find_by_id(id).pendingtasks.create!({text:@pendingtask[:text],
						                                       		assignee_id:@pendingtask[:assignee_id],
						                                       		voter_ids:@pendingtask[:voter_ids],
						                                       		points:@pendingtask[:points]
						                                        })
					end


					#debugger 


				end


			  #cat.pendingtasks.new
			end
			redirect_to @user
		else
			render 'new'
		end
	end

	def yes
		@user=User.find(params[:user_id])
		User.all.each do |user|
			user.pendingtasks.each do |task|
			   @task=Pendingtask.find_by_id(params[:id])
			   @task.points+=1 if (task.id).to_i == params[:id].to_i
			   @task.save

			end
		end

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

=begin
@cat=User.find_by_id(id)
			  @pending=@pendingtask
			  @pending.user_id=id.to_i
			  @cat.pendingtasks.create!({text:@pending[:text], 
			  	                           id:@pending[:id],
			  	                           user_id:@pending[:user_id],
			  	                           assignee_id:@pending[:assignee_id],
			  	                           voter_ids:@pending[:voter_ids],
			  	                           created_at:@pending[:created_at],
			  	                           updated_at:@pending[:updated_at],
			  	                           points:@pending[:points]})
=end			  	                   
