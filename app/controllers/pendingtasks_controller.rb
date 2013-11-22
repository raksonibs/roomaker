class PendingtasksController < ApplicationController


	def new
		@user=User.find(current_user.id)
		@pendingtask=Pendingtask.new
		@groups=@user.groups
	end

	def create
		@user = User.find_by_id(current_user.id)
		@pendingtask = Pendingtask.new(pendingtask_params)
		@pendingtask.users << current_user
		@pendingtask.voter_ids= @pendingtask.voter_ids + " " + current_user.id.to_s
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
        group.users.each do |user| #need to add voter ids
           if testing.include?(@pendingtask.assignee_id)
            ids_in << true
           else
            ids_in << false
           end
      end
      debugger
 	
    if @pendingtask.save && (@user.id.to_s != stringofids[-2]) && !(ids_in.any?{|c| c==false})
				
				stringofids.split(" ").each do |id|
				#check id
					User.all.each do |user|
					#connects to id condition so not four times
						if (user.id).to_i == id.to_i && !(@user.id == params[:pendingtask][:assignee_id].to_i)
	
							@pendingtask.users << user
							debugger
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
		@pendingtask=Pendingtask.find_by_id(params[:id]) #gets task they want to vote on
        @nod=@pendingtask.nods << Nod.new({amount:1,
        									:user_id=> @user.id})
        @user.nos.each do |no|
        	no.delete if no.pendingtask.id==@pendingtask.id
        end

		redirect_to @user

	end

	def no
		@user=User.find(params[:user_id])
		@pendingtask=Pendingtask.find_by_id(params[:id])
		@no=@pendingtask.nos << No.new({amount:1,
        								:user_id=>@user.id})
		
		 @user.nods.each do |nod|
        	nod.delete if nod.pendingtask.id==@pendingtask.id
        end

		redirect_to @user
	end

	private
	def pendingtask_params
		params.require(:pendingtask).permit(:text, :assignee_id, :voter_ids, :group, :threshold, :filler_id, :user_id)
	end
end