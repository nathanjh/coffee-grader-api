class CoffeesController < ApplicationController
  before_action :find_coffee, only: [:show, :update, :destroy]
  # GET '/coffees'
  def index
    @coffees = Coffee.all
  end

  # GET '/coffees/:id'
  def show
  end

  # POST '/coffees'
  def create
    @coffee = Coffee.create!(coffee_params)
  end

  # PATCH '/coffees/:id'
  def update
    @coffee.update(coffee_params)
  end

  # DELETE '/coffees/:id'
  def destroy
    @coffee.destroy
  end

  private

  def find_coffee
    @coffee = Coffee.find(params[:id])
  end

  def coffee_params
    params.require(:coffee).permit(:name, :origin, :farm)
  end
end
