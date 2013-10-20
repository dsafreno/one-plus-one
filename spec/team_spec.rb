require 'spec_helper'

describe Team do
  before do
    @existing_team = Team.create(name: 'QE')
    @team = Team.new(name: 'UX')
  end

  subject { @team }

  it { should respond_to :name }
  it { should respond_to :people }
  it { should be_valid }

  describe 'when name is not present' do
    before { @team.name = ' ' }
    it { should_not be_valid }
  end

  describe 'when name is not unique' do
    before { @team.name = @existing_team.name }
    it { should_not be_valid }
  end
end
