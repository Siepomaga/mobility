module Mobility
  module Backend
    class ActiveRecord::Table
      autoload :QueryMethods, 'mobility/backend/active_record/table/query_methods'

      include Base
      attr_reader :association_name

      def initialize(model, attribute, **options)
        super
        @association_name = options[:association_name]
      end

      def read(locale, **options)
        translation_for(locale)
      end

      def write(locale, value, **options)
        translation_for(locale).tap { |t| t.value = value }
      end

      def self.configure!(options)
        if type = options[:type]
          case type.to_sym
          when :text, :string
            options[:class_name] = Mobility::ActiveRecord.const_get("#{type.capitalize}Translation")
          else
            raise ArgumentError, "type must be one of: [text, string]"
          end
        end
        options[:class_name]       ||= Mobility::ActiveRecord::TextTranslation
        options[:class_name] = options[:class_name].constantize if options[:class_name].is_a?(String)
        options[:association_name] ||= options[:class_name].table_name.to_sym
      end

      setup do |attributes, options|
        association_name   = options[:association_name]
        translations_class = options[:class_name]
        has_many association_name, as: :translatable,
          class_name: translations_class,
          dependent:  :destroy,
          inverse_of: :translatable,
          autosave:   true
        before_save do
          send(association_name).select { |t| t.value.blank? }.each(&:destroy)
        end

        mod = Module.new do
          define_method :i18n do
            @mobility_scope ||= super().extending(QueryMethods.new(attributes, options))
          end
        end
        extend mod

        private association_name, "#{association_name}="
      end

      private

      def translations
        model.send(association_name)
      end

      def translation_for(locale)
        translation = translations.find { |t| t.key == attribute && t.locale == locale.to_s }
        translation ||= translations.build(locale: locale, key: attribute)
        translation
      end
    end
  end
end