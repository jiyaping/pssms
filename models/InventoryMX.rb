class InventoryMX < ActiveRecord::Base
	self.table_name = 'inventorys_mx'

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
			:good_price => item_hash["unit_price"],
			:quantity=>item_hash["quantity_inf"],
			:arrival_date=>Time.now.strftime("%F %T"),
			:produce_date=>item_hash["produce_date"],
			:expiry_date=>good_info.valildity_date,
			:supplier_id=>good_info.supplier_id,
			:supplier_name=>good_info.supplier_name,
			:reason_flag=>"00"
		})
	end
end