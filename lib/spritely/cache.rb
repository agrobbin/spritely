require 'digest/md5'
require 'spritely/version'

module Spritely
  # `Cache` is responsible for generating and fetching the current sprite cache
  # `value. It is used to determine whether to generate a new sprite map or not.
  #
  # Passing in a set of objects that respond to `cache_key` will generate an MD5
  # hash that can then be stored in the image itself.
  #
  # Fetching an existing cache key actually reads the PNG file itself. It scans
  # the chunks of the PNG until it finds the `cache_key` keyword, returning the
  # subsequent value found.
  class Cache < Struct.new(:filename)
    PNG_SIGNATURE_LENGTH = 8 # http://www.w3.org/TR/PNG/#5PNG-file-signature
    PNG_INFO_LENGTH = 8 # http://www.w3.org/TR/PNG/#5DataRep
    PNG_CRC_LENGTH = 4 # Cyclic Redundancy Check (CRC) byte-length; http://www.w3.org/TR/PNG/#5Chunk-layout

    def self.generate(*objects)
      Digest::MD5.hexdigest(VERSION + objects.collect(&:cache_key).join)
    end

    def self.busted?(filename, expected_cache_key)
      new(filename).key != expected_cache_key
    end

    def key
      return @key if @key

      File.open(filename) do |file|
        file.read(PNG_SIGNATURE_LENGTH) # we first have to read the signature to fast-forward the IO#pos
        until file.eof?
          each_chunk(file) do |keyword, value|
            if keyword == 'cache_key'
              return @key = value
              break
            end
          end
        end
      end
    end

    private

    def each_chunk(file, &block)
      length = file.read(PNG_INFO_LENGTH).unpack('Na4').first
      yield *file.read(length).unpack('Z*a*')
      file.read(PNG_CRC_LENGTH)
    end
  end
end
