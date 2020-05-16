module Salesfly
  class UsageAPI

    def initialize(rest_client)
      @rest_client = rest_client
    end  

    def get()
      return @rest_client.get("/v1/usage")
    end  

  end
end    