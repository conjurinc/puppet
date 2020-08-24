# frozen_string_literal: true

require 'conjur/puppet_module/ssl'

module Conjur
  module PuppetModule
    # This module is in charge of interacting with the Conjur endpoints
    module HTTP
      class << self
        def directory_uri(url)
          url += '/' unless url.end_with? '/'
          URI url
        end

        def get(host_url, path, ssl_certificate, token)
          uri = directory_uri(host_url) + path
          use_ssl = uri.scheme == 'https'
          certs = Conjur::PuppetModule::SSL.load(ssl_certificate)

          headers = {}
          if token
            encoded_token = Base64.urlsafe_encode64(token)
            headers['Authorization'] = "Token token=\"#{encoded_token}\""
          end

          Net::HTTP.start uri.host, uri.port, use_ssl: use_ssl, cert_store: certs do |http|
            response = http.get(uri.request_uri, headers)

            raise Net::HTTPError.new response.message, response unless response.code.match?(%r{^2})

            response.body
          end
        end

        def post(host_url, path, ssl_certificate, data)
          uri = directory_uri(host_url) + path

          raise(ArgumentError, "POST data to #{uri} must not be empty!") \
            if data.nil? || data.empty?

          use_ssl = uri.scheme == 'https'
          certs = Conjur::PuppetModule::SSL.load(ssl_certificate)

          Net::HTTP.start uri.host, uri.port, use_ssl: use_ssl, cert_store: certs do |http|
            response = http.post(uri.request_uri, data)

            raise Net::HTTPError.new response.message, response unless response.code.match?(%r{^2})

            response.body
          end
        end
      end
    end
  end
end
