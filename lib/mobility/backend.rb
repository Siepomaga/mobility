module Mobility
  module Backend
    autoload :ActiveModel,  'mobility/backend/active_model'
    autoload :ActiveRecord, 'mobility/backend/active_record'
    autoload :Base,         'mobility/backend/base'
    autoload :Cache,        'mobility/backend/cache'
    autoload :Columns,      'mobility/backend/columns'
    autoload :Dirty,        'mobility/backend/dirty'
    autoload :Fallbacks,    'mobility/backend/fallbacks'
    autoload :Null,         'mobility/backend/null'
    autoload :OrmDelegator, 'mobility/backend/orm_delegator'
    autoload :Sequel,       'mobility/backend/sequel'
    autoload :Table,        'mobility/backend/table'

    def self.method_name(attribute)
      "#{attribute}_translations"
    end
  end
end