require "rails_helper"

RSpec.describe "School user successfully adds their hosting interest", type: :system do
  scenario do
    given_i_am_signed_in
    and_academic_years_exist
    when_i_visit_the_new_placement_preferences_url
    then_i_see_the_appetite_form_page

    when_i_select_no
    and_i_click_on_continue
    then_i_see_the_reason_for_not_hosting_form_page

    when_i_select_no_mentors_available_due_to_capacity
    and_i_select_other
    and_i_enter_another_reason
    and_i_click_on_continue
    then_i_see_the_school_contact_form_page

    when_i_fill_in_the_school_contact_details
    and_i_click_on_continue
    then_i_see_the_are_you_sure_page
    and_i_see_the_reason_not_hosting_i_entered
    and_i_see_the_entered_school_contact_details

    when_i_click_on_back
    then_i_see_the_school_contact_form_page
    and_i_see_the_school_contact_inputs_prefilled

    when_i_click_on_back
    then_i_see_the_reason_for_not_hosting_form_page
    and_i_see_no_mentors_available_due_to_capacity_selected
    and_i_see_other_selected

    when_i_click_on_back
    then_i_see_the_appetite_form_page
    and_i_see_no_selected

    when_i_click_on_continue
    then_i_see_the_reason_for_not_hosting_form_page
    and_i_see_no_mentors_available_due_to_capacity_selected
    and_i_see_other_selected

    when_i_click_on_continue
    then_i_see_the_school_contact_form_page
    and_i_see_the_school_contact_inputs_prefilled

    when_i_click_on_continue
    then_i_see_the_are_you_sure_page
    and_i_see_the_reason_not_hosting_i_entered
    and_i_see_the_entered_school_contact_details

    when_i_click_on_change_email_address
    then_i_see_the_school_contact_form_page
    and_i_see_the_school_contact_inputs_prefilled

    when_i_click_on_continue
    then_i_see_the_are_you_sure_page
    and_i_see_the_entered_school_contact_details

    when_i_click_on_change_reason_for_not_offering
    then_i_see_the_reason_for_not_hosting_form_page
    and_i_see_no_mentors_available_due_to_capacity_selected
    and_i_see_other_selected

    when_i_click_on_continue
    then_i_see_the_school_contact_form_page
    and_i_see_the_school_contact_inputs_prefilled

    when_i_click_on_continue
    then_i_see_the_are_you_sure_page
    and_i_see_the_reason_not_hosting_i_entered
    and_i_see_the_entered_school_contact_details

    when_i_click_on_continue
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

  def when_i_select_no
    choose "No - I can’t offer placements"
  end

  def when_i_click_on_continue
    click_on "Continue"
  end
  alias_method :and_i_click_on_continue,
               :when_i_click_on_continue

  def then_i_see_the_reason_for_not_hosting_form_page
    expect(page).to have_title(
      "Tell us why you are not able to offer placements for trainee teachers - Find ITT placements",
    )
    expect(page).to have_caption("Not offering placements this year")
    expect(page).to have_element(
      :legend,
      text: "Tell us why you are not able to offer placements for trainee teachers",
      class: "govuk-fieldset__legend",
    )
    expect(page).to have_field("Trainees we were offered did not meet our expectations", type: :checkbox)
    expect(page).to have_field("High number of pupils with SEND needs", type: :checkbox)
    expect(page).to have_field("Low capacity to support trainees due to staff changes", type: :checkbox)
    expect(page).to have_field("No mentors available due to capacity", type: :checkbox)
    expect(page).to have_field("Unsure how to get involved", type: :checkbox)
    expect(page).to have_field("Working to improve our OFSTED rating", type: :checkbox)
    expect(page).to have_field("Other", type: :checkbox)
  end

  def when_i_select_no_mentors_available_due_to_capacity
    check "No mentors available due to capacity"
  end

  def and_i_select_other
    check "Other"
  end

  def and_i_enter_another_reason
    fill_in "Tell us your reason", with: "Some other reason"
  end

  def then_i_see_the_school_contact_form_page
    expect(page).to have_title(
      "Who is the preferred contact for next year? - Find ITT placements",
    )
    expect(page).to have_caption("Not offering placements this year")
    expect(page).to have_h1("Who is the preferred contact for next year?")
    expect(page).to have_paragraph(
      "We will ask in the next academic year whether you are able to offer placements for trainee teachers.",
    )
    expect(page).to have_paragraph(
      "Choose the person best placed to organise placements for trainee teachers at your school.",
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

  def then_i_see_the_are_you_sure_page
    expect(page).to have_title(
      "Confirm and let providers know you are not offering placements - Find ITT placements",
    )
    expect(page).to have_caption("Not offering placements this year")
    expect(page).to have_h1(
      "Confirm and let providers know you are not offering placements",
    )
    expect(page).to have_paragraph(
      "We will ask in the next academic year whether you are able to offer placements for trainee teachers.",
    )
    expect(page).to have_paragraph("No information will be shared with providers.")
    expect(page).to have_paragraph(
      "Your reason for not offering placements be shared with the Department for Education to help understand teacher training and recruitment.",
    )
  end

  def and_i_see_the_reason_not_hosting_i_entered
    expect(page).to have_summary_list_row(
      "Reason for not offering",
      "Other - Some other reason",
    )
  end

  def and_i_see_the_entered_school_contact_details
    expect(page).to have_h2("Contact details", class: "govuk-heading-m")
    expect(page).to have_summary_list_row("First name", "Joe")
    expect(page).to have_summary_list_row("Last name", "Bloggs")
    expect(page).to have_summary_list_row("Email address", "joe_bloggs@example.com")
  end

  def when_i_click_on_back
    click_on "Back"
  end

  def and_i_see_the_school_contact_inputs_prefilled
    expect(page).to have_field("First name", with: "Joe")
    expect(page).to have_field("Last name", with: "Bloggs")
    expect(page).to have_field("Email address", with: "joe_bloggs@example.com")
  end

  def and_i_see_no_mentors_available_due_to_capacity_selected
    expect(page).to have_checked_field("No mentors available due to capacity", type: :checkbox)
  end

  def and_i_see_other_selected
    expect(page).to have_checked_field("Other", type: :checkbox)
  end

  def and_i_see_no_selected
    expect(page).to have_checked_field("No - I can’t offer placements", type: :radio)
  end

  def when_i_click_on_change_email_address
    click_on "Change Email address"
  end

  def when_i_click_on_change_reason_for_not_offering
    click_on "Change Reason for not offering"
  end

  def then_i_see_the_my_placement_preferences
    expect(page).to have_title(
      "What happens next? - Find ITT placements",
    )
    expect(page).to have_h1("What happens next?")
    expect(page).to have_paragraph(
      "We will ask in the next academic year whether you are able to offer placements for trainee teachers.",
    )
    expect(page).to have_paragraph(
      "If you would like to host placements this year, update your placement preferences to let providers know you’re interested.",
    )
    expect(page).to have_link("update your placement preferences", href: "")
  end
end
