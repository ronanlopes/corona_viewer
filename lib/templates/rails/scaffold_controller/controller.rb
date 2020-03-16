<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController

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
    render "new", :layout => !request.xhr?
  end

  def edit
    render "edit", :layout => !request.xhr?
  end

  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html {
          flash[:notice] = flash_notice
          redirect_to action: "index"
        }
        format.json { render :show, status: :created, location: @<%= singular_table_name %> }
      else
        format.html { render :new }
        format.json { render json: @<%= singular_table_name %>.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @<%= orm_instance.update("#{singular_table_name}_params") %>
        format.html {
          flash[:notice] = flash_notice
          redirect_to action: "index"
        }
        format.json { render :show, status: :created, location: @<%= singular_table_name %> }
      else
        format.html { render :edit }
        format.json { render json: @<%= singular_table_name %>.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @<%= orm_instance.destroy %>
    respond_to do |format|
      format.html {
        flash[:notice] = flash_notice
        redirect_to action: "index"
      }
      format.json { head :no_content }
    end
  end


private
  def <%= "set_#{singular_table_name}" %>
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
  end

  def <%= "#{singular_table_name}_params" %>
    <%- delocalized_attrs = attributes.select{|a| a.type.to_s == "decimal"}.map(&:name) -%>
    <%- if delocalized_attrs.size > 0 -%>
    <%= "delocalize_config = { #{ delocalized_attrs.map{|a| ":#{a} => :number"}.join(",") } }" %>
    <%- end -%>
    <%- if defined?(attributes_names) -%>
    params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)<%= ".delocalize(delocalize_config)" if delocalized_attrs.present?%>
    <%- else -%>
    params[:<%= singular_table_name %>]
    <%- end -%>
  end

end
<% end -%>

