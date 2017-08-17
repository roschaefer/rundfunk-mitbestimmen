class UsersController < ApplicationController
  skip_authorization_check only: %i[show update]
  before_action :authenticate_user

  # GET /users/1
  def show
    render json: current_user
  end

  # PATCH/PUT /users/1
  def update
    if current_user.update(user_params)
      render json: current_user
    else
      render json: current_user, status: :unprocessable_entity, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  private

  def user_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: %i[latitude longitude])
  end
end
