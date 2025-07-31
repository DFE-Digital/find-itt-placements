class AddHostingInterestWizard::KeyStageSelectionStep < BaseStep
  attribute :key_stages, default: []

  validates :key_stages, presence: true

  def key_stages_for_selection
    key_stage_as_options
      .reject { |option| option.value == "mixed_key_stages" }
  end

  def mixed_key_stage_option
    key_stage_as_options
      .find { |option| option.value == "mixed_key_stages" }
  end

  def key_stages=(value)
    super normalised_key_stages(value)
  end

  private

  def key_stage_options
    @key_stage_options ||= [
      "early_years",
      "key_stage_1",
      "key_stage_2",
      "key_stage_3",
      "key_stage_4",
      "key_stage_5",
      "mixed_key_stages"
    ]
  end

  def key_stage_as_options
    @key_stage_as_options ||= key_stage_options.map do |value|
      OpenStruct.new(
        value:,
        name: I18n.t(".wizards.add_hosting_interest_wizard.key_stage_selection_step.key_stages.#{value}"),
      )
    end
  end

  def normalised_key_stages(selected_key_stages)
    return [] if selected_key_stages.blank?

    selected_key_stages.reject(&:blank?)
  end
end
