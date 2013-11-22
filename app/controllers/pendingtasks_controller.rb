class PendingtasksController < ApplicationController


	def new
		@user=User.find(current_user.id)
		@pendingtask=Pendingtask.new
		@groups=@user.groups
		@groups.each do |group|
		end
	end

	def create
		#"pendingtask"=>{"text"=>"clean dishes", "assignee_id"=>"Oskar Niburski", "group"=>"1"}, "Oskar Niburski"=>"1", "Kacper Niburski"=>"1"
		@user = User.find_by_id(current_user.id)
		@selfassinger= User.find_by_name(params[:pendingtask][:assignee_id])
		@pendingtask = Pendingtask.new(pendingtask_params)
		@group=Group.find_by_id(params[:pendingtask][:group])
		usersingroup=@group.users
		allin=true
		@voting_ids=[]
		@voters= []
		@pendingtask.assignee_id=@selfassinger.id
		params.keys.each do |name|
			@voting_ids << User.find_by_name(name).id if User.find_by_name(name)!=nil && User.find_by_name(name)!=current_user && User.find_by_name(name)!=@selfassinger
			@voters << User.find_by_name(name) if User.find_by_name(name)!=nil && User.find_by_name(name)!=current_user && User.find_by_name(name)!=@selfassinger
		end
		@voting_ids << @selfassinger.id
		@voting_ids << current_user.id
		@voters << @selfassinger
		@voters << current_user
		@voting_ids.each do |user|
			allin=false if !usersingroup.include?(User.find_by_id(user))
		end
		@pendingtask.users << current_user
		@pendingtask.voter_ids= @voting_ids.join(" ")
		@pendingtask.group=Group.find_by_id(params[:pendingtask][:group]).name
		#voting_ids of all users. stringoids use to be assign to 2 and 3 votes= 2,3. if self assign would be say oskar did, 1,2,3
		#will right voting_ids.each do |user|
	#pendingtask.users << user unless @user=@selfassigner (cause already made) && user.id==@selfassinger.id (not sure about this one)
		#stringofids=stringofids + " " + @user.id.to_s unless @user.id.to_s==params[:pendingtask][:assignee_id]
		threshold=((@voting_ids.size.to_f)/2.0).ceil #need to worry about if even
		negthreshold=threshold*-1
		@pendingtask.threshold=threshold
		@pendingtask.negthreshold=negthreshold
		@pendingtask.filler_id=current_user.id



    	@pendingtask.points = 0

        group = Group.find_by_id(params[:pendingtask][:group])
        @pendingtask.group = group.name

    if @pendingtask.save && allin
			@voters.each do |user|
				debugger
				#tests if current user is the self user, if it is should not read assign to users.
				@pendingtask.users << user if !(user==current_user)
			end
				

			redirect_to @user
			debugger
		else

			flash[:error]="Didn't work"
			render 'new'
			
		end

	end

	def destroy
    if params[:id]
    	@usernow=current_user
      @pendingtask = Pendingtask.find_by_id(params[:id])

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
        	no.delete if no.pendingtask_id==@pendingtask.id
        end

		redirect_to @user

	end

	def no
		@user=User.find(params[:user_id])
		@pendingtask=Pendingtask.find_by_id(params[:id])
		@no=@pendingtask.nos << No.new({amount:1,
        								:user_id=>@user.id})
		
		 @user.nods.each do |nod|
        	nod.delete if nod.pendingtask_id==@pendingtask.id
        end

		redirect_to @user
	end

	private
	def pendingtask_params
		params.require(:pendingtask).permit(:text, :assignee_id, :voter_ids, :group, :threshold, :filler_id, :user_id)
	end
end