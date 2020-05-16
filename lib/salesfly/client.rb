module Salesfly
  class Client
    ##
    # A client for accessing the Salesfly API.

    def initialize(options = {})
      @rest_client = Salesfly::REST.new(options) 
      @usage_api = Salesfly::UsageAPI.new(@rest_client)
      @geoip_api = Salesfly::GeoLocationAPI.new(@rest_client)
      @mail_api = Salesfly::MailAPI.new(@rest_client)
      @pdf_api = Salesfly::PDFAPI.new(@rest_client)
    end

    def api_key
      @rest_client.api_key
    end

    def version()
      VERSION
    end

    def usage()
      @usage_api
    end

    def geoip()
      @geoip_api
    end

    def mail()
      @mail_api
    end

    def pdf()
      @pdf_api
    end

  end
end