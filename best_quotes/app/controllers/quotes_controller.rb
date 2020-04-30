# best_quotes/app/controllers/quotes_controller.rb
class QuotesController < Rulers::Controller
  
	attr_accessor :initial_quote
  attr_accessor :final_quote

  def a_quote
		@initial_quote = "Initial quote"
		@final_quote = "Final quote"
    render :a_quote, noun: :winking
  end
  
  def a_change
		@initial_quote = "Initial change"
		@final_quote = "Final change"

    render :a_change
  end

  def quote_1
    quote_1 = Rulers::Model::FileModel.find(1)
    render :quote, obj: quote_1
  end
  
  def exception
    raise "It's a bad one!"
  end
end
