require "rails_helper"

RSpec.describe "Provider user views find placements", type: :system do
  scenario do
    given_i_am_signed_in
    then_i_see_the_find_placements_page
  end

  private

  def given_i_am_signed_in
    @school = create(
      :school,
      name: "Hogwarts",
      minimum_age: 11,
      maximum_age: 18,
      phase: "Secondary",
      group: "Local authority maintained schools",
      organisation_address: build(:organisation_address, address_1: "Hogwarts School", address_2: "Hogsmeade", town: "Scotland", postcode: "AB12 3CD"),
      placement_preferences: [ build(:placement_preference, appetite: "interested", academic_year: AcademicYear.next) ]
    )

    @provider = build(:provider, name: "Order of the Phoenix")

    sign_in_user(organisations: [ @provider ])
  end

  def then_i_see_the_find_placements_page
    expect(page).to have_title("Find placements")
    expect(service_navigation).to have_current_item("Find placements")
    expect(page).to have_h1("Find placements")

    expect(page).to have_h2("Hogwarts")
    expect(page).to have_tag("May offer placements", "yellow")
    expect(page).to have_h3("School details")
    expect(page).to have_result_detail_row("Phase (age range)", "Secondary (11 to 18)")
    expect(page).to have_result_detail_row("Establishment group", "Local authority maintained schools")
    expect(page).to have_h3("Getting there")
    expect(page).to have_result_detail_row("Address", "Hogwarts School, Hogsmeade, Scotland, AB12 3CD")
  end
end
