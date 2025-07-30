class PlacementSubject < ApplicationRecord
  belongs_to :parent_subject, class_name: "PlacementSubject", optional: true

  has_many :child_subjects, class_name: "PlacementSubject", foreign_key: :parent_subject_id, dependent: :destroy

  validates :name, presence: true
  validates :code, presence: true

  enum :phase,
       { primary: "primary", secondary: "secondary" },
       validate: true

  STEM_SUBJECTS = [
    "Biology",
    "Chemistry",
    "Computing",
    "Design and technology",
    "Mathematics",
    "Physics",
    "Science" # TODO: Category unsure
  ].freeze
  LIT_LANG_SUBJECTS = [
    "English",
    "Modern Languages",
    "Latin" # TODO: Category unsure
  ].freeze
  ART_HUMANITIES_SOCIAL_SUBJECTS = [
    "Ancient Greek", # TODO: Category unsure
    "Ancient Hebrew", # TODO: Category unsure
    "Art and design",
    "Business studies",
    "Citizenship",
    "Classics",
    "Communication and media studies",
    "Dance",
    "Drama",
    "Economics",
    "Geography",
    "History",
    "Music",
    "Philosophy",
    "Psychology",
    "Religious education",
    "Social sciences"
  ].freeze
  HEALTH_PHYSICAL_EDUCATION_SUBJECTS = [
    "Health and social care",
    "Physical education",
    "Physical education with an EBacc subject" # TODO: Category unsure
  ].freeze

  scope :order_by_name, -> { order(:name) }
  scope :parent_subjects, -> { where(parent_subject_id: nil).order_by_name }
  scope :stem_subjects, -> { where(name: STEM_SUBJECTS) }
  scope :lit_lang_subjects, -> { where(name: LIT_LANG_SUBJECTS) }
  scope :art_humanities_social_subjects, -> { where(name: ART_HUMANITIES_SOCIAL_SUBJECTS) }
  scope :health_physical_education_subjects, -> { where(name: HEALTH_PHYSICAL_EDUCATION_SUBJECTS) }

  def has_child_subjects?
    child_subjects.exists?
  end
end
