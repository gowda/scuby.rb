# frozen_string_literal: true

module FileFixtureHelper
  def file_fixture(name)
    File.open(File.expand_path("../fixtures/#{name}", __dir__))
  end
end

RSpec.configure do |config|
  config.include FileFixtureHelper
end
