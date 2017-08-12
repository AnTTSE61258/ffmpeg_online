class HomeController < ApplicationController
  def index
    current_request
    @formats = Format.all
  end
end
