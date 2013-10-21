class PeopleController < ApplicationController
  def create
    @person = Person.new(person_params)
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
    @person = Person.find(params[:id])
    render json: @person.destroy
  end

  private
  def person_params
    params.require(:person).permit(:id, :name, :email)
  end
end
