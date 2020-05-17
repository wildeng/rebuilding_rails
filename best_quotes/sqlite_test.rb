# best_quotes/sqlite_test.rb
require "sqlite3"
require "rulers/sqlite_model"

class MyTable < Rulers::Model::SQLite; end
STDERR.puts MyTable.schema.inspect

MyTable.create "title" => "It happened!", "posted" => 1, "body" => "It did!"
mt = MyTable.create "title" => "I saw it!"

mt.title = "I saw it again twice"
mt.body = "Oh yeah here we are"
mt.save!
mt2 = MyTable.find mt["id"]

puts "Title: #{mt["title"]}"
puts "Body: #{mt.body}"
