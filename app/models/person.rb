class Person < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_many :pairings

  before_validation :downcase_email
  before_validation :titelize_name
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  private
  def downcase_email
    self.email = self.email.downcase
  end
  def titelize_name
    self.name = self.name.titleize
  end
end
