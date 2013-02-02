require 'net/https'
require 'uri'
require 'base64'
require 'multi_json'

module Findi
  class Client
    attr_reader :username
    attr_reader :devices

    def initialize(username, password)
      @username = username
      @password = password
      @devices = []

      get_partition
      update_devices
    end

    def update_devices
      body = {
        clientContext: {
          appName: 'FindMyiPhone',
          appVersion: '1.4',
          buildVersion: '145',
          deviceUDID: '0000000000000000000000000000000000000000',
          inactiveTime: 2147483647,
          osVersion: '4.2.1',
          personID: 0,
          productType: 'iPad1,1'
        }
      }
      response = post("fmipservice/device/#{@username}/initClient", body)

      json = MultiJson.load(response.body)
      # TODO: Catch parse error
      raise "Web service error: #{json['error']}" if json['error']

      @devices = []
      json['content'].each do |device|
        @devices << Device.new(device)
      end

      @devices
    end

  private

    def post(path, params = nil)
      # Build URL
      url = @partition ? "https://#{@partition}/#{path}" : "https://fmipmobile.icloud.com/#{path}"

      # Setup connection
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      # Build request
      request = Net::HTTP::Post.new(uri.request_uri)

      # Add headers
      request['Content-type'] = 'application/json; charset=utf-8'
      request['X-Apple-Find-Api-Ver'] = '2.0'
      request['X-Apple-Authscheme'] = 'UserIdGuest'
      request['X-Apple-Realm-Support'] = '1.0'
      request['User-agent'] = 'Find iPhone/1.2 MeKit (iPad: iPhone OS/4.2.1)'
      request['X-Client-Name'] = 'iPad'
      request['X-Client-UUID'] = '0cf3dc501ff812adb0b202baed4f37274b210853'
      request['Accept-Language'] = 'en-us'
      request['Connection'] = 'keep-alive'

      # Auth
      auth = Base64.urlsafe_encode64("#{@username}:#{@password}").chomp
      request['Authorization'] = "Basic #{auth}"

      # Add params as JSON if they exist
      request.body = MultiJson.dump(params) if params

      # Request
      http.request(request)
    end

    def get_partition
      body = {
        clientContext: {
          appName: 'FindMyiPhone',
          appVersion: '1.4',
          buildVersion: '145',
          deviceUDID: '0000000000000000000000000000000000000000',
          inactiveTime: 2147483647,
          osVersion: '4.2.1',
          personID: 0,
          productType: 'iPad1,1'
        }
      }
      response = post("fmipservice/device/#{@username}/initClient", body)
      @partition = response['X-Apple-MMe-Host']
    end
  end
end
