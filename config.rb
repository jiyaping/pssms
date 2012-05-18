require 'active_record'

#require_relative 'lib/*.rb'

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
end

# Application helpers.
helpers do
  require_relative 'helpers'
end