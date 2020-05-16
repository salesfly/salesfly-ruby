module Salesfly
  class PDFAPI

    def initialize(rest_client)
      @rest_client = rest_client
    end  

    def create(options)
      headers = { 
        "Accept" => "application/pdf"
      }
      return @rest_client.post("/v1/pdf/create", options, headers)
    end  

  end
end    