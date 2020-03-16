class PerfisController < ApplicationController

  load_and_authorize_resource

  def flash_notice
    "#{I18n.t("activerecord.models.perfil.one")} #{I18n.t("activerecord.messages.#{action_name}_success")}"
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: PerfisDatatable.new(view_context) }
    end
  end

  def new
    @perfil = Perfil.new
    render "new", :layout => !request.xhr?
  end

  def edit
    render "edit", :layout => !request.xhr?
  end


  def create
    @perfil = Perfil.new(perfil_params)

    respond_to do |format|
      if @perfil.save
        format.html {
          flash[:notice] = flash_notice
          redirect_to action: "index"
        }
        format.json { render :show, status: :created, location: @perfil }
      else
        format.html { render :new }
        format.json { render json: @perfil.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @perfil.update(perfil_params)
        format.html {
          flash[:notice] = flash_notice
          redirect_to action: "index"
        }
        format.json { render :show, status: :created, location: @perfil }
      else
        format.html { render :edit }
        format.json { render json: @perfil.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @perfil.destroy
    respond_to do |format|
      format.html {
        flash[:notice] = flash_notice
        redirect_to action: "index"
      }
      format.json { head :no_content }
    end
  end


private
  def set_perfil
    @perfil = Perfil.find(params[:id])
  end

  def perfil_params
    params.require(:perfil).permit(:nome)
  end

end

