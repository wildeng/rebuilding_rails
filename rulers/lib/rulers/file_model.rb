# rulers/lib/rulers/file_model.rb
require 'multi_json'
module Rulers
  module Model
    class FileModel
      attr_accessor :caching
      attr_accessor :file_cache
      @@db_folder = 'db/quotes'

      def initialize(filename)
        @caching = true
        @file_cache = []
        @filename = filename
        basename = File.split(filename)[-1]
        @id = File.basename(basename, ".json").to_i
        obj = obj_from_cache
        obj = File.read(filename) unless obj
        push_obj_to_cache(obj)
        @hash = MultiJson.load(obj)
      end
      
      def id
        @id
      end

      def db_folder
        @db_folder = self.class&.db_folder || 'db/quotes' 
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def update_attrs(attrs)
        update(attrs)
        save
      end

      def save
         # TODO: explore the use of MultiJson.dump() to improve this method
         template = <<-TEMPLATE
        {
          "submitter": "#{self["submitter"]}",
          "quote": "#{self["quote"]}",
          "attribution": "#{self["attribution"]}"
        }
        TEMPLATE

        File.open("#{@@db_folder}/#{@id}.json", "w") do |f|
          f.write(template) 
        end
        reload
        rescue StandardError => e
        # TODO: write a nice logging
        nil
      end

      def reload
        f = self.class.find(@id)
        attrs = {
          'submitter' => f['submitter'],
          'quote' => f['quote'],
          'attribution' => f['attribution']
        }
        update(attrs)
      end

      def self.db_folder
        @@db_folder
      end

      def self.find(id)
        FileModel.new("#{@@db_folder}/#{id}.json")
      rescue
        # TODO: rescue the exception and log
        return nil
      end

      def self.all
        files = Dir["#{@@db_folder}/*.json"]
        files.map {|f| FileModel.new f }
      end 
      
      def self.create(attrs)
        hash = {}
        hash["submitter"] = attrs["submitter"] || ""
        hash["quote"] = attrs["quote"] || ""
        hash["attribution"] = attrs["attribution"] || ""
        
        files = Dir["#{@@db_folder}/*.json"]
        names = files.map { |f| f.split("/")[-1] }
        highest = names.map { |b| b[0...-5].to_i }.max
        id = highest ? highest + 1 : 1
        template = <<-TEMPLATE
        {
          "submitter": "#{hash["submitter"]}",
          "quote": "#{hash["quote"]}",
          "attribution": "#{hash["attribution"]}"
        }
        TEMPLATE

        File.open("#{@@db_folder}/#{id}.json", "w") do |f|
          f.write(template) 
        end
        FileModel.new "#{@@db_folder}/#{id}.json"
      end

      def self.method_missing(method_name, *arguments, &block)
        if method_name.to_s =~  /^find_all_by_(.*)/
          attrib = method_name[12..-1]
          return self.find_all(attrib, arguments[0])
        else
          super
        end
      end

      def self.respond_to_missing?(method_name, include_private = false)
        method_name.to_s.start_with?('find_all_by_') || super
      end

      def self.find_all(attrib, value)
        results = []
        id = 1
        loop do 
          obj = FileModel.find(id)
          return results unless obj
          results.push(obj) if obj[attrib] == value
          id += 1
        end
      end

      private

      def obj_from_cache
        return unless caching?
        puts "Loading object with id: #{@id} from cache"
        @file_cache.select { |obj| obj[:id] == @id }.first 
      end

      def remove_obj_from_cache
        puts "Removing object with id: #{@id} from cache"
        @file_cache.delete { |obj| obj[:id] == @id }
      end

      def push_obj_to_cache(obj)
        if caching?
          puts "Saving object with id: #{@id} to cache"
          @file_cache.push(
            { id: @id, obj: obj}
          ) unless obj_in_cache?
          @file_cache.sort_by! { |obj| obj[:id]}
        end
      end

      def obj_in_cache?
        puts "Object with id: #{@id} is already saved in cache"
        @file_cache.any? { |obj| obj[:id] == @id }
      end

      def caching?
        @caching
      end

      def update(attrs)
        self['submitter'] = attrs['submitter']
        self['quote'] = attrs['quote']
        self['attribution'] = attrs['attribution']
        self
      end 
    end
  end
end
