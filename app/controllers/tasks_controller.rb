class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :currect_user, only: [:show, :edit, :update ,:destroy]
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def show
  end
  
  def new
    @task = current_user.tasks.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'Task が正常に作成されました'
      redirect_to @task
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'Task が作成されませんでした'
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @task.update(task_params)
      flash[:success] = 'Task は正常に作成されました'
      redirect_to @task
    else
      flash[:danger] = 'Task は作成されませんでした'
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    
    flash[:success] = 'Task は正常に削除されました'
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  #Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def currect_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
