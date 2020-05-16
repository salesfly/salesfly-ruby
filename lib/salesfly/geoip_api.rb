module Salesfly
  class GeoLocationAPI

    def initialize(rest_client)
      @rest_client = rest_client
    end  

    def get(ip, options={})
      query = URI.encode_www_form(options)
      return @rest_client.get("/v1/geoip/#{ip}?#{query}")
    end  

    def get_current(options={})
      return self.get("myip", options)
    end  

    def get_bulk(ip_list, options={})
      ip = ip_list.join(",")
      return self.get(ip, options)
    end  

  end
end    