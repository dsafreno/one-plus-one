class PersonMailer < ActionMailer::Base
  default from: "pairingmaker@oneplusoneifttt.com"

  def pairing_email(to_person, paired_person)
    @paired_person = paired_person
    mail(to: to_person.email, subject: "1+1 with #{@paired_person.name}")
  end
end

