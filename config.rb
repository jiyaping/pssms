# encoding: utf-8

require 'active_record'
require "json"
require "logger"

require_relative 'lib/ActiveRecord.rb'

# Plugins.
Dir['plugins/*.rb'].each { |plugin| require_relative plugin }  

# Database connection.

#Connection to sqlite3
ActiveRecord::Base.establish_connection(
	:adapter=>"sqlite3",
	:database=>"main.sqlite3"
)

#Connection to mysql
# ActiveRecord::Base.establish_connection(
# 	:adapter => "mysql",
# 	:host => "localhost",
# 	:username => "root",
# 	:password => "root",
# 	:database => "sinatra"
# )


#Connection to postgresql
# db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
# ActiveRecord::Base.establish_connection(
#   :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
#   :host     => db.host,
#   :username => db.user,
#   :password => db.password,
#   :database => db.path[1..-1],
#   :encoding => 'utf8'
# )

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
