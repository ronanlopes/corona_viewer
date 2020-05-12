class HorarioDisponivelConsultorasController < ApplicationController

  load_and_authorize_resource

  def flash_notice
    "#{I18n.t("activerecord.models.horario_disponivel_consultora.one")} #{I18n.t("activerecord.messages.#{action_name}_success")}"
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: HorarioDisponivelConsultorasDatatable.new(view_context) }
    end
  end

  def new
    @horario_disponivel_consultora = HorarioDisponivelConsultora.new
    render "new", :layout => !request.xhr?
  end

  def edit
    render "edit", :layout => !request.xhr?
  end

  def create
    @horario_disponivel_consultora = HorarioDisponivelConsultora.new(horario_disponivel_consultora_params)

    respond_to do |format|
      if @horario_disponivel_consultora.save
        format.html {
          flash[:notice] = flash_notice
          redirect_to action: "index"
        }
        format.json { render :show, status: :created, location: @horario_disponivel_consultora }
      else
        format.html { render :new }
        format.json { render json: @horario_disponivel_consultora.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @horario_disponivel_consultora.update(horario_disponivel_consultora_params)
        format.html {
          flash[:notice] = flash_notice
          redirect_to action: "index"
        }
        format.json { render :show, status: :created, location: @horario_disponivel_consultora }
      else
        format.html { render :edit }
        format.json { render json: @horario_disponivel_consultora.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @horario_disponivel_consultora.destroy
    respond_to do |format|
      format.html {
        flash[:notice] = flash_notice
        redirect_to action: "index"
      }
      format.json { head :no_content }
    end
  end


private
  def set_horario_disponivel_consultora
    @horario_disponivel_consultora = HorarioDisponivelConsultora.find(params[:id])
  end

  def horario_disponivel_consultora_params
    params.require(:horario_disponivel_consultora).permit(:dia, :hora_inicio, :hora_fim, :user_id)
  end

end

