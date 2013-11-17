class PendingtasksController < ApplicationController

	before_filter :delete

	def new
		@user=User.find(params[:user_id])
		@pendingtask=Pendingtask.new
		@groups=@user.groups
	end

	def create
		@user = User.find(params[:user_id])
		@pendingtask = @user.pendingtasks.build(pendingtask_params)
		@pendingtask.voter_ids= @pendingtask.voter_ids + " " + current_user.id.to_s
		@pendingtask.user_id=current_user.id #need user id to give pendingtask.user something
		#since pendingtasks belong to users they get the id from current
		@pendingtask.group=Group.find_by_id(params[:pendingtask][:group]).name
		stringofids=params[:pendingtask][:assignee_id]+" "+params[:pendingtask][:voter_ids]
		#stringofids=stringofids + " " + @user.id.to_s unless @user.id.to_s==params[:pendingtask][:assignee_id]
		threshold=((stringofids.split(" ").size.to_f+1)/2.0).ceil
		@pendingtask.threshold=threshold
		#2 4 5 
		testing= stringofids.split(" ").map {|i| i.to_i} << @user.id


		@pendingtask.points = 0
        group = Group.find_by_id(params[:pendingtask][:group])
        @pendingtask.group = group.name
        ids_in = []
        group.users.each do |i|
           if testing.include? i.id
           	ids_in << true
           else
           	ids_in == nil
           end
    	end

 
		if @pendingtask.save && (@user.id.to_s != stringofids[-2]) && (ids_in != nil)
			#debugger
				
				stringofids.split(" ").each do |id|
				#check id
					User.all.each do |user|
					#connects to id condition so not four times
						if (user.id).to_i == id.to_i
	
							User.find_by_id(id).pendingtasks.create!({text:@pendingtask[:text],
						                                       		assignee_id:@pendingtask[:assignee_id],
						                                       		voter_ids:@pendingtask[:voter_ids],
						                                       		points:@pendingtask[:points],
						                                       		group:@pendingtask[:group],
						                                       		threshold:@pendingtask[:threshold]
						                                        })
						end
					end
				#end
			  #cat.pendingtasks.new
			end
			redirect_to @user
		else
			@pendingtask.destroy
			flash[:error]="Didn't work"
			redirect_to "/users/#{current_user.id}/pendingtasks/new"
		end
	end

	def yes

		@user=User.find(params[:user_id]) #gets current user
		@pendingtask=Pendingtask.find_by_id(params[:id]).text #gets task they want to vote on
		User.all.each do |user|

			if user.pendingtasks.find_by_text(@pendingtask)
				val=user.pendingtasks.find_by_text(@pendingtask)
				val.points+=1 
				val.save #for each user's this task, the vote goes up by one now
			end
		end
        #now need to make the yes invisible, for just this user
        session[:yes]=Pendingtask.find_by_id(params[:id])
        session[:no]=nil

		redirect_to @user
	end

	def no
		@user=User.find(params[:user_id])
		@pendingtask=Pendingtask.find_by_id(params[:id]).text
		User.all.each do |user|

			if user.pendingtasks.find_by_text(@pendingtask)
				val=user.pendingtasks.find_by_text(@pendingtask)
				val.points-=1 
				val.save

			end
		end
		#same as above, but need to make the yes invisible just for this user
		session[:no]=Pendingtask.find_by_id(params[:id])
		session[:yes]=nil

		redirect_to @user
	end

	private
	def pendingtask_params
		params.require(:pendingtask).permit(:text, :assignee_id, :voter_ids, :group, :threshold)
	end

	def delete
		if params[:id]
			if Pendingtask.find_by_id(params[:id]).points >= Pendingtask.find_by_id(params[:id]).threshold
				@user1=User.find(params[:user_id])

				@pendingtask=Pendingtask.find_by_id(params[:id])
				assigned=(@pendingtask.assignee_id).to_i
				@user=User.find_by_id(assigned)
				@user.currenttasks.create!({text:@pendingtask[:text]})
				
				votingids=@pendingtask.voter_ids.split(" ")
				votingids.each do |id|
					@user3=User.find_by_id(id)
					@user3.acceptedtasks.create!({text:@pendingtask[:text]})
					@user3.pendingtasks.each do |task| 

						if task[:text]==@pendingtask[:text]
							task.delete
						end
					end
				end


				@pendingtask.destroy
				redirect_to user_path(@user1)
			end
		end

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
