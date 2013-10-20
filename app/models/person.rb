class Person < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_many :pairings

  validates :name, presence: true
  validates :email, presence: true

  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
end
