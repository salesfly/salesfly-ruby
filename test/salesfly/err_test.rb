require_relative "./helper"

module SalesflyTest
  class SalesflyErrTest < SalesflyTest::Test

    def test_response_error
      begin
        raise Salesfly::ResponseError.new("Not found", 404, "err-not-found")
      rescue Salesfly::ResponseError => e
        assert_equal "Not found", e.message
        assert_equal 404, e.status
        assert_equal "err-not-found", e.code
      end
    end

  end
end