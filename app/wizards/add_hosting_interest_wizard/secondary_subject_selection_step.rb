class AddHostingInterestWizard::SecondarySubjectSelectionStep < BaseStep
  delegate :stem_subjects, :lit_lang_subjects,
           :art_humanities_social_subjects, :health_physical_education_subjects,
           to: :subjects_for_selection

  attribute :subject_ids, default: []

  validates :subject_ids, presence: true

  def subjects_for_selection
    @subjects_for_selection ||= PlacementSubject.parent_subjects.secondary
  end

  def subject_ids=(value)
    super normalised_subject_ids(value)
  end

  private

  def normalised_subject_ids(selected_ids)
    return [] if selected_ids.blank?

    selected_ids.reject(&:blank?)
  end
end
