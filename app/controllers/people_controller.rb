class PeopleController < ApplicationController
  def create
    @person = Person.new(params[:person])
    if @person.save
      render json: @person
    else
      render json: { errors: @person.errors.as_json }, status: 420
    end
  end

  def index
    render json: Person.all
  end

  def destroy
    @person = Person.find(params[:person])
    @person.destroy
  end
end
