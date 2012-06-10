# encoding: utf-8

class ActiveRecord::Base
	#获取指定列信息返回
	def self.easyui_special_rows(fields="id,name",params={},count=10)
		keystr = build_query_str(params,"LIKE")
		rows = []
		self.where(keystr).limit(count).select(fields).each do |obj|
			rows<<obj.attributes
		end

		rows
	end

	#整体属性转化为hash
 	def to_full_hash
 		hash = {}
		instance_variables.each do |var|
			hash[var.to_s.delete! '@']=instance_variable_get var
		end
		hash
 	end

 	#返回指定rows的数组
 	# => page_num	当前页号 
 	# => page_size	每页大小 
 	# => params		查询条件
 	# => add_field	额外需要添加的field	 eg:{"TypeOne"=>"name_s"}
	def self.easyui_rows(page_num,page_size,params={},add_fields={})
		keystr = build_query_str(params)
		keyHash = build_query_hash(params)
		limit = page_size || 10
		page_num = page_num || 1
		offset = (page_num.to_i-1) * page_size.to_i
		rows = []
		#puts "l:#{limit} o:#{offset} ks:#{keystr} kh:#{keyHash}"
		self.where(keystr,keyHash).includes(add_fields.keys).limit(limit).offset(offset).each do |obj|
			rows<<(obj.attributes.merge!(build_addition_fields(obj,add_fields)))
		end

		rows
	end

	#保存还是更新
	def self.save_or_update(params={},login_id='',key="id")
		params["id"] = params["id"] || ""
		if params["id"]!=""
			return find(params["id"].to_s).update_attributes(params.merge!(add_other_info(login_id)))
		else
			Log.debug "#{params.merge!(add_other_info(login_id,"add"))}"
			return create(params.merge!(add_other_info(login_id,"add")))
		end
		false
	end

	private

	#构造条件字符串
	def self.build_query_str(params={},query_type="=")
		result_str = ''
		if query_type=="="
			params.keys.each do |p|
				result_str<<p.to_s<<" =:#{p.to_sym}"
				result_str<<" and " if params.keys.last!=p
			end
		else
			params.keys.each do |p|
				result_str<<p.to_s<<" #{query_type} '%#{params[p]}%'"
				result_str<<" and " if params.keys.last!=p
			end
		end
		result_str

	end

	#构造值value哈希
	def self.build_query_hash(params={})
		newhash = params.inject({}) { |h,(k,v)| h[k.to_sym] = v; h }
		newhash
	end

	#根据传入对象和addfields构造返回的hash
	def self.build_addition_fields(obj,addfields={})
		hash={}
		addfields.each do |k,v|
			hash[build_field_key(k,v)] = obj.send(k).send(v) unless obj.nil?
		end
		hash
	end

	#利用hash构造参数格式
	#eg "TypeOne" "name_s" 返回 “typeone_name_s”
	def self.build_field_key(key,value)
		key.downcase<<"_"<<value
	end

	#添加而外信息
	def self.add_other_info(login_id="",add_or_upd="upd")
		info_hash = {}
		if(add_or_upd=="upd")
			info_hash["upd_id"] = login_id
			info_hash["upd_date"] = Time.now.strftime("%F %T")
		else
			info_hash["add_id"] = login_id
			info_hash["add_date"] = Time.now.strftime("%F %T")
		end
		info_hash
	end
end
