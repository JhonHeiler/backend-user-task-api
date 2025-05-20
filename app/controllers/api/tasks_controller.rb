class Api::TasksController < ApplicationController
  before_action :set_user, only: %i[index create]

  def index
    tasks = (@user ? @user.tasks : Task).page(params[:page]).per(10)
    render json: tasks
  end

  def show
    render json: Task.find(params[:id])
  end

  def create
    task = (@user || Task).new(task_params.merge(user: @user))
    task.save!
    render json: task, status: :created
  end

  def update
    task = Task.find(params[:id])
    task.update!(task_params)
    render json: task
  end

  def destroy
    Task.find(params[:id]).destroy!
    head :no_content
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end
end
