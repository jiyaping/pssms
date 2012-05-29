# encoding: utf-8

#创建Admin表
class AddAdmin < ActiveRecord::Migration
	def self.up
		create_table :admins do |t|
			t.string :adminname
			t.string :adminpwd
		end
	end

	def self.down
		drop_table :admins
	end
end

if not Admin.table_exists?
	AddAdmin.up
end

#创建User表
class AddUser < ActiveRecord::Migration
	def self.up
		create_table :users do |t|
			t.string :login_id
			t.string :password
			t.string :real_name
			t.string :ceilphone
			t.string :qq
			t.string :address
			t.string :gender
			t.string :email
			t.string :privilege
			t.string :use_flag
			t.string :last_login
			t.string :add_id
			t.string :add_date
			t.string :upd_id
			t.string :upd_date
		end
	end

	def self.down
		drop_table :users
	end
end

if not User.table_exists?
	AddUser.up
end

#create TypeOne
class AddTypeOne < ActiveRecord::Migration 
	def self.up
		create_table :type_ones do |t|
			t.string :name
			t.string :use_flag
			t.string :type_no
			t.string :name_s
			t.string :add_id
			t.string :add_date
			t.string :upd_id
			t.string :upd_date
		end
	end

	def self.down
		drop_table :type_ones
	end
end

if not TypeOne.table_exists?
	AddTypeOne.up
end

#create TypeTwo
class AddTypeTwo < ActiveRecord::Migration 
	def self.up
		create_table :type_twos do |t|
			t.string :name
			t.string :type_no
			t.string :name_s
			t.string :type_one_id
			t.string :use_flag
			t.string :add_id
			t.string :add_date
			t.string :upd_id
			t.string :upd_date
		end
	end

	def self.down
		drop_table :type_twos
	end
end

if not TypeTwo.table_exists?
	AddTypeTwo.up
end

#create TypeThree
class AddTypeThree < ActiveRecord::Migration 
	def self.up
		create_table :type_threes do |t|
			t.string :name
			t.string :type_no
			t.string :name_s
			t.integer :type_one_id
			t.string :type_one_no
			t.string :type_one_name
			t.integer :type_two_id
			t.string :type_two_name
			t.string :type_two_no
			t.string :use_flag
			t.string :add_id
			t.string :add_date
			t.string :upd_id
			t.string :upd_date
		end
	end

	def self.down
		drop_table :type_threes
	end
end

if not TypeThree.table_exists?
	AddTypeThree.up
end