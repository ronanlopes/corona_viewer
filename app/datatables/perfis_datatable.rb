class PerfisDatatable < TemplateDatatable


private

  def data
    objects.map do |perfil|
      [
        perfil.id,
        perfil.nome,
        links(perfil)
      ]
    end
  end

  def fetch_objects
    perfis = Perfil.order("#{sort_column} #{sort_direction}")

    if params[:search][:value].present?
      conditions = []

      conditions << "(CAST(perfis.id AS TEXT) LIKE ?)"
      conditions << "(UPPER(perfis.nome) LIKE (?))"


      values = []
      values <<  params[:search][:value]

      1.times do
        values << "%" + params[:search][:value] + "%"
      end

      conditions = ["(#{conditions.join(" or ")})"] + values
    end

    perfis.where(conditions).paginate(page: page, per_page: per_page).to_a
  end

end

