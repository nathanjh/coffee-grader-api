class CoffeeGraderApiController < ApplicationController
  before_action :authenticate_user!
  # perhaps also include a method to parse json requests here
  # before_action :parse_request

  # private

  # def parse_request
  #   @json_request = JSON.parse(request.body)
  # end
end
