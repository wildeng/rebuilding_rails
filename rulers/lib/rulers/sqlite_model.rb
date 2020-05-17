# rulers/lib/rulers/sqlite_model.rb
require 'sqlite3'
require 'rulers/util'

DB = SQLite3::Database.new "test.db"

module Rulers
  module Model
    class SQLite
      def initialize(data = nil )
        @hash = data
      end

      def method_missing(method_name, *arguments, &block)
        if self.respond_to?(:[],"#{method_name}")
          if method_name.to_s.index("=")
            name = method_name.to_s.gsub(/=/,'')
            return self.send(:[]=, "#{name}", arguments[0])
          else
            return self["#{method_name}"]
          end
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        method_name.to_s || super
      end

      def save!
        unless @hash["id"]
          self.class.create
          return true
        end

        fields = @hash.map do |k,v|
          "#{k} = #{self.class.to_sql(v)}"
        end.join ","
        sql = <<-SQL
        UPDATE #{self.class.table}
        SET #{fields}
        WHERE id = #{@hash["id"]}
        SQL
        DB.execute sql
        true
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name,value)
        @hash[name.to_s] = value
      end

      def save
        self.save!
      rescue StandardError => e
        STDERR.puts "Error while saving the object"
        STDERR.puts e.backtrace.join("\n")
      end

      class << self
        def count
          DB.execute(<<-SQL)[0][0]
          SELECT COUNT(*) FROM #{table}
          SQL
        end

        def create(values)
          values.delete "id"
          keys = schema.keys - ["id"]
          vals = keys.map do |key|
            values[key] ? to_sql(values[key]) : 'null'
          end

          DB.execute <<-SQL
          INSERT INTO #{table} (#{keys.join(',')})
          VALUES (#{vals.join(',')});
          SQL

          raw_vals = keys.map { |k| values[k] }
          data = Hash[keys.zip raw_vals]
          sql = "SELECT last_insert_rowid();"
          data["id"] = DB.execute(sql)[0][0]
          self.new data
        end

        def find(id)
          row = DB.execute <<-SQL
          SELECT #{schema.keys.join ","} FROM
          #{table} where id = #{id};
          SQL
          data = Hash[schema.keys.zip row[0]]
          self.new data
        end

        def schema
          return @schema if @schema
          @schema = {}
          DB.table_info(table) do |row|
            @schema[row['name']] = row['type']
          end

          # @schema.each do |name, type|
          #   define_method(name) do
          #     self[name]
          #   end
          #   define_method("#{name}=") do |value|
          #     self[name] = value
          #   end
          # end
          @schema
        end

        def table
          Rulers.to_underscore name
        end

        def to_sql(val)
          case val
          when NilClass
            'null'
          when Numeric
            val.to_s
          when String
            "'#{val}'"
          else
            raise "Can't change #{val.class} to SQL!"
          end
        end
      end
    end
  end
end
