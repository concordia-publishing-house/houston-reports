require "houston/reports/engine"
require "houston/reports/configuration"

module Houston
  module Reports
    extend self

    def config(&block)
      @configuration ||= Reports::Configuration.new
      @configuration.instance_eval(&block) if block_given?
      @configuration
    end

  end
end
