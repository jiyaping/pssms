# encoding: utf-8

require 'active_record'
require "json"
require "logger"

require_relative 'lib/ActiveRecord.rb'

# Plugins.
Dir['plugins/*.rb'].each { |plugin| require_relative plugin }  

# Database connection.
ActiveRecord::Base.establish_connection(
	:adapter=>"sqlite3",
	:database=>"main.sqlite3"
)

# Database models.
Dir['models/*.rb'].each { |model| require_relative model }

#加载数据库迁移文件
require_relative 'migration'

# Sinatra configurations.
configure do
  enable :sessions
  set :logging, :true
  Log = Logger.new("sinatra.log")
  Log.level  = Logger::DEBUG
end

# Application helpers.
helpers do
  require_relative 'helpers'
end
