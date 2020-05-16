require 'mime/types'
require 'cgi'

module Salesfly
  VERSION = "1.0.0" unless const_defined?(:VERSION)
  
  class Multipart
    def encode(params, files)
      boundary = self.get_random_string()
      lines = []
      
      params.each do |key, value|
        if value.kind_of?(Array)
          value.each do |v| 
            lines.push(StringParam.new(key, v))
          end  
        else  
          lines.push(StringParam.new(key, value))
        end  
      end

      files.each do |fn|
        lines.push(FileParam.new(fn))
      end

      content = lines.collect {|p| "--" + boundary + "\r\n" + p.to_multipart }.join("")  + "--" + boundary + "--"
      headers = { 
        "Content-Type" => "multipart/form-data; boundary=#{ boundary }",
        "Content-Length" => content.length.to_s
      }
      return content, headers
    end

    def get_random_string(length=32)
      source=("a".."z").to_a + ("A".."Z").to_a + (0..9).to_a
      key=""
      length.times{ key += source[rand(source.size)].to_s }
      return key
    end

  end

  private

  # Formats a basic string key/value pair for inclusion with a multipart post
  class StringParam
    attr_accessor :name, :value
  
    def initialize(k, v)
      @name = k
      @value = v
    end
  
    def to_multipart
      return "Content-Disposition: form-data; name=\"#{CGI::escape(name)}\"\r\n\r\n#{value}\r\n"
    end
  end

  # Formats the contents of a file or string for inclusion with a multipart
  # form post
  class FileParam
    attr_accessor :name, :filename, :content
    
    def initialize(filename)
      @name = File.basename(filename)
      @filename = filename
      @content = File.read(filename)
    end
    
    def to_multipart
      # If we can tell the possible mime-type from the filename, use the
      # first in the list; otherwise, use "application/octet-stream"
      mime_type = MIME::Types.type_for(filename)[0] || MIME::Types["application/octet-stream"][0]
      return "Content-Disposition: form-data; name=\"#{CGI::escape(name)}\"; filename=\"#{ filename }\"\r\n" +
      "Content-Type: #{ mime_type.simplified }\r\n\r\n#{ content }\r\n"
    end
  end
end