class CreatePeopleTeams < ActiveRecord::Migration
  def change
    create_table :people_teams, :id => false do |t|
      t.integer :person_id
      t.integer :team_id
    end
  end
end
