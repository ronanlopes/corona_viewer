class TweetsController < ApplicationController

  load_and_authorize_resource

  def flash_notice
    "#{I18n.t("activerecord.models.tweet.one")} #{I18n.t("activerecord.messages.#{action_name}_success")}"
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: TweetsDatatable.new(view_context) }
    end
  end

  def new
    @tweet = Tweet.new
    render "new", :layout => !request.xhr?
  end

  def edit
    render "edit", :layout => !request.xhr?
  end

  def create
    @tweet = Tweet.new(tweet_params)

    respond_to do |format|
      if @tweet.save
        format.html {
          flash[:notice] = flash_notice
          redirect_to action: "index"
        }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :new }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html {
          flash[:notice] = flash_notice
          redirect_to action: "index"
        }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :edit }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html {
        flash[:notice] = flash_notice
        redirect_to action: "index"
      }
      format.json { head :no_content }
    end
  end


private
  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def tweet_params
    params.require(:tweet).permit()
  end

end

