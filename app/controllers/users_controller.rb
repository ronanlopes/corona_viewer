class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :destroy]

  load_and_authorize_resource

  def flash_notice
    "#{I18n.t("activerecord.models.user.one")} #{I18n.t("activerecord.messages.#{action_name}_success")}"
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: UsersDatatable.new(view_context) }
    end
  end

  def new
    @user = User.new
    render "new", :layout => !request.xhr?
  end

  def edit
    render "edit", :layout => !request.xhr?
  end

  def create
    @user = User.new(user_params)

    if !@user.password.present?
      @password = "%06d" % (rand*1000000)
      @user.password = @password
      @user.password_confirmation = @password
    end

    if  @user.save
      UserMailer.signup_email(@user, @user.password).deliver
      respond_to do |format|
        redirect_action_success(format)
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        redirect_action_success(format)
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      redirect_action_success(format)
    end
  end


  private

    def redirect_action_success(format)
      format.html {
        redirect_to users_path, notice: flash_notice
      }
    end

    def set_user
      @User = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:nome, :sobrenome, :email, :perfil_id, :password, :current_password, :password_confirmation)
    end

end
