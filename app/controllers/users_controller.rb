class UsersController < ApplicationController

  before_filter :delete_tasks
  def new
  	@user=User.new
  end

  def create
  	@user=User.new(user_params)
  	if @user.save
  		redirect_to "/welcome_path", :notice => "Signed up!"
  	else
  		render "new"
  	end
  end

   def show
		@user=User.find(params[:id])
    @pendingtasks=@user.pendingtasks
    
		session[:user_id]=@user.id
    @acceptedtasks = @user.acceptedtasks
    @currenttasks= @user.currenttasks
    @completedtasks = @user.completedtasks
    @groups=@user.groups
	end

  private
  def user_params
  	params.require(:user).permit(:email,:password, :password_confirmation, :name)
  end

  def delete_tasks
    if params[:id]
      @currentguy=User.find_by_id(current_user.id)

      @currentguy.pendingtasks.each do |task|

        if task.points >= task.threshold
          assigned = task.assignee_id.to_i
          @user = User.find_by_id(assigned)
          @user.currenttasks.create!({text: task[:text],
                                      completer_id:@user.id}) unless @user.currenttasks.include? Currenttask.find_by_text(task[:text])

          votingids = task.voter_ids.split(" ")
          votingids.each do |id|
            @user=User.find_by_id(id)
            @user.acceptedtasks.create!({text: task[:text]}) unless @user.acceptedtasks.include? Acceptedtask.find_by_text(task[:text]) 
          end

          task.destroy
        end
      end
    end
  end

end
