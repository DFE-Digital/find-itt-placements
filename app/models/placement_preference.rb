class PlacementPreference < ApplicationRecord
  belongs_to :academic_year
  belongs_to :organisation
  belongs_to :created_by, class_name: "User", foreign_key: :created_by_id

  enum :appetite,
       {
         actively_looking: "actively_looking",
         interested: "interested",
         not_open: "not_open"
       },
       validate: true

  scope :for_academic_year, ->(academic_year) { where(academic_year:) }
end
