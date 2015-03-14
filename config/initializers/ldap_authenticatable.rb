require 'net/ldap'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class LdapAuthenticatable < Authenticatable
      @@ldap_yml ||= YAML.load_file("#{Rails.root}/config/ldap.yml")[Rails.env]

      def authenticate!
        if params[:player]
          ldap = Net::LDAP.new({
            host: @@ldap_yml['host'],
            port: @@ldap_yml['port'],
            encryption: @@ldap_yml['ssl'].to_sym,
            auth: {
              method: :simple,
              username: "uid=#{username},#{@@ldap_yml['base']}",
              password: password
            }
          })
          return fail! unless ldap.bind

          ldap_users = ldap.search({
            filter: Net::LDAP::Filter.eq('uid', username),
            base: @@ldap_yml['base']
          })
          return fail!(:user_not_found) if ldap_users.empty?
          
          ldap_user = ldap_users[0]
          player = Player.find_by(username: username)
          # Create the player if it doesn't exist
          player = Player.create(username: username, name: '...') unless player
          player.email = ldap_user.mail[0] if ldap_user.mail.length > 0
          player.name = ldap_user.cn[0] if ldap_user.cn.length > 0
          success! player
        end
      end

      def username
        params[:player][:username].downcase
      end

      def password
        params[:player][:password]
      end
    end
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)
