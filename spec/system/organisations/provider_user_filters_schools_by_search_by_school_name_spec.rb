require "rails_helper"

RSpec.describe "Provider user filters schools by name", type: :system do
  scenario do
    given_that_schools_exist
    and_i_am_signed_in
    then_i_see_the_find_placements_page
    and_i_see_all_schools
    and_i_see_the_search_by_school_name_filter

    when_i_search_for_hogwarts
    and_i_click_on_apply_filters
    then_i_see_hogwarts
    and_i_do_not_see_beauxbatons
    and_i_see_the_hogwarts_search_by_name_filter

    when_i_click_on_the_hogwarts_search_by_name_filter_tag
    then_i_see_all_schools
    and_i_do_not_see_the_hogwarts_search_by_name_filter

    when_i_search_for_a_school_that_doesnt_exist
    and_i_click_on_apply_filters
    then_i_see_no_schools
    and_i_see_my_made_up_school_name_search_by_name_filter

    when_i_click_on_the_made_up_school_name_search_by_name_filter_tag
    then_i_see_all_schools
    and_i_do_not_see_the_hogwarts_search_by_name_filter
  end

  private

  def given_that_schools_exist
    @provider = build(:provider, name: "Ministry of Magic")

    @primary_school = create(:school, :with_placement_preferences, phase: "Primary", name: "Hogwarts")
    @secondary_school = create(:school, :with_placement_preferences,  phase: "Secondary", name: "Beauxbatons")
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

  def and_i_see_the_search_by_school_name_filter
    expect(page).to have_element(:label, text: "Search by school name")
    expect(page).to have_field("Enter a school name or URN", type: :search)
  end

  def when_i_search_for_hogwarts
    fill_in "Enter a school name or URN", with: "Hogwarts"
  end

  def and_i_click_on_apply_filters
    click_on "Apply filters"
  end

  def then_i_see_hogwarts
    expect(page).to have_h2("Hogwarts")
  end

  def and_i_do_not_see_beauxbatons
    expect(page).not_to have_h2("Beauxbatons")
  end

  def and_i_see_the_hogwarts_search_by_name_filter
    expect(page).to have_filter_tag("Hogwarts")
    expect(page).to have_field("Enter a school name or URN", type: :search, with: "Hogwarts")
  end

  def when_i_click_on_the_hogwarts_search_by_name_filter_tag
    within ".app-filter-tags" do
      click_on "Hogwarts"
    end
  end

  def then_i_see_all_schools
    expect(page).to have_content("Hogwarts")
    expect(page).to have_content("Beauxbatons")
  end

  def and_i_do_not_see_the_hogwarts_search_by_name_filter
    expect(page).not_to have_filter_tag("Hogwarts")
    expect(page).not_to have_field("Enter a school name or URN", type: :search, with: "Hogwarts")
  end

  def when_i_search_for_a_school_that_doesnt_exist
    fill_in "Enter a school name or URN", with: "Durmstrang Institute"
  end

  def then_i_see_no_schools
    expect(page).to have_h2("0 schools found")
    expect(page).to have_element(:p, text: "There are no schools that match your selection. Try searching again, or removing one or more filters.")
  end

  def and_i_see_my_made_up_school_name_search_by_name_filter
    expect(page).to have_filter_tag("Durmstrang Institute")
    expect(page).to have_field("Enter a school name or URN", type: :search, with: "Durmstrang Institute")
  end

  def when_i_click_on_the_made_up_school_name_search_by_name_filter_tag
    within ".app-filter-tags" do
      click_on "Durmstrang Institute"
    end
  end
end
