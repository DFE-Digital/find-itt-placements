module PlacementPreferenceCreatable
  extend ActiveSupport::Concern

  def add_placement_creation_steps(with_check_your_answers: true)
    add_step(AddHostingInterestWizard::PhaseStep)
    if primary_phase?
      year_group_steps
    end

    if secondary_phase?
      secondary_subject_steps
    end

    if send_specific?
      send_steps
    end
    return unless with_check_your_answers

    add_step(AddHostingInterestWizard::CheckYourAnswersStep)
  end

  def year_groups
    return [] if steps[:year_group_selection].blank?

    @year_groups ||= steps.fetch(:year_group_selection).year_groups
  end

  def selected_secondary_subjects
    @selected_secondary_subjects ||= PlacementSubject.secondary.where(
      id: selected_secondary_subject_ids,
    ).order_by_name
  end

  def key_stages
    return [] if steps[:key_stage_selection].blank?

    @key_stages ||= steps.fetch(:key_stage_selection).key_stages
  end

  def academic_year
    raise NoMethodError, "#academic_year must be implemented"
  end

  def current_user
    raise NoMethodError, "#current_user must be implemented"
  end

  def child_subject_names(subject:)
    return [] unless subject.has_child_subjects? && steps[step_name_for_child_subjects(subject:)].present?

    PlacementSubject.where(id: steps[step_name_for_child_subjects(subject:)].child_subject_ids).order_by_name.pluck(:name)
  end

  private

  def year_group_steps
    add_step(AddHostingInterestWizard::YearGroupSelectionStep)
  end

  def selected_secondary_subject_ids
    return [] if steps[:secondary_subject_selection].blank?

    steps.fetch(:secondary_subject_selection).subject_ids
  end

  def secondary_subject_steps
    add_step(AddHostingInterestWizard::SecondarySubjectSelectionStep)
    child_subject_steps
  end

  def child_subject_steps(step_prefix: AddHostingInterestWizard)
    if selected_secondary_subjects.any?(&:has_child_subjects?)
      selected_secondary_subjects.each do |subject|
        next unless subject.has_child_subjects?

        add_step(step_prefix::SecondaryChildSubjectSelectionStep,
                  {
                    selection_id: subject.id,
                    selection_number: subject.id,
                    parent_subject_id: subject.id

                  },
                  :selection_id)
      end
    end
  end

  def send_steps
    add_step(AddHostingInterestWizard::KeyStageSelectionStep)
  end

  def step_name_for_child_subjects(subject:)
    step_name(
      AddHostingInterestWizard::SecondaryChildSubjectSelectionStep,
      subject.id,
    )
  end

  def phases
    @phases = steps.fetch(:phase).phases
  end

  def primary_phase?
    phases.include?(AddHostingInterestWizard::PhaseStep::PRIMARY_PHASE)
  end

  def secondary_phase?
    phases.include?(AddHostingInterestWizard::PhaseStep::SECONDARY_PHASE)
  end

  def send_specific?
    phases.include?(AddHostingInterestWizard::PhaseStep::SEND)
  end
end
