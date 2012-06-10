#encoding : utf-8

class Inventory < ActiveRecord::Base
	self.table_name = 'inventorys'

	#库存盘点
	def self.inventory_view(page_num,page_size,good_name)
		limit = page_size || 10
		page_num = page_num || 1
		offset = (page_num.to_i-1) * page_size.to_i
		rows = []
		self.where("main_flag='0' AND good_name LIKE '%#{good_name}%'").limit(limit).offset(offset).each do |obj|
			temp_hash = obj.attributes			
			temp_hash.merge!(Good.find(obj.good_id).attributes){|k,v1,v2| v1}
			temp_hash["type_one_name"] = TypeOne.find(obj.type_one_id).name
			temp_hash["type_two_name"] = TypeTwo.find(obj.type_two_id).name
			temp_hash["type_three_name"] = TypeThree.find(obj.type_three_id).name
			rows<<temp_hash
		end

		rows
	end

	#商品入库
	def self.do_instock(items_hash={})
		ActiveRecord::Base.transaction do
			items_hash.values.each do |v|
				create_inv(v)	#创建库存总表信息
				InventoryMX.create_inv_mx(v) #创建库存明细表信息

			end

			return true
		end
	end

	#把数据做到inventory
	def self.create_inv(item_hash={})
		#本商品信息是否存在
		inv = Inventory.where("good_id=? AND main_flag=?",item_hash["good_id"],"0").first
		if(inv.nil?)
			create_spec_inv(item_hash,"0")
			create_spec_inv(item_hash,"1")
		else
			temp_quan = inv.quantity.to_f + item_hash["quantity_inf"].to_f
			inv.update_attributes({:quantity=>temp_quan})
			create_spec_inv(item_hash,"1")
		end
	end

	def self.create_spec_inv(item_hash={},main_flag)
		good_info = Good.find(item_hash["good_id"])
		#创建主明细
		Inventory.create({
			:good_id => item_hash["good_id"],
			:type_one_id => good_info.type_one_id, 
			:type_two_id => good_info.type_two_id, 
			:type_three_id => good_info.type_three_id,
			:good_name => good_info.name,
			:good_unit=>good_info.unit,
			:enforce_code=>Time.now.to_i,
			:unit_price => item_hash["unit_price"],
			:quantity=>item_hash["quantity_inf"],
			:arrival_date=>Time.now.strftime("%F %T"),
			:produce_date=>item_hash["produce_date"],
			:expiry_date=>good_info.valildity_date,
			:supplier_id=>good_info.supplier_id,
			:supplier_name=>good_info.supplier_name,
			:main_flag=>main_flag,
			:use_flag=>"0"
		})
	end
end