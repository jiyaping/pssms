# encoding: utf-8

get "/" do
	erb :index
end

=begin
	信息模块
=end

################## 用户管理 ##################
post "/user" do
	logger_user(request.path,params.inspect)

	content_type 'applicaton/json'
	total = session[:total] || User.count
	queryHash = {}
	queryHash = {params["queryType"]=>params["queryWord"]} unless params["queryType"].nil?
	return_hash={:total=>total,:rows=>User.easyui_rows(params["page"],params["rows"],queryHash)}
	Log.debug "#{params.inspect}"
	return_hash.to_json
end

post "/user/delete" do
	logger_user(request.path,params.inspect)

	content_type 'text/plain',:charset=>'utf-8'
	Log.debug "#{params.inspect}"
	"delete failed !" if !User.find(params["id"]).destroy
end

post "/user/save" do
	logger_user(request.path,params.inspect)

	content_type 'applicaton/json',:charset=>'utf-8'
	Log.debug "#{params.inspect}"
	if User.save_or_update(params,session[:login_id])
		{message: "保存成功",error_type: "0"}.to_json
	else
		{message: "内部数据错误，请联系管理员",error_type: "-1"}.to_json
	end
end

################## 大类管理 ##################
post "/typeone" do
	logger_user(request.path,params.inspect)

	content_type 'applicaton/json'
	total = session[:total] || User.count
	queryHash = {}
	queryHash = {params["queryType"]=>params["queryWord"]} unless params["queryType"].nil?
	return_hash={:total=>total,:rows=>TypeOne.easyui_rows(params["page"],params["rows"],queryHash)}
	Log.debug "#{params.inspect}"
	return_hash.to_json
end

post "/typeone/delete" do
	logger_user(request.path,params.inspect)

	content_type 'text/plain',:charset=>'utf-8'
	Log.debug "#{params.inspect}"
	"delete failed !" if !TypeOne.find(params["id"]).destroy
end

post "/typeone/save" do
	logger_user(request.path,params.inspect)

	content_type 'applicaton/json',:charset=>'utf-8'
	Log.debug "#{params.inspect}"
	if TypeOne.save_or_update(params,session[:login_id])
		{message: "保存成功",error_type: "0"}.to_json
	else
		{message: "内部数据错误，请联系管理员",error_type: "-1"}.to_json
	end
end

################## 中类管理 ##################
post "/typetwo" do
	logger_user(request.path,params.inspect)

	content_type 'applicaton/json'
	total = session[:total] || User.count
	queryHash = {}
	queryHash = {params["queryType"]=>params["queryWord"]} unless params["queryType"].nil?
	return_hash={:total=>total,:rows=>TypeTwo.easyui_rows(params["page"],params["rows"],queryHash)}
	Log.debug "#{params.inspect}"
	return_hash.to_json
end

post "/typetwo/delete" do
	logger_user(request.path,params.inspect)

	content_type 'text/plain',:charset=>'utf-8'
	Log.debug "#{params.inspect}"
	"delete failed !" if !TypeTwo.find(params["id"]).destroy
end

post "/typetwo/save" do
	logger_user(request.path,params.inspect)

	content_type 'applicaton/json',:charset=>'utf-8'
	Log.debug "#{params.inspect}"
	if TypeTwo.save_or_update(params,session[:login_id])
		{message: "保存成功",error_type: "0"}.to_json
	else
		{message: "内部数据错误，请联系管理员",error_type: "-1"}.to_json
	end
end

################## 小类管理 ##################
################## 供应商管理 #################
################## 商品管理 ##################



=begin
	公共信息模块
=end



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
