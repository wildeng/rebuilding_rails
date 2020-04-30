# rulers/lib/rulers/file_model.rb
require 'multi_json'
module Rulers
  module Model
    class FileModel
      def initialize(filename)
        @filename = filename

        # if filename is "dir/37.json", @id is 37
        basename = File.split(filename)[-1]
        @id = File.basename(basename, ".json").to_i

        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.find(id)
        FileModel.new("db/quotes/#{id}.json")
      rescue
        # TODO: rescue the exception and log
        return nil
      end
    end
  end
end
