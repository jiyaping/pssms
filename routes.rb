# encoding: utf-8

get "/" do
	erb :index
end

=begin
	库存模块管理
=end
get "/inventory/good/:id" do 
	content_type 'applicaton/json',:charset=>'utf-8'
	Log.debug "#{params.inspect}"
	good = Good.find(params[:id])
	inv = Inventory.where("good_id=? AND main_flag=?",params[:id],"0").first
	inv = Inventory.new if inv.nil?
	good.attributes.merge!(inv.attributes){|k,v1,v2| v1}.to_json
end

post "/inventory/save" do
	logger_user(request.path,params.inspect)
	content_type 'applicaton/json',:charset=>'utf-8'

	Log.debug "#{params.inspect}"
	if Inventory.do_instock(params[:data])
		'保存成功'
	else
		'保存失败'
	end
end

post "/inventoryView" do
	logger_user(request.path,params.inspect)
	content_type 'applicaton/json',:charset=>'utf-8'

	return_hash={:total=>Inventory.where("main_flag='0'").size,:rows=>
		Inventory.inventory_view(params["page"],params["rows"],params["queryWord"])}
	return_hash.to_json
end

post "/inventoryMXView" do 
	logger_user(request.path,params.inspect)
	content_type 'applicaton/json',:charset=>'utf-8'

	return_hash={:total=>InventoryMX.where("main_flag='0'").size,:rows=>
		InventoryMX.inventory_mx_view(params["page"],params["rows"],params["queryWord"])}

	return_hash.to_json
end

=begin
	主功能模块管理
=end

################## 基础信息模块 ##################
post "/:type/save" do
	logger_user(request.path,params.inspect)
	Log.debug "#{params.inspect}"

	content_type 'applicaton/json',:charset=>'utf-8'
	if eval(params[:type]).save_or_update(params["data"],session[:login_id])
		{message: "保存成功",error_type: "0"}.to_json
	else
		{message: "内部数据错误，请联系管理员",error_type: "-1"}.to_json
	end
end

post "/:type/delete" do
	logger_user(request.path,params.inspect)
	Log.debug "#{params.inspect}"

	content_type 'text/plain',:charset=>'utf-8'
	"删除失败" if !(eval(params[:type]).find(params["id"]).destroy.nil?)
end

post "/:type/:fields" do
	logger_user(request.path,params.inspect)
	Log.debug "#{params.inspect}"
	
	content_type 'applicaton/json'
	total = session[:total] || eval(params["type"]).count
	queryHash = {} 			#查询参数
	add_fields = {}			#额外添加的field
	add_fields = str_to_hash(params["fields"]) unless params["fields"]=="nil" 
	queryHash = {params["queryType"]=>params["queryWord"]} if !params["queryType"].nil? and params["queryWord"]!=""
	Log.debug "#{params[:type]} #{params[:page]} #{params["rows"]} #{queryHash} #{add_fields}"
	return_hash={:total=>total,:rows=>
		eval(params[:type]).easyui_rows(params["page"],params["rows"],queryHash,add_fields)}
	return_hash.to_json
end


=begin
	公共信息模块
=end

######## 获取商品信息########
post "/get/good/" do
	Log.debug "#{params.inspect}" 
	name = params[:name]

	rows = []
	Good.where("name LIKE '%#{name}%'").select("id,name,stock_most,stock_least").each do |row|
		rows<<(row.attributes.merge!({"quantity"=>Inventory.where("GOOD_ID=? AND MAIN_FLAG=?",row.id,"0")}))
	end
	rows.sort! do |x,y|
		x[:quantity].to_f-x[:stock_least].to_f<=>y[:quantity].to_f-y[:stock_least].to_f
	end
	rows
end

######## 获取下拉列表框########
post "/get/:type/:fields/:query/:count" do 
	content_type 'applicaton/json',:charset=>'utf-8'
	fields = "id,name"		#需要查询出来的字段 不需要查询时用nil
	fields = params[:fields] unless params[:fields]=="nil"
	queryHash = {} 			#查询参数 eg：“name=jiyaping” 不需要查询时用nil
	queryHash = str_to_hash(params["query"]) unless params["query"]=="nil"
	count = 10
	count = params[:count] unless params[:count]=="nil" #返回记录数量 nil代表默认是10
	Log.debug "#{fields} #{queryHash} #{count}"
	hash = eval(params[:type]).easyui_special_rows(fields,queryHash,count)
	Log.debug "#{hash}"
	hash.to_json
end


########登录／退出########
get "/login" do 
	erb :login,:layout=>false
end

post "/login" do
	login_id = params["login_id"]
	password = params["password"]

	privilege = User.auth?(login_id,password)

	if(privilege)
		session[:login_id] = login_id
		session[:privilege] = privilege
		redirect "/"
	else
		@error_message = "帐号密码错误";
		redirect to("/login")
	end
end

get "/logout" do
	logger_user(request.path,params.inspect)

	session[:login_id] = nil
	session[:privilege] = nil
	redirect to("/login")
end


=begin
	before / after 公共处理
=end

#before
before do
	content_type :html, 'charset' => 'utf-8' 
	redirect to("/login") if session[:login_id]==nil && request.path!="/login"
end
