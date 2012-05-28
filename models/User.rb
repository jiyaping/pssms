# encoding: utf-8

class User < ActiveRecord::Base
	self.table_name = "users"

	def self.auth?(login_id,password)
		user = User.where("login_id=? AND password=?", login_id, password).first
		if(user)
			user.update_last_login
			user.privilege
		else
			nil
		end
	end

	def update_last_login
		self.last_login = Time.now.strftime("%F %T")
		self.save
	end
end
