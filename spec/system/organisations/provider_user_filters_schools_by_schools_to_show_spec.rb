require "rails_helper"

RSpec.describe "Provider user filters schools by schools to show", type: :system do
  scenario do
    given_that_schools_exist
    and_i_am_signed_in
    then_i_see_the_find_placements_page
    and_i_see_active_schools
    and_i_see_the_schools_to_show_filter

    when_i_select_all_from_the_schools_to_show_filter
    and_i_click_on_apply_filters
    then_i_see_all_schools
    and_i_see_all_schools_is_now_selected
    and_i_do_not_see_any_filter_tags
  end

  private

  def given_that_schools_exist
    @provider = build(:provider, name: "Ministry of Magic")

    @active_school = create(:school, :with_placement_preferences, name: "Hogwarts")
    @inactive_school = create(:school, name: "Beauxbatons")
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

  def and_i_see_active_schools
    expect(page).to have_h2("Hogwarts")
  end

  def and_i_see_the_schools_to_show_filter
    expect(page).to have_checked_field("Only schools using the service", type: :radio)
    expect(page).to have_unchecked_field("All schools", type: :radio)
  end

  def when_i_select_all_from_the_schools_to_show_filter
    choose "All schools"
  end

  def and_i_click_on_apply_filters
    click_on "Apply filters"
  end

  def then_i_see_all_schools
    expect(page).to have_h2("Hogwarts")
    expect(page).to have_h2("Beauxbatons")
  end

  def and_i_see_all_schools_is_now_selected
    expect(page).to have_unchecked_field("Only schools using the service", type: :radio)
    expect(page).to have_checked_field("All schools", type: :radio)
  end

  def and_i_do_not_see_any_filter_tags
    expect(page).not_to have_css(".app-filter__tag")
  end
end
