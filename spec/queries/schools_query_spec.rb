require "rails_helper"

describe SchoolsQuery do
  subject(:query) { described_class.new(params:) }

  let(:params) { {} }
  let(:query_school) do
    create(
      :school,
      name: "London Primary School",
      phase: "All-through",
      latitude: 51.648438,
      longitude: 14.350231,
    )
  end
  let(:non_query_school) do
    create(:school, name: "York Secondary School", latitude: 29.732613, longitude: 105.448063)
  end

  before do
    query_school
    non_query_school
  end

  describe "#call" do
    it "returns all schools" do
      expect(query.call).to include(query_school)
      expect(query.call).to include(non_query_school)
    end

    context "when filtering by name" do
      let(:params) { { filters: { search_by_name: "London" } } }

      it "returns the filtered schools" do
        expect(query.call).to include(query_school)
        expect(query.call).not_to include(non_query_school)
      end
    end

    context "when filtering by phase" do
      let(:params) { { filters: { phases: [ query_school.phase ] } } }

      it "returns the filtered schools" do
        expect(query.call).to include(query_school)
        expect(query.call).not_to include(non_query_school)
      end
    end

    context "when filtering by location" do
      let!(:close_query_school) do
        create(
          :school,
          name: "Bob's Primary School",
          phase: "Primary",
          latitude: 51.651101,
          longitude: 14.347458,
        )
      end

      let!(:far_query_school) do
        create(
          :school,
          name: "Bob's Primary School",
          phase: "Primary",
          latitude: 51.654505,
          longitude: 14.319858,
        )
      end

      let(:location_coordinates) { [ query_school.latitude, query_school.longitude ] }
      let(:params) { { location_coordinates: } }

      it "returns the filtered schools in order of distance" do
        expect(query.call).to eq([ query_school.becomes(School), close_query_school.becomes(School), far_query_school.becomes(School) ])
        expect(query.call).not_to include(non_query_school)
      end
    end
  end
end
