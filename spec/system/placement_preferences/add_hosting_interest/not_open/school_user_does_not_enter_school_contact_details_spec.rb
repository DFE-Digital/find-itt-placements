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
    and_i_click_on_continue
    then_i_see_the_school_contact_form_page

    when_i_click_on_continue
    then_i_see_a_validation_error_for_entering_a_school_contact_email_address
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

  def then_i_see_a_validation_error_for_entering_a_school_contact_email_address
    expect(page).to have_validation_error(
      "Enter an email address",
    )
  end
end
