require 'spec_helper'
require 'pairing_maker'

describe PairingMaker do
  before do
    @people = [
      Person.create(name: 'Doug', email: 'doug@somesite.com'),
      Person.create(name: 'Sam', email: 'sam@somesite.com'),
      Person.create(name: 'Kyle', email: 'kyle@somesite.com')
    ]
    @teams = [
      Team.create(name: 'UX'),
      Team.create(name: 'Infra')
    ]
    @teams[0].people += [@people[0], @people[1]]
    @teams[1].people += [@people[1], @people[2]]
  end

  describe 'when its the first set of pairings' do
    it 'should compute week 0' do
      PairingMaker.compute_week.should eq(0)
    end
  end

  describe 'when there have been a couple weeks of pairings' do
    before do
      Pairing.create(first_person: @people[0], second_person: @people[1], week: 0)
      Pairing.create(first_person: @people[2], second_person: @people[1], week: 1)
    end

    it 'should compute the correct week' do
      PairingMaker.compute_week.should eq(2)
    end

    it 'should compute the correct happiness per pairing' do
      new_pairing = Pairing.new(first_person: @people[1], second_person: @people[0], week: 2)
      PairingMaker.pairing_happiness(new_pairing).should eq(2)
    end

    describe 'when the pairings are calculated' do
      before do
        @pairings = PairingMaker.find_pairings_for(2)
      end

      it 'should compute the ideal first person' do
        @pairings.first.first_person.should eq(@people[0])
      end

      it 'should compute the ideal second person' do
        @pairings.first.second_person.should eq(@people[1])
      end
    end
  end
end
