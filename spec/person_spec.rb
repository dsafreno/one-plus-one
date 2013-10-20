require 'spec_helper'

describe Person do
  before do
    @existing_person = Person.create(name: 'Sam', email: 'sam@somesite.com')
    @person = Person.new(name: 'Doug', email: 'dsafreno@somesite.com')
  end
  subject { @person }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:teams) }
  it { should respond_to(:pairings) }

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

  describe 'when email is nonunique' do
    before { @person.email = @existing_person.email }
    it { should_not be_valid }
  end

  describe 'when email is nonunique but uppercased' do
    before { @person.email = @existing_person.email.upcase }
    it { should_not be_valid }
  end

  describe 'when name is not properly titelized' do
    before do
      @person.name = @person.name.upcase
      @person.valid?
    end
    it 'should titelize before saving' do
      @person.name.should eq (@person.name.titleize)
    end
  end

  describe 'when email is unique but uppercased' do
    before do
      @old_email = @person.email
      @person.email = @old_email.upcase
      @person.valid?
    end
    it 'should downcase before saving' do
      @person.email.should eq(@old_email)
    end
  end
end
