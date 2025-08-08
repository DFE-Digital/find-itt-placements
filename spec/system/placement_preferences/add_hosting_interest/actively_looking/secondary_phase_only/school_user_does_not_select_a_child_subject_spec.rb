require "rails_helper"

RSpec.describe "School user successfully adds their hosting interest, including a child subject", type: :system do
  scenario do
    given_i_am_signed_in
    and_academic_years_exist
    and_secondary_subjects_exist
    when_i_visit_the_new_placement_preferences_url
    then_i_see_the_appetite_form_page

    when_i_select_yes
    and_i_click_on_continue
    then_i_see_the_education_phase_form_page

    when_i_select_secondary
    and_i_click_on_continue
    then_i_see_the_secondary_subject_selection_form_page

    when_i_select_modern_languages
    and_i_click_on_continue
    then_i_see_the_secondary_child_subject_selection_form_page

    when_i_click_on_continue
    then_i_see_a_validation_error_for_selecting_a_subject
  end

  private

  def given_i_am_signed_in
    @school = build(:school, name: "Hogwarts")
    sign_in_user(organisations: [ @school ])
  end

  def and_academic_years_exist
    @next_academic_year = create(:academic_year, :next)
    @next_academic_year_name = @next_academic_year.name
  end

  def and_secondary_subjects_exist
    @english = create(:placement_subject, :secondary, name: "English")
    @science = create(:placement_subject, :secondary, name: "Science")
    @mathematics = create(:placement_subject, :secondary, name: "Mathematics")
    @modern_languages = create(:placement_subject, :secondary, name: "Modern Languages")
    @french = create(:placement_subject, :secondary, name: "French", parent_subject: @modern_languages)
    @spanish = create(:placement_subject, :secondary, name: "Spanish", parent_subject: @modern_languages)
    @russian = create(:placement_subject, :secondary, name: "Russian", parent_subject: @modern_languages)
  end

  def when_i_visit_the_new_placement_preferences_url
    visit new_add_hosting_interest_placement_preferences_path
  end

  def then_i_see_the_appetite_form_page
    expect(page).to have_title(
      "Can your school offer placements for trainee teachers in the academic year #{@next_academic_year_name}? - Find ITT placements",
    )
    expect(page).to have_caption("Placement preferences")
    expect(page).to have_element(
      :legend,
      text: "Can your school offer placements for trainee teachers in the academic year #{@next_academic_year_name}?",
      class: "govuk-fieldset__legend",
    )
    expect(page).to have_field("Yes - I can offer placements", type: :radio)
    expect(page).to have_field("Maybe - I’m not sure yet", type: :radio)
    expect(page).to have_field("No - I can’t offer placements", type: :radio)
  end

  def when_i_select_yes
    choose "Yes - I can offer placements"
  end

  def when_i_click_on_continue
    click_on "Continue"
  end
  alias_method :and_i_click_on_continue,
               :when_i_click_on_continue

  def then_i_see_the_education_phase_form_page
    expect(page).to have_title(
      "What education phase can your placements be? - Find ITT placements",
    )
    expect(page).to have_caption("Placement details")
    expect(page).to have_element(
      :legend,
      text: "What education phase can your placements be?",
      class: "govuk-fieldset__legend",
    )
    expect(page).to have_hint("Select all that apply")
    expect(page).to have_field("Primary", type: :checkbox)
    expect(page).to have_field("Secondary", type: :checkbox)
    expect(page).to have_field(
      "Special educational needs and disabilities (SEND) specific",
      type: :checkbox,
    )
  end

  def when_i_select_secondary
    check "Secondary"
  end

  def then_i_see_the_secondary_subject_selection_form_page
    expect(page).to have_title(
      "What secondary school subjects can you offer placements in? - Find ITT placements",
    )
    expect(page).to have_element(
      :legend,
      text: "What secondary school subjects can you offer placements in?",
      class: "govuk-fieldset__legend",
    )
    expect(page).to have_caption("Secondary placement details")
    expect(page).to have_field("English", type: :checkbox)
    expect(page).to have_field("Mathematics", type: :checkbox)
    expect(page).to have_field("Science", type: :checkbox)
    expect(page).to have_field("Modern Languages", type: :checkbox)

    expect(page).not_to have_field("French", type: :checkbox)
    expect(page).not_to have_field("Spanish", type: :checkbox)
    expect(page).not_to have_field("Russian", type: :checkbox)
  end

  def when_i_select_modern_languages
    check "Modern Languages"
  end

  def then_i_see_the_secondary_child_subject_selection_form_page
    expect(page).to have_title(
      "What languages are taught on your Modern Languages placement offers? - Find ITT placements",
    )
    expect(page).to have_element(
      :legend,
      text: "What languages are taught on your Modern Languages placement offers?",
      class: "govuk-fieldset__legend",
    )
    expect(page).to have_caption("Secondary placement details")
    expect(page).not_to have_field("English", type: :checkbox)
    expect(page).not_to have_field("Mathematics", type: :checkbox)
    expect(page).not_to have_field("Science", type: :checkbox)
    expect(page).not_to have_field("Modern Languages", type: :checkbox)

    expect(page).to have_field("French", type: :checkbox)
    expect(page).to have_field("Spanish", type: :checkbox)
    expect(page).to have_field("Russian", type: :checkbox)
  end

  def then_i_see_a_validation_error_for_selecting_a_subject
    expect(page).to have_validation_error(
      "Please select a subject",
    )
  end
end
