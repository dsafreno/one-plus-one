require 'spec_helper'

describe Team do
  before { @team = Team.new(name: 'Engineering') }

  subject { @team }

  it { should respond_to :name }
  it { should respond_to :people }
  it { should be_valid }

  describe 'when name is not present' do
    before { @team.name = ' ' }
    it { should_not be_valid }
  end
end
