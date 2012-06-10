class InventoryMX < ActiveRecord::Base
	self.table_name = 'inventorys_mx'

	#库存履历查询
	def self.inventory_mx_view(page_num,page_size,good_name)
		limit = page_size || 10
		page_num = page_num || 1
		offset = (page_num.to_i-1) * page_size.to_i
		rows = []
		self.where("good_name LIKE '%#{good_name}%'").limit(limit).offset(offset).each do |obj|
			temp_hash = obj.attributes			
			temp_hash.merge!(Good.find(obj.good_id).attributes){|k,v1,v2| v1}
			temp_hash["type_one_name"] = TypeOne.find(obj.type_one_id).name
			temp_hash["type_two_name"] = TypeTwo.find(obj.type_two_id).name
			temp_hash["type_three_name"] = TypeThree.find(obj.type_three_id).name
			rows<<temp_hash
		end

		rows
	end

	#把数据做到inventory_mx
	def self.create_inv_mx(item_hash={})
		good_info = Good.find(item_hash["good_id"])
		#创建主明细
		InventoryMX.create({
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
			:reason_flag=>"00",
			:use_flag=>'0'
		})
	end
end