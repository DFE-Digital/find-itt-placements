require "rails_helper"

RSpec.describe "School user successfully adds their hosting interest", type: :system do
  scenario do
    given_i_am_signed_in
    and_academic_years_exist
    when_i_visit_the_new_placement_preferences_url
    then_i_see_the_appetite_form_page

    when_i_select_yes
    and_i_click_on_continue
    then_i_see_the_education_phase_form_page

    when_i_select_primary
    and_i_click_on_continue
    then_i_see_the_year_group_selection_form_page

    when_i_select_year_1
    and_i_select_year_5
    and_i_click_on_continue
    then_i_see_the_school_contact_form_page

    when_i_fill_in_the_school_contact_details
    and_i_click_on_continue
    then_i_see_the_check_your_answers_page

    when_i_click_on_change_email_address
    then_i_see_the_school_contact_form_page
    and_i_see_the_school_contact_inputs_prefilled

    when_i_click_on_continue
    then_i_see_the_check_your_answers_page

    when_i_click_on_change_year_group
    then_i_see_the_year_group_selection_form_page
    and_i_see_year_1_selected
    and_i_see_year_5_selected

    when_i_click_on_continue
    then_i_see_the_school_contact_form_page
    and_i_see_the_school_contact_inputs_prefilled

    when_i_click_on_continue
    then_i_see_the_check_your_answers_page

    when_i_click_on_change_phase
    then_i_see_the_education_phase_form_page
    and_i_see_primary_selected

    when_i_click_on_continue
    then_i_see_the_year_group_selection_form_page
    and_i_see_year_1_selected
    and_i_see_year_5_selected

    when_i_click_on_continue
    then_i_see_the_school_contact_form_page
    and_i_see_the_school_contact_inputs_prefilled

    when_i_click_on_continue
    then_i_see_the_check_your_answers_page

    when_i_click_on_publish_placements
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

  def when_i_select_primary
    check "Primary"
  end

  def then_i_see_the_year_group_selection_form_page
    expect(page).to have_title(
      "What primary school year groups can you offer placements in? - Find ITT placements",
    )
    expect(page).to have_element(
      :legend,
      text: "What primary school year groups can you offer placements in?",
      class: "govuk-fieldset__legend",
    )
    expect(page).to have_caption("Primary placement details")
    expect(page).to have_field("Nursery", type: :checkbox)
    expect(page).to have_field("Reception", type: :checkbox)
    expect(page).to have_field("Year 1", type: :checkbox)
    expect(page).to have_field("Year 2", type: :checkbox)
    expect(page).to have_field("Year 3", type: :checkbox)
    expect(page).to have_field("Year 4", type: :checkbox)
    expect(page).to have_field("Year 5", type: :checkbox)
    expect(page).to have_field("Year 6", type: :checkbox)
    expect(page).to have_field("Mixed year groups", type: :checkbox)
  end

  def when_i_select_year_1
    check "Year 1"
  end

  def and_i_select_year_5
    check "Year 5"
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

  def then_i_see_the_check_your_answers_page
    expect(page).to have_title(
      "Check your answers - Find ITT placements",
    )
    expect(page).to have_h1("Check your answers")

     expect(page).to have_h2("Education phase")
    expect(page).to have_summary_list_row("Phase", "Primary Secondary Send")

    expect(page).to have_h2("Primary placements")
    expect(page).to have_summary_list_row("Year group", "Year 1 Year 5")

    expect(page).to have_h2("Placement contact")
    expect(page).to have_summary_list_row("First name", "Joe")
    expect(page).to have_summary_list_row("Last name", "Bloggs")
    expect(page).to have_summary_list_row("Email address", "joe_bloggs@example.com")
  end

  def when_i_click_on_change_email_address
    click_on "Change Email address"
  end

  def and_i_see_the_school_contact_inputs_prefilled
    expect(page).to have_field("First name", with: "Joe")
    expect(page).to have_field("Last name", with: "Bloggs")
    expect(page).to have_field("Email address", with: "joe_bloggs@example.com")
  end

  def when_i_click_on_change_year_group
    click_on "Change Year group"
  end

  def and_i_see_year_1_selected
    expect(page).to have_checked_field("Year 1", type: :checkbox)
  end

  def and_i_see_year_5_selected
    expect(page).to have_checked_field("Year 5", type: :checkbox)
  end

  def and_i_see_primary_selected
    expect(page).to have_checked_field("Primary", type: :checkbox)
  end

  def when_i_click_on_change_phase
    click_on "Change Phase"
  end

  def when_i_click_on_publish_placements
    click_on "Publish placements"
  end

  def then_i_see_the_my_placement_preferences
    expect(page).to have_title(
      "What happens next? - Find ITT placements",
    )
    expect(page).to have_h1("What happens next?")
    expect(page).to have_paragraph(
      "Providers will be able to contact you on about your placement offers.",
    )
    expect(page).to have_paragraph(
      "You do not need to take any further action until providers contact you. After discussions with one or more providers, you can then decide whether to assign providers to your placements.",
    )
    expect(page).to have_paragraph(
      "Assigning a provider to a placement in this service is not a contractual agreement for a trainee to be placed in your school. An agreement must be made between you and the provider outside this service.",
    )

    expect(page).to have_h2("Manage your placements")
    expect(page).to have_link("Edit your placements", href: "")
    expect(page).to have_paragraph(
      "Edit your placements to change or remove information.",
    )

    expect(page).to have_h2("Your placements offers")
    expect(page).to have_h3("Primary placements")
    expect(page).to have_summary_list_row("Year group", "Year 1 Year 5")
  end
end
