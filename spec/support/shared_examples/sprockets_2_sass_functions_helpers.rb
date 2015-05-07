module Sprockets2SassFunctionsHelpers
  def evaluate(value)
    Sprockets::ScssTemplate.new { value }.evaluate(sprockets_environment.context_class.new(sprockets_environment, nil, nil), nil)
  end

  def sprockets_environment
    @sprockets_environment ||= Sprockets::Environment.new.tap do |sprockets_environment|
      sprockets_environment.context_class.class_eval do
        def asset_path(path, options = {}); path; end
      end
    end
  end
end
