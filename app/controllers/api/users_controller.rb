class Api::UsersController < ApplicationController
  def index
    users = User.includes(:tasks).all.page(params[:page]).per(10)
    render json: users
  end

  def show
    user = User.includes(:tasks).find(params[:id])
    render json: user
  end
end
