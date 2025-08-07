class School < Organisation
  attribute :transit_travel_duration
  attribute :walk_travel_duration
  attribute :drive_travel_duration

  validates :urn, presence: true, uniqueness: true

  has_many :placement_preferences, foreign_key: :organisation_id

  def current_hosting_interest(academic_year:)
    placement_preferences
      .where(academic_year:)
      .order(created_at: :desc)
      .first
  end
end
