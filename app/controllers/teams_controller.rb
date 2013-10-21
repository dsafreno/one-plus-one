class TeamsController < ApplicationController
  def create
    @team = Team.new(team_params)
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

  def options
    @team = Team.find(params[:id])
    @ids = @team.people.map { |person| person.id }
    render json: Person.where.not(id: @ids)
  end

  def add
    print params
    @team = Team.find(params[:id])
    @person = Person.find(params[:person_id])
    @team.people += [@person]
    render json: @person
  end

  def remove
    @team = Team.find(params[:id])
    @person = Person.find(params[:person_id])
    @team.people -= [@person]
    render json: @person
  end

  def destroy
    @team = Team.find(params[:id])
    render json: @team.destroy
  end

  private
  def team_params
    params.require(:team).permit(:id, :name)
  end
end
