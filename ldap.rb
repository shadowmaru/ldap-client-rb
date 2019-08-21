require 'net/ldap'

class Ldap
  TLS_OPTS = OpenSSL::SSL::SSLContext::DEFAULT_PARAMS.merge({}).freeze

  LDAP_INFO = {
    search_username: ENV['AD_SEARCH_USERNAME'],
    search_password: ENV['AD_SEARCH_PASSWORD'],
    host: ENV['AD_HOST']
  }

  LDAP_BASE = ENV['AD_BASE']

  LDAP_ADMIN_USER = {
    user: "#{ENV['AD_NAMESPACE']}\\#{LDAP_INFO[:search_username]}",
    password: LDAP_INFO[:search_password]
  }

  def initialize
    @ldap            = Net::LDAP.new
    @ldap.host       = LDAP_INFO[:host]
    @ldap.port       = 636
    @ldap.encryption({
      method: :simple_tls,
      tls_options: TLS_OPTS.merge(verify_mode: OpenSSL::SSL::VERIFY_NONE)
    })
  end

  def search_by_login(username)
    @ldap.auth(LDAP_ADMIN_USER[:user], LDAP_ADMIN_USER[:password])
    @ldap.search(
      base: LDAP_BASE,
      filter: Net::LDAP::Filter.eq("samaccountname", username),
      # attributes: %w[samaccountname cn mail title department company dn c objectsid st l postalcode postofficebox mobile],
      return_result: true
    ).first
  end

  def search_all_by_name(cn)
    @ldap.auth(LDAP_ADMIN_USER[:user], LDAP_ADMIN_USER[:password])
    @ldap.search(
      base: LDAP_BASE,
      filter: Net::LDAP::Filter.eq("cn", "*#{cn}*"),
      # attributes: %w[samaccountname cn mail title department company dn c objectsid st l postalcode postofficebox mobile],
      return_result: true
    )
  end
end