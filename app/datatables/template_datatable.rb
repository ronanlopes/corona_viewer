class TemplateDatatable
  include ActionView::Helpers
  include ActionView::Context
  include CanCan::Ability
  include Rails.application.routes.url_helpers

  delegate :params, to: :@view
  delegate :url_helpers, to: 'Rails.application.routes'

  #View_context para acessar dados da sessão
  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: objects.size,
      iTotalDisplayRecords: objects.total_entries,
      aaData: data
    }
  end

  #Booleano para string - exibição na tabela
  def bool_to_s(bool)
    bool ? I18n.t("true_bool") : I18n.t("false_bool")
  end

  def datetime_to_s(datetime)
    datetime.strftime("%d/%m/%Y às %H:%M")
  end


private

  #Coluna de ações
  def links(object)
    botao_editar(object).to_s+" "+botao_excluir(object).to_s
  end

  def objects
    @objects ||= fetch_objects
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i
  end

  #Por padrão, a ordenação aceita as colunas do model (pode ser sobrescrito na classe implementada)
  def sort_columns_collection
    @view.controller.controller_path.classify.constantize.column_names - ["created_at", "updated_at"]
  end

  def sort_column
    order_column = params.to_unsafe_h["order"]["0"]["column"].to_i
    sort_columns_collection[order_column]
  end

  def sort_direction
    params.to_unsafe_h["order"]["0"]["dir"] == "desc" ? "desc" : "asc"
  end

  def prefix_path(object)
    object.class.name.tableize
  end


  def botao_editar(object)
    link_to("<i class=\"fa fa-edit no-margin-right\"></i> #{I18n.t('helpers.links.edit')}".html_safe,
      "#", data: {url: "/#{prefix_path(object)}/#{object.id}/edit"},
      :class => 'btn btn-ar btn-xs btn-info btn-edit') if @view.can?(:update, object)
  end

  def botao_excluir(object)
    link_to("<i class=\"fa fa-trash-o no-margin-right\"></i> #{I18n.t('helpers.links.destroy')}".html_safe,
      "/#{prefix_path(object)}/#{object.id}",
      :method => :delete, :data => {
        :confirm => I18n.t('.confirm', :default => I18n.t("helpers.links.confirm", :default => 'Tem certeza que deseja apagar este registro?')),
        "confirm-title" => "Excluir Registro",
        "confirm-proceed" => "<i class=\"fa fa-trash-o\"></i> Excluir",
        "confirm-proceed-class" => "btn-danger",
        "confirm-cancel" => "<i class=\"fa fa-times-circle-o\"></i> Cancelar"
      },
      :class => 'btn btn-ar btn-xs btn-danger') if @view.can?(:destroy, object)
  end



end