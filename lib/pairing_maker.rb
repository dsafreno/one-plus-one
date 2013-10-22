module PairingMaker
  def PairingMaker.make_pairings
    week = compute_week
    pairings = find_pairings_for(week)
    save_and_mail(pairings)
  end

  def PairingMaker.save_and_mail(pairings)
    pairings.each do |p|
      p.save
      PersonMailer.pairing_email(p.first_person, p.second_person).deliver
      PersonMailer.pairing_email(p.second_person, p.first_person).deliver
    end
  end

  def PairingMaker.find_pairings_for(week)
    happinesses = compute_happinesses(week)
    pick_order = happinesses.keys.sort { |a, b| happinesses[a] <=> happinesses[b] }
    pairings = []
    while not pick_order.empty?
      person = pick_order.shift
      best_pairing = make_best_pairing(person, pick_order, week)
      if best_pairing
        pick_order.delete(best_pairing.second_person)
        pairings.push best_pairing
      end
    end
    pairings
  end

  def PairingMaker.make_best_pairing(person, remaining, week)
    best_pairing = nil
    best_pairing_happiness = 0
    remaining.each do |candidate|
      next if (person.teams & candidate.teams).empty?
      pairing = Pairing.new(first_person: person, second_person: candidate, week: week)
      happiness = pairing_happiness(pairing)
      if happiness > best_pairing_happiness
        best_pairing = pairing
        best_pairing_happiness = happiness
      end
    end
    return best_pairing
  end

  def PairingMaker.compute_week
    newest = Pairing.order("week DESC").first
    (newest and newest.week) ? newest.week + 1 : 0
  end

  def PairingMaker.compute_happinesses(week)
    happinesses = {}
    Person.all.each { |person| happinesses[person] = compute_happiness(person, week) }
    happinesses
  end

  # Happiness is a nonegative value. It is the sum of how happy
  # each of their last 10 pairings made them, weighted by recentness.
  # E.g. their most recent pairing is worth 10*happiness, next is
  # 9*happiness, etc.
  def PairingMaker.compute_happiness(person, week)
    last_pairings = Pairing.where("(first_person_id = ? OR second_person_id = ?) AND week >= ?", person, person, week - 10).order("week DESC").first(10)
    happiness = 0
    last_pairings.each_with_index do |pairing, index|
      happiness += pairing_happiness(pairing) * (11 + pairing.week - week)
    end
    happiness
  end

  # A pairing's happiness is a integer from 1-10 which is the number
  # of weeks since this pairing was last made (capped at 10)
  def PairingMaker.pairing_happiness(pairing)
    previous_pairing = Pairing.where("((first_person_id = ? AND second_person_id = ?)
                                       OR (first_person_id = ? AND second_person_id = ?))
                                      AND week < ?",
                                      pairing.first_person,
                                      pairing.second_person,
                                      pairing.second_person,
                                      pairing.first_person,
                                      pairing.week).first
    return 10 unless previous_pairing
    diff = pairing.week - previous_pairing.week
    diff = 10 if diff > 10
    diff
  end
end
