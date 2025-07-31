class AddHostingInterestWizard::Interested::PhaseStep < AddHostingInterestWizard::PhaseStep
  def unknown_option
    @unknown_option ||=
      OpenStruct.new(
        value: AddHostingInterestWizard::UNKNOWN_OPTION,
        name: I18n.t(
          "#{unknown_option_locale_path}.unknown",
        ),
        description: I18n.t(
          "#{unknown_option_locale_path}.unknown_description",
        ),
      )
  end

  private

  def unknown_option_locale_path
    ".wizards.add_hosting_interest_wizard.interested.phase_step.options"
  end
end
