require_relative 'test_helper'

class TestController < Rulers::Controller
  def index
    'Hello' # not rendering any view
  end
end
