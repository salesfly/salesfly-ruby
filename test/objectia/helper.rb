require "simplecov"
SimpleCov.start do
  track_files "/lib/**/*.rb"
  add_filter "/test/"
end

if ENV["CI"] == "true"
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require "minitest/autorun"
require "json"
require "salesfly"

module SalesflyTest

  class Test < Minitest::Test
    def client
      @client ||= Salesfly::Client.new({
        api_key: ENV["SALESFLY_APIKEY"],
        timeout: 10,
      })
    end
  end

end