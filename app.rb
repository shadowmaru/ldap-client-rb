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
  return false if flag_list(code).include?('ADS_UF_ACCOUNTDISABLE')

  true
end

def flag_list(number)
  hex_number = decimal_to_hex(number)

  array = flags.keys.reverse
  i = 0
  count = hex_number
  flag_list = []
  while count.positive? do
    if (count - array[i]) >= 0
      count -= array[i]
      flag_list << flags[array[i]]
    end
    i += 1
  end

  flag_list
end

def decimal_to_hex(number)
  number.to_i.to_s(16).to_i
end

def flags
  {
    1 => 'ADS_UF_SCRIPT',
    2 => 'ADS_UF_ACCOUNTDISABLE',
    8 => 'ADS_UF_HOMEDIR_REQUIRED',
    20 => 'ADS_UF_PASSWD_NOTREQD',
    200 => 'ADS_UF_NORMAL_ACCOUNT',
    10_000 => 'ADS_UF_DONT_EXPIRE_PASSWD'
  }
end
