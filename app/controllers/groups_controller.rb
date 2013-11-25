class GroupsController < ApplicationController
	def index
		@groups = Group.all
		
	end

	def leave
		@user=current_user
		@group=Group.find_by_id(params[:group_id])
		@user.groups.delete(@group)
			
		redirect_to "/groups"
	end

	def invite
		@group=Group.find_by_id(params[:group_id])

	end

	def invitesearch
		user=User.find_by_name(params[:name])
		 ingroupalready= user==nil ? true : false
		user.groups.each do |group|
			ingroupalready=true if group.id==params[:group_id].to_i
		end 

		if user!=nil && ingroupalready==false
			#might need invite model which then creates an invite for a user. if they accept invite, join group.
			#have to go user.invites (user has many invites and invites belong to user) on their welcome page, 
			user.invites << Invite.new({:creator_id=>current_user.id,
										:group_id=>params[:group_id].to_i
										})
			flash[:notice]= "Invite sent to #{user.name}"
			redirect_to "/welcome/index"
		else
			if user==nil
				flash[:error]= "Could not find person"
			elsif ingroupalready!=[]
				flash[:error]= "Person already belongs to group"
			end
			redirect_to "/groups/#{params[:group_id]}/invite"
		end
		#{"utf8"=>"✓", "authenticity_token"=>"ArAqpTPyKlLq+IrQaKBp0VolZM5es511P26L57MHVsY=", 
		#{}"name"=>"sfsfsf", "commit"=>"Invite Friend", "controller"=>"groups", "action"=>"invitesearch", 
		#{}"group_id"=>"12"}
	end

	def new
		@group = Group.new
	end

	def create
		@group = Group.new(group_params)
		useringroup=false
		@user=current_user
		@group.creator_id=current_user.id
		useringroup= true if @user.groups.where(name: @group.name).size>0

		if @group.save && !useringroup
			
			@group.users << @user unless @group.users.include? @user
			redirect_to "/users/#{current_user.id}"
		else
			@group.delete
			flash[:error]= "You already belong to a group with that name!"
			redirect_to new_group_path
		end
	end

	def show
		@group = Group.find(params[:id])
	end

	def edit
		@group = Group.find(params[:id])
		@user = current_user

		if @group.save
			@group.users << @user unless @group.users.include? @user
			@user.invites.each do |i|
				i.delete if i.group_id==@group.id
			end
			redirect_to "/users/#{current_user.id}"
		end
	end

	def update 
		@group = Group.find(params[:id])
		@user = current_user


		if @group.update_attributes(group_params)
			@group.users << @user unless @group.users.include? @user
			redirect_to "/users/#{current_user.id}"
		else
			render :edit
		end
	end

	def delete
		@group = Group.find(params[:id])
		@group.destroy
		redirect_to current_user
	end

	private
	def group_params
		params.require(:group).permit(:name, :creator_id)
	end
end
