module Spritely
  Image = Struct.new(:data) do
    attr_accessor :top, :left
  end
end
