class AddHostingInterestWizard::SchoolContactStep < BaseStep
  attribute :first_name
  attribute :last_name
  attribute :email_address

  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  delegate :school, to: :wizard
end
