module Spritely
  class Image < Struct.new(:data)
    attr_accessor :top, :left
  end
end
