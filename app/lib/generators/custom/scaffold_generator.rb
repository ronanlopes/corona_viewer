# lib/generators/custom/scaffold_generator.rb
require 'rails/generators/named_base'
require 'rails/generators/resource_helpers'
require 'rails/generators/named_base'

module Custom # :nodoc:
  module Generators # :nodoc:
    class Base < Rails::Generators::NamedBase #:nodoc:
      protected

      def format
        [:html, :slim]
      end

      def handler
        :erb
      end


      def filename_with_extensions(name, handl=nil)
        cformat = name[/\.js/] ? nil : format
        [name, cformat, handl].compact.join(".")
      end

    end

    class ScaffoldGenerator < Base # :nodoc:
      include Rails::Generators::ResourceHelpers

      source_root File.join(Rails.root, 'lib', 'templates', 'erb', 'scaffold', File::SEPARATOR)

      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      def create_root_folder
        empty_directory File.join("app/views", controller_file_path)
      end

      def copy_view_files
        available_views.each do |view|
          template filename_with_extensions(view, :erb), File.join("app/views", controller_file_path, filename_with_extensions(view))
        end
        template "datatable.html.slim.erb", File.join("app/datatables", "#{controller_file_path}_datatable.rb")
        template "datatable_js.html.slim.erb", File.join("app/assets/javascripts", "#{controller_file_path}.coffee")
      end

      def add_locale_entries
        locale = Rails.root.join('config', 'locales', 'pt-BR.yml').to_s
        cfg = YAML.load_file(locale)

        cfg["pt-BR"]["activerecord"]["models"][singular_table_name] = {}
        cfg["pt-BR"]["activerecord"]["attributes"][singular_table_name] = {}

        cfg["pt-BR"]["activerecord"]["models"][singular_table_name]["one"] = singular_table_name.humanize
        cfg["pt-BR"]["activerecord"]["models"][singular_table_name]["other"] = singular_table_name.humanize.split.map(&:pluralize).join(" ")


        attributes.each do |attr|
          cfg["pt-BR"]["activerecord"]["attributes"][singular_table_name][attr.name] = attr.name.humanize
        end

        cfg["pt-BR"]["activerecord"]["attributes"][singular_table_name]["index"] = "Lista de #{cfg["pt-BR"]["activerecord"]["models"][singular_table_name]["other"]}"


        File.open(locale, "w"){ |f| YAML.dump(cfg, f) }
      end

    protected
      def available_views
        %w(index _form)
      end
    end
  end
end