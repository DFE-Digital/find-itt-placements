class AddHostingInterestWizard::PhaseStep < BaseStep
  attribute :phases, default: []

  validates :phases, presence: true

  PRIMARY_PHASE = "primary".freeze
  SECONDARY_PHASE = "secondary".freeze
  SEND = "send".freeze

  def phase_options
    [ PRIMARY_PHASE, SECONDARY_PHASE, SEND ]
  end

  def phases_for_selection
    phase_options.map do |phase|
      OpenStruct.new(
        name: phase.titleize,
        value: phase,
        description: I18n.t("#{locale_path}.options.#{phase}_description"),
      )
    end
  end

  def phases=(value)
    super normalised_phases(value)
  end

  private

  def normalised_phases(selected_phases)
    return [] if selected_phases.blank?

    selected_phases.reject(&:blank?)
  end

  def locale_path
    ".wizards.add_hosting_interest_wizard.phase_step"
  end
end
