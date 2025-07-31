class AddHostingInterestWizard::Interested::SecondaryChildSubjectSelectionStep < AddHostingInterestWizard::SecondaryChildSubjectSelectionStep
  def unknown_option
    @unknown_option ||=
      OpenStruct.new(
        value: AddHostingInterestWizard::UNKNOWN_OPTION,
        name: I18n.t(
          "#{unknown_option_locale_path}.unknown",
        ),
      )
  end

  private

  def unknown_option_locale_path
    ".wizards.add_hosting_interest_wizard.interested.secondary_child_subject_selection_step.options"
  end
end
