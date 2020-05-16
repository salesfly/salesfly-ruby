module Salesfly
  class MailAPI

    SCHEMA = {
      "type" => "object",
      "properties" => {
        "date" => {
          "type" => "string",
          "format" => "date-time"
        },
        "from" => {
          "type" => "string",
          "maxLength" => 50
        },
        "from_name" => {
          "type" => "string",
          "maxLength" => 50
        },
        "to" => {
          "type" => "array",
          "minLength" => 1,
          "maxLength" => 50,
          "items" => {
            "type" => "string",
          }
        },
        "cc" => {
          "type" => "array",
          "minLength" => 1,
          "maxLength" => 50,
          "items" => {
            "type" => "string"
          }
        },
        "bcc" => {
          "type" => "array",
          "minLength" => 1,
          "maxLength" => 50,
          "items" => {
            "type" => "string"
          }
        },
        "reply_to" => {
          "type" => "string",
          "maxLength" => 50
        },
        "subject" => {
          "type" => "string",
          "maxLength" => 100
        },
        "text" => {
          "type" => "string"
        },
        "html" => {
          "type" => "string"
        },
        "attachments" => {
          "type" => "array",
          "maxLength" => 10,
          "items" => {
            "type" => "string"
          }
        },
        "tags" => {
          "type" => "array",
          "maxLength" => 3,
          "items" => {
            "type" => "string",
            "maxLength" => 20,
          }
        },
        "charset" => {
          "type" => "string",
          "maxLength" => 20
        },
        "encoding" => {
          "type" => "string",
          "maxLength" => 20
        },
        "require_tls" => {
          "type" => "boolean"
        },
        "verify_cert" => {
          "type" => "boolean"
        },
        "open_tracking" => {
          "type" => "boolean"
        },
        "click_tracking" => {
          "type" => "boolean"
        },
        "text_click_tracking" => {
          "type" => "boolean"
        },
        "unsubscribe_tracking" => {
          "type" => "boolean"
        },
        "test_mode" => {
          "type" => "boolean"
        }
      },
      "required" => ["from", "to", "subject", "text"],
      "additionalProperties" => false
    }

    def initialize(rest_client)
      @rest_client = rest_client
    end  

    def send(message)
      # Validate message
      begin
        JSON::Validator.validate!(SCHEMA, message, :strict => false)
      rescue JSON::Schema::ValidationError => e
        raise ArgumentError.new("Message has missing or invalid attributes")
      end
      # Extract files
      files = []
      if message.key?("attachments")
        files = message["attachments"]
        message = message.reject { |k,v| k == "attachments" }
      end
      multipart = Multipart.new
      content, headers = multipart.encode(message, files)
      return @rest_client.post("/v1/mail/send", content, headers)
    end  

  end
end    