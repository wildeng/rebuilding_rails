# sample_dir/config.ru

require 'rack/lobster'
use Rack::ContentType

class BenchMarker
  def initialize(app, runs = 100)
    @app, @runs = app, runs
  end

  def call(env)
    t = Time.now

    result = nil
    @runs.times { result = @app.call(env) }

    t2 = Time.now - t
    STDERR.puts <<-OUTPUT
    Benchmark:
    #{@runs} runs
    #{t2.to_f} seconds total
    #{t2.to_f * 1000.0 / @runs} millisec/run
    OUTPUT
    result
  end
end

 use BenchMarker, 10_000


 map "/lobster" do
   use Rack::ShowExceptions
   run Rack::Lobster.new
 end

 map "/sleep" do
   run proc {
     sleep 0.0001
   [200, {}, ["this is a sleep"]]
   }
 end

 map "/lobster/but_not" do
   run proc {
   [200, {}, ["really not a lobster"]]
   }
 end
 #
 # run proc {
 #   [200, {}, ["not a lobster"]]
 # }
