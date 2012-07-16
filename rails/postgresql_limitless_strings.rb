module PsqlApp
  class Application < Rails::Application
    # ...

    # Switch to limitless strings
    initializer "postgresql.no_default_string_limit" do
      ActiveSupport.on_load(:active_record) do
        adapter = ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
        adapter::NATIVE_DATABASE_TYPES[:string].delete(:limit)
      end
    end
  end
end
