# rulers/lib/rulers/file_model.rb
require 'multi_json'
module Rulers
  module Model
    class FileModel
      @@db_folder = 'db/quotes'

      def initialize(filename)
        @filename = filename

        # if filename is "dir/37.json", @id is 37
        basename = File.split(filename)[-1]
        @id = File.basename(basename, ".json").to_i

        obj = File.read(filename)
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

      private

      def update(attrs)
        self['submitter'] = attrs['submitter']
        self['quote'] = attrs['quote']
        self['attribution'] = attrs['attribution']
        self
      end 
    end
  end
end
