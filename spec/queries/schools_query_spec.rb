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
      placement_preferences: [ build(:placement_preference, appetite: "actively_looking", academic_year: AcademicYear.next) ]
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
    it "returns available schools" do
      expect(query.call).to include(query_school)
      expect(query.call).not_to include(non_query_school)
    end

    context "when filtering by all schools" do
      let(:params) { { filters: { schools_to_show: "all" } } }

      it "returns all schools" do
        expect(query.call).to include(query_school)
        expect(query.call).to include(non_query_school)
      end
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
          name: "Jeff's Primary School",
          phase: "Primary",
          latitude: 51.654505,
          longitude: 14.319858,
        )
      end

      let(:location_coordinates) { [ query_school.latitude, query_school.longitude ] }
      let(:params) { { location_coordinates:, filters: { schools_to_show: "all" } } }

      it "returns the filtered schools in order of distance" do
        expect(query.call).to eq([ query_school, close_query_school, far_query_school ])
        expect(query.call).not_to include(non_query_school)
      end
    end

    context "when filtering schools by placement preferences" do
      let(:interested_school) { create(:school, name: "Interested school", placement_preferences: [ build(:placement_preference, :interested, academic_year: AcademicYear.next) ]) }
      let(:not_open_school) { create(:school, name: "Not open school", placement_preferences: [ build(:placement_preference, :not_open, academic_year: AcademicYear.next) ]) }

      before do
        interested_school
        not_open_school
      end

      context "when filtering by actively looking schools" do
        let(:params) { { filters: { itt_statuses: [ "actively_looking" ], schools_to_show: "all" } } }

        it "returns schools with matching placement preferences" do
          expect(query.call).to include(query_school)
          expect(query.call).not_to include(non_query_school)
          expect(query.call).not_to include(interested_school)
          expect(query.call).not_to include(not_open_school)
        end
      end

      context "when filtering by interested schools" do
        let(:params) { { filters: { itt_statuses: [ "open" ] } } }

        it "returns schools with matching placement preferences" do
          expect(query.call).to include(interested_school)
          expect(query.call).not_to include(query_school)
          expect(query.call).not_to include(non_query_school)
          expect(query.call).not_to include(not_open_school)
        end
      end

      context "when filtering by not open schools" do
        let(:params) { { filters: { itt_statuses: [ "not_open" ] } } }

        it "returns schools with matching placement preferences" do
          expect(query.call).to include(not_open_school)
          expect(query.call).not_to include(query_school)
          expect(query.call).not_to include(non_query_school)
          expect(query.call).not_to include(interested_school)
        end
      end

      context "when filtering by multiple statuses" do
        let(:params) { { filters: { itt_statuses: [ "actively_looking", "open" ] } } }

        it "returns schools with matching placement preferences" do
          expect(query.call).to include(query_school)
          expect(query.call).to include(interested_school)
          expect(query.call).not_to include(non_query_school)
          expect(query.call).not_to include(not_open_school)
        end
      end
    end
  end
end
