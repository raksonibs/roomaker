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

	def new
		@group = Group.new
	end

	def create
		@group = Group.new(group_params)
		useringroup=false
		@user=current_user
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
		params.require(:group).permit(:name)
	end
end
