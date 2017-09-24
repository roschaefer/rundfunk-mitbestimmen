class TopicsController < ApplicationController
  before_action :set_topic, except: :index
  load_and_authorize_resource

  # GET /topics
  def index
    @topics = Topic.all
    render json: @topics
  end

  # GET /topics/1
  def show
    render json: @topic
  end

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end
end
