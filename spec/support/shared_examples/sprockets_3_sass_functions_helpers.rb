module Sprockets3SassFunctionsHelpers
  def evaluate(value)
    Sprockets::ScssProcessor.call(environment: sprockets_environment, data: value, filename: "test.scss", metadata: {}, cache: Sprockets::Cache.new)[:data]
  end

  def sprockets_environment
    @sprockets_environment ||= Sprockets::CachedEnvironment.new(Sprockets::Environment.new).tap do |sprockets_environment|
      sprockets_environment.context_class.class_eval do
        def depend_on(path); end
        def depend_on_asset(path); end
        def asset_path(path, options = {}); path; end
      end
    end
  end
end
