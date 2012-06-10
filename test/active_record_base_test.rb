#encoding : utf-8

require "../app"
require "active_record"
require "test/unit"

class TestActiveRecord < Test::Unit::TestCase
	def setup
		@type_one = TypeOne.create({
			:name=>"各种电器",
			:name_s=>"电器",
			:use_flag=>"0",
			:type_no=>"T00001"
		})
	end

	def teardown
		TypeOne.where("type_no＝'T00001'").first.destroy
	end

	#TypeOne name_s => typeone_name_s
	def test_build_field_key
		assert_equal("typeone_name_s",ActiveRecord::Base.build_field_key("TypeOne","name_s"))
		assert_equal("type_name_s",ActiveRecord::Base.build_field_key("Type","name_s"))
		assert_equal("type_one_name_s",ActiveRecord::Base.build_field_key("Type_One","name_s"))
	end

	#"name"=>"fds"  :name=>"dfd"
	def test_build_query_hash
		assert_equal({:name=>"jyp"},ActiveRecord::Base.build_query_hash({"name"=>"jyp"}))
		assert_equal({:name=>"jiyaping",:name_s=>"jyp"},
			ActiveRecord::Base.build_query_hash({"name"=>"jiyaping","name_s"=>"jyp"}))
	end
end