require "rails_helper"

RSpec.describe PlacementPreferenceDecorator do
  let(:placement_preference) { build(:placement_preference, placement_details:) }


  describe "#secondary_subject_name" do
    subject(:secondary_subject_name) do
      placement_preference.decorate.secondary_subject_name(subject_id: placement_subject.id)
    end

    context "when the subject has no child subjects" do
      let(:placement_subject) { create(:placement_subject, name: "English") }
      let(:placement_details) do
        { "secondary_subject_selection" => { "subject_ids" => [ placement_subject.id ] } }
      end

      it "returns the name of the subject" do
        expect(secondary_subject_name).to eq("English")
      end
    end

    context "when the subject has child subjects" do
      let(:placement_subject) { create(:placement_subject, name: "Modern Languages") }
      let(:french_subject) { create(:placement_subject, name: "French", parent_subject: placement_subject) }
      let(:german_subject) { create(:placement_subject, name: "German", parent_subject: placement_subject) }
      let(:italian_subject) { create(:placement_subject, name: "Italian", parent_subject: placement_subject) }
      let(:placement_details) do
        {
          "secondary_subject_selection" => { "subject_ids" => [ placement_subject.id ] },
          "secondary_child_subject_selection_#{placement_subject.id}" => {
            "selection_id" => placement_subject.id,
            "selection_number" => placement_subject.id,
            "parent_subject_id" => placement_subject.id,
            "child_subject_ids" => [ french_subject.id, italian_subject.id ]
           }
        }
      end

      it "returns the name of the subject, joined with the selected child subjects" do
        expect(secondary_subject_name).to eq("Modern Languages - French and Italian")
      end
    end
  end
end
