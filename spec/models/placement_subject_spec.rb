require 'rails_helper'

RSpec.describe PlacementSubject, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:parent_subject).optional }
    it { is_expected.to have_many(:child_subjects) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
  end

  describe "enums" do
    subject(:placement_subject) { build(:placement_subject) }

    it "defines the expected values" do
      expect(placement_subject).to define_enum_for(:phase)
        .with_values(primary: "primary", secondary: "secondary")
        .backed_by_column_of_type(:enum)
    end
  end

  describe "scopes" do
    describe ".order_by_name" do
      let(:placement_subject_a) { create(:placement_subject, name: "Subject A") }
      let(:placement_subject_b) { create(:placement_subject, name: "Subject B") }
      let(:placement_subject_c) { create(:placement_subject, name: "Subject C") }

      before do
        placement_subject_c
        placement_subject_a
        placement_subject_b
      end

      it "returns the placement subjects ordered by name" do
        expect(described_class.order_by_name).to eq([
          placement_subject_a,
          placement_subject_b,
          placement_subject_c
        ])
      end
    end

    describe ".parent_subjects" do
      let!(:parent_placement_subject) { create(:placement_subject, name: "Parent subject") }
      let(:child_placement_subject) do
        create(:placement_subject, name: "Child subject", parent_subject: parent_placement_subject)
      end

      before { child_placement_subject }

      it "returns the placement subjects with not parent subject" do
        expect(described_class.parent_subjects).to contain_exactly(parent_placement_subject)
      end
    end

    describe "stem_subjects" do
      let!(:biology_placement_subject) { create(:placement_subject, name: "Biology") }
      let!(:chemistry_placement_subject) { create(:placement_subject, name: "Chemistry") }
      let!(:computing_placement_subject) { create(:placement_subject, name: "Computing") }
      let!(:design_tech_placement_subject) { create(:placement_subject, name: "Design and technology") }
      let!(:mathematics_placement_subject) { create(:placement_subject, name: "Mathematics") }
      let!(:physics_placement_subject) { create(:placement_subject, name: "Physics") }
      let!(:science_placement_subject) { create(:placement_subject, name: "Science") }
      let(:another_placement_subject) { create(:placement_subject, name: "Another subject") }

      before { another_placement_subject }

      it "returns only the stem subjects" do
        expect(described_class.stem_subjects).to contain_exactly(
          biology_placement_subject,
          chemistry_placement_subject,
          computing_placement_subject,
          design_tech_placement_subject,
          mathematics_placement_subject,
          physics_placement_subject,
          science_placement_subject,
        )
      end
    end

    describe ".lit_lang_subjects" do
      let!(:english_placement_subject) { create(:placement_subject, name: "English") }
      let!(:modern_language_placement_subject) { create(:placement_subject, name: "Modern Languages") }
      let!(:latin_placement_subject) { create(:placement_subject, name: "Latin") }
      let(:another_placement_subject) { create(:placement_subject, name: "Another subject") }

      before { another_placement_subject }

      it "returns only the language and literature subjects" do
        expect(described_class.lit_lang_subjects).to contain_exactly(
          english_placement_subject,
          modern_language_placement_subject,
          latin_placement_subject
        )
      end
    end

    describe ".art_humanities_social_subjects" do
      let!(:greek_placement_subject) { create(:placement_subject, name: "Ancient Greek") }
      let!(:hebrew_placement_subject) { create(:placement_subject, name: "Ancient Hebrew") }
      let!(:art_placement_subject) { create(:placement_subject, name: "Art and design") }
      let!(:business_placement_subject) { create(:placement_subject, name: "Business studies") }
      let!(:citizenship_placement_subject) { create(:placement_subject, name: "Citizenship") }
      let!(:classics_placement_subject) { create(:placement_subject, name: "Classics") }
      let!(:media_placement_subject) { create(:placement_subject, name: "Communication and media studies") }
      let!(:dance_placement_subject) { create(:placement_subject, name: "Dance") }
      let!(:drama_placement_subject) { create(:placement_subject, name: "Drama") }
      let!(:economics_placement_subject) { create(:placement_subject, name: "Economics") }
      let!(:geography_placement_subject) { create(:placement_subject, name: "Geography") }
      let!(:history_placement_subject) { create(:placement_subject, name: "History") }
      let!(:music_placement_subject) { create(:placement_subject, name: "Music") }
      let!(:philosophy_placement_subject) { create(:placement_subject, name: "Philosophy") }
      let!(:psychology_placement_subject) { create(:placement_subject, name: "Psychology") }
      let!(:religious_placement_subject) { create(:placement_subject, name: "Religious education") }
      let!(:social_placement_subject) { create(:placement_subject, name: "Social sciences") }
      let(:another_placement_subject) { create(:placement_subject, name: "Another subject") }

       before { another_placement_subject }

      it "returns only the art, humanities and social subjects" do
        expect(described_class.art_humanities_social_subjects).to contain_exactly(
          greek_placement_subject,
          hebrew_placement_subject,
          art_placement_subject,
          business_placement_subject,
          citizenship_placement_subject,
          classics_placement_subject,
          media_placement_subject,
          dance_placement_subject,
          drama_placement_subject,
          economics_placement_subject,
          geography_placement_subject,
          history_placement_subject,
          music_placement_subject,
          philosophy_placement_subject,
          psychology_placement_subject,
          religious_placement_subject,
          social_placement_subject,
        )
      end
    end

    describe ".health_physical_education_subjects" do
      let!(:social_care_placement_subject) { create(:placement_subject, name: "Health and social care") }
      let!(:physical_education_placement_subject) { create(:placement_subject, name: "Physical education") }
      let!(:ebacc_placement_subject) { create(:placement_subject, name: "Physical education with an EBacc subject") }
      let(:another_placement_subject) { create(:placement_subject, name: "Another subject") }

      before { another_placement_subject }

      it "returns only health and physical education subjects" do
        expect(described_class.health_physical_education_subjects).to contain_exactly(
          social_care_placement_subject,
          physical_education_placement_subject,
          ebacc_placement_subject
        )
      end
    end

    describe "#has_child_subjects?" do
      subject(:has_child_subjects) { placement_subject.has_child_subjects? }

      let!(:placement_subject) { create(:placement_subject, name: "Subject") }

      context "when the placement subject has no child subjects" do
        it "returns false" do
          expect(has_child_subjects).to eq(false)
        end
      end

      context "when the placement subject has child subjects" do
        let(:child_placement_subject) do
          create(:placement_subject, name: "Child subject", parent_subject: placement_subject)
        end

        before { child_placement_subject }

        it "returns true" do
          expect(has_child_subjects).to eq(true)
        end
      end
    end
  end
end
