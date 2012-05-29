# encoding: utf-8

class TypeThree < ActiveRecord::Base
	self.table_name = "type_threes"

	belongs_to :TypeOne,:foreign_key=>"type_one_id"
	belongs_to :TypeTwo,:foreign_key=>"type_two_id"
end