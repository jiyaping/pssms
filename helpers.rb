# encoding: utf-8

def partial(view)
  erb :"_#{view}", :layout => false
end

def go_home
  redirect '/'
end

def env
  request['ENV']
end

def host
  "http://#{env['HTTP_HOST']}"
end

def path
  "#{host}#{env['REQUEST_PATH']}"
end

def today
  Date.today
end

def date(the_date)
  the_date.strftime '%Y年%m月%d'
end

def logger_user(path="",message="")
  Log.info "#{session[:login_id]}  #{path}  #{message}"
end

def split_to_array(str,sep='~',conj=',')
  str.split(sep).join(conj)
end

def str_to_hash(str,sep_first="&",sep_second="=")
  hash = {}
  str.split(sep_first).each do |item|
    k,v = item.split(sep_second)
    if !v.nil?
      hash[k] = v.strip 
    end
  end
  hash
end

