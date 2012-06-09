class Inventory < ActiveRecord::Base
	self.table_name = 'inventorys'

	#商品入库
	def self.do_instock(items_hash={})
		ActiveRecord::Base.transaction do
			items_hash.each do |k,v|
				create_inv(v)	#创建库存总表信息
				InventoryMX.create_inv_mx(v) #创建库存明细表信息

				return true
			end
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
			:good_price => item_hash["unit_price"],
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