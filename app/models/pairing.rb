class Pairing < ActiveRecord::Base
  belongs_to :first_person, :class_name => 'Person'
  belongs_to :second_person, :class_name => 'Person'
end
