# encoding: utf-8

class TypeTwo < ActiveRecord::Base
	self.table_name = "type_twos"

	belongs_to :TypeOne,:foreign_key=>"type_one_id"
end