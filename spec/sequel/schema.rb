require "sequel/extensions/migration"

module Mobility
  module Test
    class Schema
      class << self
        def migrate(*)
          DB.create_table? :posts do
            primary_key :id
            TrueClass   :published
          end

          DB.create_table? :post_metadatas do
            primary_key :id
            String      :metadata
            Integer     :post_id
          end

          DB.create_table? :fallback_posts do
            primary_key :id
            TrueClass   :published
          end

          DB.create_table? :articles do
            primary_key :id
            String      :slug
          end

          DB.create_table? :mobility_text_translations do
            primary_key :id
            String      :locale,            null: false
            String      :key,               null: false
            Text        :value,             null: false
            Integer     :translatable_id,   null: false
            String      :translatable_type, null: false
            index [:translatable_id, :translatable_type, :locale, :key], unique: true, name: :index_mobility_text_translations_on_keys
            index [:translatable_id, :translatable_type], name: :index_mobility_text_translations_on_translatable
          end

          DB.create_table? :mobility_string_translations do
            primary_key :id
            String      :locale,            null: false
            String      :key,               null: false
            String      :value,             null: false
            Integer     :translatable_id,   null: false
            String      :translatable_type, null: false
            index [:translatable_id, :translatable_type, :locale, :key], unique: true, name: :index_mobility_string_translations_on_keys
            index [:translatable_id, :translatable_type], name: :index_mobility_string_translations_on_translatable
          end

          DB.create_table?  :comments do
            primary_key :id
            String      :content_en,    size: 65535
            String      :content_ja,    size: 65535
            String      :content_pt_br, size: 65535
            String      :content_ru,    size: 65535
            TrueClass   :published
          end
        end

        def up
          migrate(:up)
        end
      end
    end
  end
end