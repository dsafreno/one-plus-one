class TeamsController < ApplicationController
  def create
    @team = Team.new(params[:team])
    if @team.save
      render json: @team
    else
      render json: { errors: @team.errors.as_json }, status: 420
    end
  end

  def index
    render json: Team.all
  end

  def people
    @team = Team.find(params[:id])
    render json: @team.people
  end

  def add
    @team = Team.find(params[:id])
    @person = Person.find(params[:person_id])
    @team.people += [@person]
  end

  def remove
    @team = Team.find(params[:id])
    @team.people -= [@person]
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
  end
end
