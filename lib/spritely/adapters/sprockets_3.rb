module Spritely
  module Adapters
    class Sprockets3
      def reset_cache!(environment, filename)
        environment.instance_variable_get(:@uris).delete_if { |_, asset| asset.pathname == filename }
        environment.instance_variable_get(:@entries).delete(Spritely.directory.to_s)
        environment.instance_variable_get(:@stats).delete(filename.to_s)
      end
    end
  end
end
