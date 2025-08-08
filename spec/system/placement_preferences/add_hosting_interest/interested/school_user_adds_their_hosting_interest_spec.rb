require "rails_helper"

RSpec.describe "School user successfully adds their hosting interest", type: :system do
  scenario do
    given_i_am_signed_in
    and_academic_years_exist
    and_secondary_subjects_exist
    when_i_visit_the_new_placement_preferences_url
    then_i_see_the_appetite_form_page

    when_i_select_maybe
    and_i_click_on_continue
    then_i_see_the_education_phase_form_page

    when_i_select_primary
    and_i_select_secondary
    and_i_select_send
    and_i_click_on_continue
    then_i_see_the_year_group_selection_form_page

    when_i_select_i_do_not_know
    and_i_click_on_continue
    then_i_see_the_secondary_subject_selection_form_page

    when_i_select_i_do_not_know
    and_i_click_on_continue
    then_i_see_the_key_stage_selection_form_page

    when_i_select_i_do_not_know
    and_i_click_on_continue
    then_i_see_the_note_to_providers_form_page

    when_i_enter_a_note_to_providers
    and_i_click_on_continue
    then_i_see_the_school_contact_form_page

    when_i_fill_in_the_school_contact_details
    and_i_click_on_continue
    then_i_see_the_confirmation_page

    when_i_click_on_back
    then_i_see_the_school_contact_form_page
    and_i_see_the_school_contact_inputs_prefilled

    when_i_click_on_back
    then_i_see_the_note_to_providers_form_page
    and_i_see_the_note_i_entered_prefilled

    when_i_click_on_back
    then_i_see_the_key_stage_selection_form_page
    and_i_see_i_do_not_know_selected

    when_i_click_on_back
    then_i_see_the_secondary_subject_selection_form_page
    and_i_see_i_do_not_know_selected

    when_i_click_on_back
    then_i_see_the_year_group_selection_form_page
    and_i_see_i_do_not_know_selected

    when_i_click_on_back
    then_i_see_the_education_phase_form_page
    and_i_see_primary_selected
    and_i_see_secondary_selected
    and_i_see_send_selected

    when_i_click_on_continue
    then_i_see_the_year_group_selection_form_page
    and_i_see_i_do_not_know_selected

    when_i_click_on_continue
    then_i_see_the_secondary_subject_selection_form_page
    and_i_see_i_do_not_know_selected

    when_i_click_on_continue
    then_i_see_the_key_stage_selection_form_page
    and_i_see_i_do_not_know_selected

    when_i_click_on_continue
    then_i_see_the_note_to_providers_form_page
    and_i_see_the_note_i_entered_prefilled

    when_i_click_on_continue
    then_i_see_the_school_contact_form_page
    and_i_see_the_school_contact_inputs_prefilled

    when_i_click_on_continue
    then_i_see_the_confirmation_page

    when_i_click_on_change_message_to_providers
    then_i_see_the_note_to_providers_form_page
    and_i_see_the_note_i_entered_prefilled

    when_i_click_on_continue
    then_i_see_the_school_contact_form_page
    and_i_see_the_school_contact_inputs_prefilled

    when_i_click_on_continue
    then_i_see_the_confirmation_page

    when_i_click_on_confirm
    then_i_see_the_my_placement_preferences
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

  def when_i_select_maybe
    choose "Maybe - I’m not sure yet"
  end

  def when_i_click_on_continue
    click_on "Continue"
  end
  alias_method :and_i_click_on_continue,
               :when_i_click_on_continue

  def then_i_see_the_education_phase_form_page
    expect(page).to have_title(
      "What education phase could you offer placements in? - Find ITT placements",
    )
    expect(page).to have_caption("Potential placement offer details")
    expect(page).to have_element(
      :legend,
      text: "What education phase could you offer placements in?",
      class: "govuk-fieldset__legend",
    )
    expect(page).to have_hint("Select all that apply")
    expect(page).to have_field("Primary", type: :checkbox)
    expect(page).to have_field("Secondary", type: :checkbox)
    expect(page).to have_field(
      "Special educational needs and disabilities (SEND) specific",
      type: :checkbox,
    )
    expect(page).to have_field("I don’t know", type: :checkbox)
  end

  def when_i_select_primary
    check "Primary"
  end

  def and_i_select_secondary
    check "Secondary"
  end

  def and_i_select_send
    check "Special educational needs and disabilities (SEND) specific"
  end

  def then_i_see_the_year_group_selection_form_page
    expect(page).to have_title(
      "What year groups could you offer placements in? - Find ITT placements",
    )
    expect(page).to have_element(
      :legend,
      text: "What year groups could you offer placements in?",
      class: "govuk-fieldset__legend",
    )
    expect(page).to have_caption("Potential primary placement details")
    expect(page).to have_field("Nursery", type: :checkbox)
    expect(page).to have_field("Reception", type: :checkbox)
    expect(page).to have_field("Year 1", type: :checkbox)
    expect(page).to have_field("Year 2", type: :checkbox)
    expect(page).to have_field("Year 3", type: :checkbox)
    expect(page).to have_field("Year 4", type: :checkbox)
    expect(page).to have_field("Year 5", type: :checkbox)
    expect(page).to have_field("Year 6", type: :checkbox)
    expect(page).to have_field("Mixed year groups", type: :checkbox)
    expect(page).to have_field("I don’t know", type: :checkbox)
  end

  def when_i_select_i_do_not_know
    check "I don’t know"
  end

  def then_i_see_the_secondary_subject_selection_form_page
    expect(page).to have_title(
      "What subjects could you offer placements in? - Find ITT placements",
    )
    expect(page).to have_element(
      :legend,
      text: "What subjects could you offer placements in?",
      class: "govuk-fieldset__legend",
    )
    expect(page).to have_caption("Potential secondary placement details")
    expect(page).to have_field("English", type: :checkbox)
    expect(page).to have_field("Mathematics", type: :checkbox)
    expect(page).to have_field("Science", type: :checkbox)
    expect(page).to have_field("I don’t know", type: :checkbox)
  end

  def then_i_see_the_key_stage_selection_form_page
     expect(page).to have_title(
      "What key stages could you offer SEND placements in? - Find ITT placements",
    )
    expect(page).to have_caption("Potential SEND placement details")
    expect(page).to have_element(
      :legend,
      text: "What key stages could you offer SEND placements in?",
      class: "govuk-fieldset__legend",
    )
    expect(page).to have_field("Early year", type: :checkbox)
    expect(page).to have_field("Key stage 1", type: :checkbox)
    expect(page).to have_field("Key stage 2", type: :checkbox)
    expect(page).to have_field("Key stage 3", type: :checkbox)
    expect(page).to have_field("Key stage 4", type: :checkbox)
    expect(page).to have_field("Key stage 5", type: :checkbox)
    expect(page).to have_field("Mixed key stages", type: :checkbox)
    expect(page).to have_field("I don’t know", type: :checkbox)
  end

  def then_i_see_the_note_to_providers_form_page
    expect(page).to have_title(
      "Is there anything about your school you would like providers to know? (optional) - Find ITT placements",
    )
    expect(page).to have_caption("Potential placement details")
    expect(page).to have_element(
      :label,
      text: "Is there anything about your school you would like providers to know? (optional)",
    )
    expect(page).to have_field("Is there anything about your school you would like providers to know? (optional)")
  end

  def when_i_enter_a_note_to_providers
    fill_in "Is there anything about your school you would like providers to know? (optional)", with:
      "We are open to hosting additional placements at the provider's request."
  end

  def then_i_see_the_school_contact_form_page
    expect(page).to have_title(
      "Who should providers contact? - Find ITT placements",
    )
    expect(page).to have_caption("Contact details")
    expect(page).to have_h1("Who should providers contact?")
    expect(page).to have_paragraph(
      "Choose the person best placed to organise placements for trainee teachers at your school",
    )
    expect(page).to have_field("First name")
    expect(page).to have_field("Last name")
    expect(page).to have_field("Email address")
  end

  def when_i_fill_in_the_school_contact_details
    fill_in "First name", with: "Joe"
    fill_in "Last name", with: "Bloggs"
    fill_in "Email address", with: "joe_bloggs@example.com"
  end

  def then_i_see_the_confirmation_page
    expect(page).to have_title(
      "Confirm and share what you may be able to offer - Find ITT placements",
    )
    expect(page).to have_h1("Confirm and share what you may be able to offer")

    expect(page).to have_h2("Your information")
    expect(page).to have_summary_list_row("First name", "Joe")
    expect(page).to have_summary_list_row("Last name", "Bloggs")
    expect(page).to have_summary_list_row("Email address", "joe_bloggs@example.com")

     expect(page).to have_h2("Potential education phase")
    expect(page).to have_summary_list_row("Phase", "Primary Secondary Send")

    expect(page).to have_h2("Potential primary placements")
    expect(page).to have_summary_list_row("Year group", "I don’t know")

    expect(page).to have_h2("Potential secondary placements")
    expect(page).to have_summary_list_row("Subject", "I don’t know")

    expect(page).to have_h2("Potential SEND placements")
    expect(page).to have_summary_list_row("Key stage", "I don’t know")

    expect(page).to have_h2("Additional information")
    expect(page).to have_summary_list_row(
      "Message to providers",
      "We are open to hosting additional placements at the provider's request.",
    )
  end

  def when_i_click_on_back
    click_on "Back"
  end

  def and_i_see_the_school_contact_inputs_prefilled
    expect(page).to have_field("First name", with: "Joe")
    expect(page).to have_field("Last name", with: "Bloggs")
    expect(page).to have_field("Email address", with: "joe_bloggs@example.com")
  end

  def and_i_see_the_note_i_entered_prefilled
    expect(page).to have_field(
      "Is there anything about your school you would like providers to know? (optional)",
       with: "We are open to hosting additional placements at the provider's request.",
      )
  end

  def and_i_see_i_do_not_know_selected
    expect(page).to have_checked_field("I don’t know", type: :checkbox)
  end

  def and_i_see_primary_selected
    expect(page).to have_checked_field("Primary", type: :checkbox)
  end

  def and_i_see_secondary_selected
    expect(page).to have_checked_field("Secondary", type: :checkbox)
  end

  def and_i_see_send_selected
    expect(page).to have_checked_field(
      "Special educational needs and disabilities (SEND) specific",
      type: :checkbox,
    )
  end

  def when_i_click_on_change_message_to_providers
    click_on "Change Message to providers"
  end

  def when_i_click_on_confirm
    click_on "Confirm"
  end

  def then_i_see_the_my_placement_preferences
    expect(page).to have_title(
      "What happens next? - Find ITT placements",
    )
    expect(page).to have_h1("What happens next?")
    expect(page).to have_paragraph(
      "Providers who are looking for schools to work with can contact you on joe_bloggs@example.com.",
    )
    expect(page).to have_paragraph(
      "You do not need to take any further action until providers contact you.",
    )

    expect(page).to have_h3("Potential primary school placements")
    expect(page).to have_summary_list_row("Year group", "Year 1")

    expect(page).to have_h3("Potential secondary school placements")
    expect(page).to have_summary_list_row("Subject", "English")

    expect(page).to have_h3("Potential SEND placements")
    expect(page).to have_summary_list_row("Key stage", "Key stage 2")
  end
end
