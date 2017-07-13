class CoffeeGraderApiController < ApplicationController
  before_action :authenticate_user!
  # perhaps also include a method to parse json requests here
  # before_action :parse_request

  private

  def pagination_options
    options = {}
    [:limit, :page].each do |key|
      options[key] = params[key].to_i if params[key]
    end
    options
  end

  # def parse_request
  #   @json_request = JSON.parse(request.body)
  # end
end
