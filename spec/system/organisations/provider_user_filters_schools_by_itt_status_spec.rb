require "rails_helper"

RSpec.describe "Provider user filters schools by ITT status", type: :system do
  scenario do
    given_that_schools_exist
    and_i_am_signed_in
    then_i_see_the_find_placements_page
    and_i_see_all_schools
    and_i_see_the_itt_status_filter

    when_i_select_placements_available_from_the_itt_status_filter
    and_i_click_on_apply_filters
    then_i_see_the_placements_available_school
    and_i_do_not_see_the_may_offer_school
    and_i_see_that_the_placements_available_itt_status_checkbox_is_selected
    and_i_see_the_placements_available_filter_tag

    when_i_select_may_offer_from_the_itt_status_filter
    and_i_click_on_apply_filters
    then_i_see_all_schools
    and_i_see_that_the_placements_available_and_may_offer_checkboxes_are_selected
    and_i_see_the_placements_available_and_may_offer_filter_tags

    when_i_click_on_the_placements_available_itt_status_tag
    then_i_see_the_may_offer_school
    and_i_do_not_see_the_placements_available_school
    and_i_do_not_see_the_placements_available_itt_status_checkbox_selected
    and_i_do_not_see_the_placements_available_filter_tag

    when_i_click_on_the_may_offer_itt_status_tag
    then_i_see_all_schools
    and_i_do_not_see_any_selected_itt_status_checkboxes
    and_i_do_not_see_any_itt_status_filter_tags
  end

  private

  def given_that_schools_exist
    @provider = build(:provider, name: "Ministry of Magic")

    @placements_available_school = create(:school, phase: "Primary", name: "Hogwarts", placement_preferences:
      [ build(:placement_preference, appetite: "actively_looking", academic_year: AcademicYear.next) ])
    @may_offer_school = create(:school, phase: "Secondary", name: "Beauxbatons", placement_preferences:
      [ build(:placement_preference, appetite: "interested", academic_year: AcademicYear.next) ])
  end

  def and_i_am_signed_in
    sign_in_user(organisations: [ @provider ])
  end

  def then_i_see_the_find_placements_page
    expect(page).to have_title("Find placements - Find ITT placements")
    expect(service_navigation).to have_current_item("Find placements")
    expect(page).to have_h1("Find placements")
    expect(page).to have_h2("Filter")
  end

  def and_i_see_all_schools
    expect(page).to have_h2("Hogwarts")
    expect(page).to have_h2("Beauxbatons")
  end

  def and_i_see_the_itt_status_filter
    expect(page).to have_element(:legend, text: "ITT status", class: "govuk-fieldset__legend")
    expect(page).to have_unchecked_field("Placements available")
    expect(page).to have_unchecked_field("May offer placements")
  end

  def when_i_select_placements_available_from_the_itt_status_filter
    check "Placements available"
  end

  def and_i_click_on_apply_filters
    click_on "Apply filters"
  end

  def then_i_see_the_placements_available_school
    expect(page).to have_h2("Hogwarts")
  end

  def and_i_do_not_see_the_may_offer_school
    expect(page).not_to have_h2("Beauxbatons")
  end

  def and_i_see_that_the_placements_available_itt_status_checkbox_is_selected
    expect(page).to have_checked_field("Placements available")
  end

  def and_i_see_the_placements_available_filter_tag
    expect(page).to have_filter_tag("Placements available")
  end

  def when_i_select_may_offer_from_the_itt_status_filter
    check "May offer placements"
  end

  def and_i_see_that_the_placements_available_and_may_offer_checkboxes_are_selected
    expect(page).to have_checked_field("Placements available")
    expect(page).to have_checked_field("May offer placements")
  end

  def and_i_see_the_placements_available_and_may_offer_filter_tags
    expect(page).to have_filter_tag("Placements available")
    expect(page).to have_filter_tag("May offer placements")
  end

  def when_i_click_on_the_placements_available_itt_status_tag
    within ".app-filter-tags" do
      click_on "Placements available"
    end
  end

  def then_i_see_the_may_offer_school
    expect(page).to have_h2("Beauxbatons")
  end

  def and_i_do_not_see_the_placements_available_school
    expect(page).not_to have_h2("Hogwarts")
  end

  def and_i_do_not_see_the_placements_available_itt_status_checkbox_selected
    expect(page).to have_field("Placements available", type: "checkbox", checked: false)
    expect(page).to have_field("May offer placements", type: "checkbox", checked: true)
  end

  def and_i_do_not_see_the_placements_available_filter_tag
    expect(page).not_to have_filter_tag("Placements available")
  end

  def when_i_click_on_the_may_offer_itt_status_tag
    within ".app-filter-tags" do
      click_on "May offer placements"
    end
  end

  def then_i_see_all_schools
    expect(page).to have_h2("Hogwarts")
    expect(page).to have_h2("Beauxbatons")
  end

  def and_i_do_not_see_any_selected_itt_status_checkboxes
    expect(page).not_to have_field("Placements available", type: "checkbox", checked: true)
    expect(page).not_to have_field("May offer placements", type: "checkbox", checked: true)
  end

  def and_i_do_not_see_any_itt_status_filter_tags
    expect(page).not_to have_h3("ITT status")
    expect(page).not_to have_filter_tag("Placements available")
    expect(page).not_to have_filter_tag("May offer placements")
  end
end
