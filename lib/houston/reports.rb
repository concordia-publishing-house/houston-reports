require "houston/reports/engine"
require "houston/reports/configuration"

module Houston
  module Reports
    extend self
    
    attr_reader :config
    
  end
  
  Reports.instance_variable_set :@config, Reports::Configuration.new
end
