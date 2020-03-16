module ApplicationHelper

  def botao_adicionar(model, prefix:"/#{model.name.tableize}", callback: nil)
    link_to("<i class='fa fa-plus-circle no-margin-right'></i> #{I18n.t('helpers.links.add', model: I18n.t("activerecord.models.#{model.name.underscore}.one"))}".html_safe,
      "#",
      data: {url: "#{prefix}/new", callback: callback},
      :class => 'btn btn-default btn-new') if can?(:create, model)
  end

  def botao_salvar(builder)

    button_tag type: 'submit', class: "btn btn-primary" do
      "<i class='fa fa-floppy-o' aria-hidden='true'></i> ".html_safe +
      t((builder.object.new_record? ? "helpers.links.create" : "helpers.links.update"),
        model: t("activerecord.models.#{builder.object.class.name.underscore}.one"))
    end

  end

  def botao_cancelar(builder)
    button_tag(type: 'button', class: 'btn btn-default', data:{dismiss: "modal"}) do
      "<i class='fa fa-times-circle-o' aria-hidden='true'></i> ".html_safe +
      t('.cancel', :default => t("helpers.links.cancel"))
    end
  end

  #Booleano para string - exibição na tabela
  def bool_to_s(bool)
    bool ? I18n.t("true_bool") : I18n.t("false_bool")
  end

  def number_to_output(number)
    begin
      number_to_currency(
        number.to_f, unit: "", separator: ",", delimiter: ".", precision: (number.to_f.round == number.to_f) ? 0 : 2
      ).lstrip
    rescue
      0
    end
  end

  def datetime_to_output(datetime)
    datetime.strftime("%d/%m/%Y às %H:%M")
  end

  def seconds_to_output(s)
    mm, ss = s.to_i.divmod(60)
    hh, mm = mm.divmod(60)
    "#{'%02d' % hh}h:#{'%02d' % mm}m:#{'%02d' % ss}s"
  end

end
