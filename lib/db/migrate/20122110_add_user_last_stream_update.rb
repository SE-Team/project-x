## data-mapper dependency requires
require 'data_mapper'
require 'dm-migrations/migration_runner'

## load project db models
require './lib/model/user'


# DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/lib/db/base.db")
DataMapper::Model.raise_on_save_failure = true
DataMapper::Logger.new(STDOUT, :debug)
DataMapper.logger.debug( "Starting Migration" )

migration 1, :add_user_last_stream_update do
  up do
    modify_table :users do
    	add_column :last_stream_request, 'DateTime'
    end
  end

  down do
    modify_table :users do
    	drop_column :last_stream_request
    end
  end
end

migrate_up!