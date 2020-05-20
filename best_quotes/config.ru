# best_quotes/config.ru
require './config/application'
app = BestQuotes::Application.new

# class BenchMarker
#   def initialize(app, runs = 100)
#     @app, @runs = app, runs
#   end
#
#   def call(env)
#     t = Time.now
#
#     result = nil
#     @runs.times { result = @app.call(env) }
#
#     t2 = Time.now - t
#     STDERR.puts <<-OUTPUT
#     Benchmark:
#     #{@runs} runs
#     #{t2.to_f} seconds total
#     #{t2.to_f * 1000.0 / @runs} millisec/run
#     OUTPUT
#     result
#   end
# end
#
#  use BenchMarker, 1

use Rack::ContentType

app.route do
  match '', 'quotes#index'

  # default routes
  match ':controller/:id/:action'
  match ':controller/:id', :default => {'action' => 'show'}
  match ':controller', :default => {'action' => 'index'}
  match 'sub-app', proc { [200, {}, ['Hello, sub-app!']] }
end

run app
