module Spritely
  module Adapters
    class Sprockets2
      def reset_cache!(environment, filename)
        environment.instance_variable_get(:@assets).delete_if { |_, asset| asset.pathname == filename }
        environment.send(:trail).tap do |trail|
          trail.instance_variable_get(:@entries).delete(Spritely.directory.to_s)
          trail.instance_variable_get(:@stats).delete(filename.to_s)
        end
      end
    end
  end
end
