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

    @pendingtasks=Pendingtask.all

    
		session[:user_id]=@user.id
    @acceptedtasks = @user.acceptedtasks
    @currenttasks= @user.currenttasks
    @completedtasks = @user.completedtasks
    @groups=@user.groups
    @nods=@user.nods
    @nos=@user.nos
    @incompletetasks=@user.incompletetasks
    def selectmax(pendingtasks,acceptedtasks,completedtasks,currenttasks,incompletetasks)
      arr=[pendingtasks,acceptedtasks,completedtasks,currenttasks,incompletetasks]
      return arr.max_by {|x| x.size }
    end
    @large=selectmax(@pendingtasks,@acceptedtasks,@completedtasks,@currenttasks,@incompletetasks).size
    @grouptasks={}
    @user.groups.each do |group|
      val||=[]
      val <<@user.pendingtasks.where(group: group.name)
      val <<@user.acceptedtasks.where(group: group.name)
      val << @user.currenttasks.where(group: group.name)
      val << @user.completedtasks.where(group: group.name)
      val <<@user.incompletetasks.where(group: group.name)
      @grouptasks[group]=val
    end





	end

  private
  def user_params
  	params.require(:user).permit(:email,:password, :password_confirmation, :name)
  end

  def delete_tasks
    unless current_user==nil
    @currentguy=User.find_by_id(current_user.id)
    @result={}
    @pendingtasks=Pendingtask.all
    @pendingtasks.each do |task|
      @totalyes=task.nods.size
      @totalno=task.nos.size
      @result[task.id] = [@totalyes,@totalno]
      unless @result[task.id]==nil
        if @result[task.id][-1] >= -1*task.negthreshold
          task.destroy
        end
        if @result[task.id][0] >= task.threshold
          assigned = task.assignee_id.to_i
          @user = User.find_by_id(assigned)

          @user.currenttasks.create!({text: task[:text],
                                      group: task[:group],
                                      completer_id:@user.id,
                                      verified: 0}) unless @user.currenttasks.include? Currenttask.find_by_text(task[:text]) || @user==nil

          votingids = task.voter_ids.split(" ")
          votingids.each do |id|
            @user=User.find_by_id(id)
            if @user.id!=task.assignee_id.to_i
              @user.acceptedtasks.create!({text: task[:text], group: task[:group], completer_id: task[:assignee_id]}) unless @user.acceptedtasks.include? Acceptedtask.find_by_text(task[:text])
            end 
 
          end
        
          task.destroy
        end
      end
    end
  end
  end

end
