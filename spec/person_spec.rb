require 'spec_helper'

describe Person do
  before { @person = Person.new(name: 'Doug', email: 'something@something.com') }
  subject { @person }

  it { should respond_to(:name) }
  it { should respond_to(:email) }

  it { should be_valid }

  describe 'when name is not present' do
    before { @person.name = ' ' }
    it { should_not be_valid }
  end

  describe 'when email is not present' do
    before { @person.email = ' ' }
    it { should_not be_valid }
  end

  describe 'when email is not properly formatted' do
    before { @person.email = 'dsafreno%somesite.com' }
    it { should_not be_valid }
  end
end
