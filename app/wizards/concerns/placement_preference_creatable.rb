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

  def placement_quantity_for_subject(subject)
    return 0 if steps[:secondary_placement_quantity].blank?

    steps.fetch(:secondary_placement_quantity).try(subject.name_as_attribute).to_i
  end

  def placement_quantity_for_year_group(year_group)
    return 0 if steps[:year_group_placement_quantity].blank?

    steps.fetch(:year_group_placement_quantity).try(year_group.to_sym).to_i
  end

  def placement_quantity_for_key_stage(key_stage)
    return 0 if steps[:key_stage_placement_quantity].blank?

    steps.fetch(:key_stage_placement_quantity).try(key_stage.name_as_attribute).to_i
  end

  def child_subject_placement_step_count
    steps.values.select { |step|
      step.is_a?(::Placements::MultiPlacementWizard::SecondaryChildSubjectPlacementSelectionStep)
    }.count
  end

  def academic_year
    raise NoMethodError, "#academic_year must be implemented"
  end

  def current_user
    raise NoMethodError, "#current_user must be implemented"
  end

  def placements_information
    primary_placement_information.merge(
      secondary_placement_information.merge(
        send_placement_information,
      ),
    )
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

  def step_name_for_child_subjects(subject:, selection_number:)
    step_name(
      ::Placements::MultiPlacementWizard::SecondaryChildSubjectPlacementSelectionStep,
      "#{subject.name_as_attribute}_#{selection_number}",
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
