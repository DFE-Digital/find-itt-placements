require 'rails_helper'

RSpec.describe PlacementPreference, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:academic_year) }
    it { is_expected.to belong_to(:organisation) }
    it { is_expected.to belong_to(:created_by).class_name("User") }
  end

  describe "enums" do
    subject(:placement_preference) { build(:placement_preference, appetite: :actively_looking) }

    it "defines the expected values" do
      expect(placement_preference).to define_enum_for(:appetite)
        .with_values(
          actively_looking: "actively_looking",
          interested: "interested",
          not_open: "not_open",
        )
        .backed_by_column_of_type(:enum)
    end
  end


  describe "scopes" do
    describe "#for_academic_year" do
      let(:academic_year_2324) do
        build(:academic_year,
             starts_on: Date.parse("1 September 2023"),
             ends_on: Date.parse("31 August 2024"),
             name: "2023 to 2024")
      end
      let!(:academic_year_2425) do
        build(:academic_year,
             starts_on: Date.parse("1 September 2024"),
             ends_on: Date.parse("31 August 2025"),
             name: "2024 to 2025")
      end
      let(:placement_preference_2324) do
        create(:placement_preference, academic_year: academic_year_2324)
      end
      let!(:placement_preference_2425) do
        create(:placement_preference, academic_year: academic_year_2425)
      end

      before do
        academic_year_2324
        placement_preference_2324
      end

      it "returns only the placement preferences for the given academic year" do
        expect(
          described_class.for_academic_year(academic_year_2425)
        ).to contain_exactly(placement_preference_2425)
      end
    end
  end
end
