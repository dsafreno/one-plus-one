class Pairing < ActiveRecord::Base
  belongs_to :first_person, :class_name => 'Person'
  belongs_to :second_person, :class_name => 'Person'

  validates :first_person_id, presence: true
  validates :second_person_id, presence: true
  validates :week, presence: true
  validate :people_not_in_existing_pairs_this_week

  def people_not_in_existing_pairs_this_week
    ids = [first_person_id, second_person_id]
    first_conflicts = Pairing.find_by('week = ? AND first_person_id IN (?)', week, ids)
    if first_conflicts != nil
      errors.add(:first_person, "already paired for specified week")
    end
    second_conflicts = Pairing.find_by('week = ? AND second_person_id IN (?)', week, ids)
    if second_conflicts != nil
      errors.add(:second_person, "already paired for specified week")
    end
  end
end
