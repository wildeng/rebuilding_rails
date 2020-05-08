# best_quotes/app/controllers/quotes_controller.rb
class QuotesController < Rulers::Controller

	attr_accessor :initial_quote
  attr_accessor :final_quote

  def index
    quotes = FileModel.all
    render :index, quotes: quotes
  end

  def update
    # TODO: this needs to be more general
    file_model = FileModel.find(1)
    attrs = {
      'submitter' => 'Super Mario',
      'quote' => file_model['quote'],
      'attribution' => file_model['attribution']
    }
    file_model.update_attrs(attrs)
    render :quote, obj: file_model
  end

  def new_quote
    attr = {
      'submitter' => 'web user',
      'quote' => 'A picture is worth k pixels',
      'attribution' => 'Noah Gibbs'
    }

    m = FileModel.create attr
    render :quote, obj: m
  end

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

  def quotes_by_id
    quotes = FileModel.find_all_by_id(id: 1)
    render :index, quotes: quotes  
  end

  def quote_1
    quote_1 = FileModel.find(1)
    render :quote, obj: quote_1
  end

  def exception
    raise "It's a bad one!"
  end
end
