require 'sinatra'
require_relative 'ldap'

get '/' do
  erb :index
end

get '/search' do
  @ldap = Ldap.new
  if params[:login] != ''
    @user = @ldap.search_by_login(params[:login])
  elsif params[:name] != ''
    @users = @ldap.search_all_by_name(params[:name])
  end
  puts @user.inspect
  puts @users.inspect
  erb :search
end

def enabled?(code)
  case code
  when '512', '544', '66048'
    true
  when '514', '66050'
    false
  else
    false
  end
end

def decimal_to_hex(number)
  digits = []
  while number > 0 do
    digit = number % 16
    digits << digit
    number /= 16
  end

  digits.reverse.join.to_i
end
