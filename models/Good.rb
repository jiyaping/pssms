# encoding: utf-8

class Good < ActiveRecord::Base
	self.table_name = "goods"

	belongs_to :TypeOne,:foreign_key=>"type_one_id"
	belongs_to :TypeTwo,:foreign_key=>"type_two_id"
	belongs_to :TypeThree,:foreign_key=>"type_three_id"
	belongs_to :Supplier,:foreign_key=>"supplier_id"
	belongs_to :Shevle,:foreign_key=>"shevle_id"	
end