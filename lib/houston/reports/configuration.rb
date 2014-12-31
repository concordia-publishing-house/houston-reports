module Houston::Reports
  class Configuration
    
    def initialize
      config = Houston.config.module(:reports).config
      instance_eval(&config) if config
    end
    
    # Define configuration DSL here
    
  end
end
