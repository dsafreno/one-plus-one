require 'spec_helper'

describe Pairing do
  before do
    @person1 = Person.create(name: 'Doug', email: 'doug@somesite.com')
    @person2 = Person.create(name: 'Sam', email: 'sam@somesite.com')
    @person3 = Person.create(name: 'Kyle', email: 'kyle@somesite.com')
    @person4 = Person.create(name: 'Allison', email: 'allison@somesite.com')
    @unsaved_person = Person.new(name: 'Nikhil', email: 'nikhil@somesite.com')
    @old_pairing = Pairing.create(first_person: @person3, second_person: @person4, week: 6)
    @pairing = Pairing.new(first_person: @person1, second_person: @person2, week: 5)
  end

  subject { @pairing }

  it { should respond_to :first_person }
  it { should respond_to :second_person }
  it { should respond_to :week }
  it { should be_valid }

  describe 'when first person is not present' do
    before do
      @pairing.first_person_id = 5
      @pairing.first_person = nil
    end
    it { should_not be_valid }
  end

  describe 'when first person is not present in db' do
    before { @pairing.first_person = @unsaved_person }
    it { should_not be_valid }
  end

  describe 'when second person is not present' do
    before do
      @pairing.second_person_id = 5
      @pairing.second_person = nil
    end
    it { should_not be_valid }
  end

  describe 'when second person is not present in db' do
    before { @pairing.second_person = @unsaved_person }
    it { should_not be_valid }
  end

  describe 'when week is not present' do
    before { @pairing.week = nil }
    it { should_not be_valid }
  end

  describe 'when the first person in the pairing is already paired for the week' do
    before do
      @pairing.first_person = @old_pairing.first_person
      @pairing.week = @old_pairing.week
    end
    it { should_not be_valid }
  end

  describe 'when the second person in the pairing is already paired for the week' do
    before do
      @pairing.second_person = @old_pairing.second_person
      @pairing.week = @old_pairing.week
    end
    it { should_not be_valid }
  end

  describe 'when the people in the pairing are already paired for a different week' do
    before do
      @pairing.first_person = @old_pairing.first_person
      @pairing.second_person = @old_pairing.second_person
      @pairing.week = @old_pairing.week + 1
    end
    it { should be_valid }
  end
end
