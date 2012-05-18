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