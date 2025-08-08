class AddHostingInterestWizard < BaseWizard
  include PlacementPreferenceCreatable

  attr_reader :school, :current_user

  delegate :school_contact, to: :school

  UNKNOWN_OPTION = "unknown".freeze

  def initialize(current_user:, school:, params:, state:, current_step: nil)
    @school = school
    @current_user = current_user
    super(state:, params:, current_step:)
  end

  def define_steps
    # Define the wizard steps here
    add_step(AppetiteStep)
    case appetite
    when "actively_looking"
      actively_looking_steps
    when "not_open"
      not_open_steps
    when "interested"
      interested_steps
    end
  end

  def add_placement_preference
    raise "Invalid wizard state" unless valid?

    ApplicationRecord.transaction do
      placement_preference.appetite = appetite
      placement_preference.placement_details = state

      placement_preference.save!
    end
    placement_preference
  end

  def selected_secondary_subjects
    return [ UNKNOWN_OPTION ] if selected_secondary_subject_ids.include?(UNKNOWN_OPTION)

    super
  end

  def academic_year
    @academic_year ||= AcademicYear.next
  end

  private

  def actively_looking_steps
    add_placement_creation_steps(with_check_your_answers: false)
    add_step(SchoolContactStep)
    add_step(CheckYourAnswersStep)
  end

  def interested_steps
    add_step(Interested::PhaseStep)
    if primary_phase?
      year_group_steps
    end

    if secondary_phase?
      secondary_subject_steps
    end

    if send_specific?
      send_steps
    end

    add_step(NoteToProvidersStep)
    add_step(SchoolContactStep)
    add_step(ConfirmStep)
  end

  def not_open_steps
    add_step(ReasonNotHostingStep)
    add_step(NotOpen::SchoolContactStep)
    add_step(AreYouSureStep)
  end

  def year_group_steps
    if appetite_interested?
      add_step(Interested::YearGroupSelectionStep)
    else
      super
    end
  end

  def secondary_subject_steps
    if appetite_interested?
      add_step(Interested::SecondarySubjectSelectionStep)
      child_subject_steps(step_prefix: Interested)
    else
      super
    end
  end

  def send_steps
    if appetite_interested?
      add_step(Interested::KeyStageSelectionStep)
    else
      super
    end
  end

  def child_subject_steps(step_prefix: AddHostingInterestWizard)
    return if selected_secondary_subjects == [ UNKNOWN_OPTION ]

    super(step_prefix:)
  end

  def wizard_school_contact
    @wizard_school_contact = steps[:school_contact].school_contact
  end

  def appetite
    @appetite ||= steps.fetch(:appetite).appetite
  end

  def reasons_not_hosting
    @reasons_not_hosting ||= steps.fetch(:reason_not_hosting).reasons_not_hosting
  end

  def placement_preference
    @placement_preference ||= begin
      upcoming_interest = school.placement_preferences.for_academic_year(academic_year).last
      upcoming_interest.presence || school.placement_preferences.build(academic_year: academic_year, created_by: current_user)
    end
  end

  def value_unknown(value)
    value.include?(UNKNOWN_OPTION)
  end

  def save_potential_placements_information
    potential_placement_details = {}
    potential_placement_details[:phase] = {
      phases: steps.fetch(:phase).phases
    }

    potential_placement_details = potential_placement_details
      .merge(placements_information)

    potential_placement_details[:note_to_providers] = {
      note: steps.fetch(:note_to_providers).note
    }

    @school.update!(potential_placement_details:)
  end

  def appetite_interested?
    @appetite_interested ||= appetite == "interested"
  end
end
