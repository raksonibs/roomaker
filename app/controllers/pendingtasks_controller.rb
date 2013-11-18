class PendingtasksController < ApplicationController


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
		negthreshold=threshold*-1
		@pendingtask.threshold=threshold
		@pendingtask.negthreshold=negthreshold
		@pendingtask.filler_id=current_user.id
		#2 4 5 
		testing= stringofids.split(" ").map {|i| i.to_i} << @user.id


    	@pendingtask.points = 0

        group = Group.find_by_id(params[:pendingtask][:group])
        @pendingtask.group = group.name
        ids_in = []
        group.users.each do |user|
           if testing.include?(@pendingtask.assignee_id)
            ids_in << true
           else
            ids_in << false
           end
      end

 	
    if @pendingtask.save && (@user.id.to_s != stringofids[-2]) && !(ids_in.any?{|c| c==false})
				
				stringofids.split(" ").each do |id|
				#check id
					User.all.each do |user|
					#connects to id condition so not four times
						if (user.id).to_i == id.to_i && !(@user.id == params[:pendingtask][:assignee_id].to_i)
	
							User.find_by_id(id).pendingtasks.create!({text:@pendingtask[:text],
						                                       		assignee_id:@pendingtask[:assignee_id],
						                                       		voter_ids:@pendingtask[:voter_ids],
						                                       		points:@pendingtask[:points],
						                                       		group:@pendingtask[:group],
						                                       		threshold:@pendingtask[:threshold],
						                                       		negthreshold:@pendingtask[:negthreshold],
						                                       		filler_id:@pendingtask[:filler_id]
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

	def destroy
    if params[:id]
      @usernow=User.find(params[:user_id])
      @pendingtask = Pendingtask.find_by_id(params[:id])

      assignedtask = @pendingtask.assignee_id.to_i
      @userA = User.find_by_id(assignedtask)
        @userA.pendingtasks.each do |task|
          if task[:text] == @pendingtask[:text]
            task.delete
          end
        end

      votertask = @pendingtask.voter_ids.split(" ")
      votertask.each do |id|
        @voter = User.find_by_id(id)
        @voter.pendingtasks.each do |task|
          if task[:text] == @pendingtask[:text]
            task.delete
          end
        end
      end

      @pendingtask.delete
      redirect_to user_path(@usernow)
    end
  end

	def yes

		@user=User.find(params[:user_id]) #gets current user
		@pendingtask=Pendingtask.find_by_id(params[:id]).text #gets task they want to vote on
		User.all.each do |user|

			if user.pendingtasks.find_by_text(@pendingtask)
				val=user.pendingtasks.find_by_text(@pendingtask)
				if session[:no].last==val && session[:lastuser]==@user
					val.pendingvotes.last.destroy
					val.pendingvotes << Pendingvote.new({text:"yes"})
				else
					val.pendingvotes << Pendingvote.new({text:"yes"})
				end
				val.save #for each user's this task, the vote goes up by one now

			end
		end
        #now need to make the yes invisible, for just this user
        session[:yes] << Pendingtask.find_by_id(params[:id])
        session[:lastuser]=@user
        session[:no].delete_at(-1) unless session[:no].last==nil

		redirect_to @user

	end

	def no
		@user=User.find(params[:user_id])
		@pendingtask=Pendingtask.find_by_id(params[:id]).text
		User.all.each do |user|

			if user.pendingtasks.find_by_text(@pendingtask)

				val=user.pendingtasks.find_by_text(@pendingtask)

				if session[:yes].last==val && session[:lastuser]==@user
					val.pendingvotes.last.destroy
					val.pendingvotes << Pendingvote.new({text:"no"})


				else
					val.pendingvotes << Pendingvote.new({text:"no"})
				end
				val.save

			end
		end
		#same as above, but need to make the yes invisible just for this user
		session[:no] << Pendingtask.find_by_id(params[:id])
		session[:yes].delete_at(-1) unless session[:yes].last==nil
		session[:lastuser]=@user
		

		redirect_to @user
	end

	private
	def pendingtask_params
		params.require(:pendingtask).permit(:text, :assignee_id, :voter_ids, :group, :threshold, :filler_id)
	end
end