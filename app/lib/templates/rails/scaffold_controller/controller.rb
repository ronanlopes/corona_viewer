<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController

  before_action :set_<%= singular_table_name %>, only: [:edit, :update, :destroy]

  load_and_authorize_resource

  def flash_notice
    "#{I18n.t("activerecord.models.<%= singular_table_name %>.one")} #{I18n.t("activerecord.messages.#{action_name}_success")}"
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: <%= "#{plural_table_name.camelize}" %>Datatable.new(view_context) }
    end
  end

  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
  end

  def edit
  end

  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    respond_to do |format|
      if @<%= orm_instance.save %>
        redirect_action_success(format)
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @<%= orm_instance.update("#{singular_table_name}_params") %>
        redirect_action_success(format)
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @<%= orm_instance.destroy %>
    respond_to do |format|
      redirect_action_success(format)
    end
  end


private

  def redirect_action_success(format)
    format.html {
      redirect_to <%= plural_table_name %>_path, notice: flash_notice
    }
  end

  def <%= "set_#{singular_table_name}" %>
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
  end

  def <%= "#{singular_table_name}_params" %>
    <%- if defined?(attributes_names) -%>
    params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
    <%- else -%>
    params[:<%= singular_table_name %>]
    <%- end -%>
  end

end
<% end -%>

