require 'pairing_maker'

desc "Makes next set of weekly pairings"
task make_pairings: :environment do
  PairingMaker.make_pairings
end
