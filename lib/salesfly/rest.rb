module Salesfly
  class REST

    def initialize(options = {})
      @api_key = options[:api_key]
      @api_base_url = options.fetch(:api_base_url) { "https://api.salesfly.com" }   
      @timeout = options.fetch(:timeout) { 30 }   
      @user_agent =  "salesfly-ruby/#{VERSION}"                   
    end

    def api_key
      if @api_key.to_s.empty?
        raise ArgumentError.new("No API key provided") 
      end
      @api_key
    end

    def get(path, headers={})
      execute("GET", path, nil, headers)
    end   

    def post(path, data, headers={})
      execute("POST", path, data, headers)
    end   

    def put(path, data, headers={})
      execute("PUT", path, data, headers)
    end   

    def patch(path, data, headers={})
      execute("PATCH", path, data, headers)
    end   

    def delete(path, headers={})
      execute("DELETE", path, nil, headers)
    end   

    def execute(method, path, data, headers={})
      std_headers = { 
        "User-Agent" => @user_agent, 
        "Authorization" => "Bearer #{api_key}", 
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      } 
      headers = std_headers.merge(headers)

      begin
        RestClient::Request.execute(method: method, url: @api_base_url + path, payload: data, headers: headers, timeout: @timeout) { |response, request, result, &block|
          # print &block
          case response.code
          when 200, 201
            if headers["Accept"] == "application/pdf"
              return response
            end  
            body = JSON.parse(response) 
            return body["data"]            
          else
            begin
              err = JSON.parse(response)
              raise ResponseError.new(err["message"], response.code, err["code"])
            rescue JSON::ParserError
              raise ResponseError.new(response.body, response.code)  # code?
            rescue Timeout::Error, Net::ReadTimeout => e
              raise APITimeoutError.new(e.message)
            rescue Errno::ECONNREFUSED, Errno::EINVAL, Errno::ECONNRESET, EOFError,
              Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,
              SocketError => e
              raise APIConnectionError.new(e.message)
            end
          end
        }
      end
  

      # begin
      #   case method
      #   when "GET"
      #     resp = self.class.get(path, base_uri: @api_base_url, timeout: @timeout, :headers => headers)
      #   when "POST"
      #     resp = self.class.post(path, base_uri: @api_base_url, timeout: @timeout, :headers => headers, :body => data, multipart: true)
      #   when "PUT"
      #     resp = self.class.put(path, base_uri: @api_base_url, timeout: @timeout, :headers => headers, :body => data)
      #   when "PATCH"
      #     resp = self.class.patch(path, base_uri: @api_base_url, timeout: @timeout, :headers => headers, :body => data)
      #   when "DELETE"  
      #     resp = self.class.delete(path, base_uri: @api_base_url, timeout: @timeout, :headers => headers)
      #   end  

      #   if [200,201].include?(resp.code)
      #     result = JSON.parse(resp.body) #FIXME: Handle 204 No content
      #     return result["data"]
      #   else  
      #     begin
      #       err = JSON.parse(resp.body)
      #       raise ResponseError.new(err["message"], resp.code, err["code"])
      #     rescue JSON::ParserError
      #       raise ResponseError.new(resp.message, resp.code)  # code?
      #     end
      #   end  
      # rescue Timeout::Error, Net::ReadTimeout => e
      #   raise APITimeoutError.new(e.message)
      # rescue Errno::ECONNREFUSED, Errno::EINVAL, Errno::ECONNRESET, EOFError,
      #   Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,
      #   HTTParty::Error, SocketError => e
      #   raise APIConnectionError.new(e.message)
      # end
    end

  end
end  
