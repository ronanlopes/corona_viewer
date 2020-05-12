class HorarioDisponivelConsultorasDatatable < TemplateDatatable


private

  def data
    objects.map do |horario_disponivel_consultora|
      [
        horario_disponivel_consultora.id,
        horario_disponivel_consultora.dia,
        horario_disponivel_consultora.hora_inicio,
        horario_disponivel_consultora.hora_fim,
        horario_disponivel_consultora.user,

        links(horario_disponivel_consultora)
      ]
    end
  end

  def fetch_objects
    horario_disponivel_consultoras = HorarioDisponivelConsultora.order("#{sort_column} #{sort_direction}")

    if params[:search][:value].present?
      conditions = []

      conditions << "(CAST(horario_disponivel_consultoras.id AS TEXT) LIKE ?)"
      conditions << "(UPPER(CAST horario_disponivel_consultoras.dia AS TEXT) LIKE (?))"
      conditions << "(UPPER(CAST horario_disponivel_consultoras.hora_inicio AS TEXT) LIKE (?))"
      conditions << "(UPPER(CAST horario_disponivel_consultoras.hora_fim AS TEXT) LIKE (?))"
      conditions << "(UPPER(CAST horario_disponivel_consultoras.user AS TEXT) LIKE (?))"


      values = []
      values <<  params[:search][:value]

      4.times do
        values << "%" + params[:search][:value] + "%"
      end

      conditions = ["(#{conditions.join(" or ")})"] + values
    end

    horario_disponivel_consultoras.where(conditions).paginate(page: page, per_page: per_page).to_a
  end

end

