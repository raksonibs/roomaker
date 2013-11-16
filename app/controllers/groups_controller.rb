class GroupsController < ApplicationController
	def index
		@groups = Group.all
	end

	def new
		@group = Group.new
	end

	def create
		@group = Group.new(group_params)
		if @group.save
			@user=current_user
			@group.users << @user
			redirect_to "/users/#{current_user.id}"
		else
			render :new
		end
	end

	def show
		@group = Group.find(params[:id])
	end

	def edit
		@group = Group.find(params[:id])
		@user = current_user

		if @group.save
			@group.users << @user
			redirect_to "/groups"
		end
	end

	def update 
		@group = Group.find(params[:id])
		@user = current_user

		if @group.update_attributes(group_params)
			@group.users << @user
			redirect_to "/users/#{current_user.id}"
		else
			render :edit
		end
	end

	def delete
		@group = Group.find(params[:id])
		@group.destroy
		redirect_to "/users/#{current_user.id}"
	end

	private
	def group_params
		params.require(:group).permit(:name)
	end
end
