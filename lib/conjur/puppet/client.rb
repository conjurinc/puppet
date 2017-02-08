require 'uri'
require_relative 'validator'

module Conjur
  module Puppet
    class Client < Struct.new :uri, :cert
      def initialize uri, cert
        if uri.respond_to? :request_uri
          @uri = uri
        else
          # not an URI instance, add slash in case it's ommited
          @uri = URI (uri + '/')
        end
        @cert = cert && OpenSSL::X509::Certificate.new(cert)
      end

      attr_reader :uri, :cert

      def authenticate login, key
        post "authn/users/" + URI.encode_www_form_component(login) + "/authenticate", key
      end

      def post path, content
        response = http.post (uri + path).request_uri, content
        raise Net::HTTPError.new response.message, response unless response.code =~ /^2/
        response.body
      end

      def http
        @http ||= ::Puppet::Network::HttpPool.http_ssl_instance uri.host, uri.port, validator
      end

      def validator
        @validator ||= Validator.new cert
      end

      def variable_value id, token: nil
        get "variables/" + URI.encode_www_form_component(id) + "/value", token: token
      end

      def get path, token: nil
        if token
          encoded_token = Base64.urlsafe_encode64 token
          headers = { 'Authorization' => "Token token=\"#{encoded_token}\"" }
        end
        response = http.get (uri + path).request_uri, headers
        raise Net::HTTPError.new response.message, response unless response.code =~ /^2/
        response.body
      end
    end
  end
end