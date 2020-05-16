module Salesfly
  class ResponseError < APIError
    attr_reader :status, :code

    def initialize(msg="", status=400, code="")
      @status = status
      @code = code
      super(msg)
    end
  end
end