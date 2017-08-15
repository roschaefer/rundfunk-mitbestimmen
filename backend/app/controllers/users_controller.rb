class UsersController < ApplicationController
  skip_authorization_check only: %i[show]
  # GET /users/1
  def show
    render json: current_user
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.fetch(:user, {})
  end
end
