FactoryBot.define do
  factory :academic_year do
    trait :current do
      transient do
        today { Date.current }
      end

      starts_on do
        start_year = today.month < AcademicYear::START_DATE[:month] ? today.year - 1 : today.year
        Date.new(start_year, AcademicYear::START_DATE[:month], AcademicYear::START_DATE[:day])
      end

      ends_on do
        start_year = today.month < AcademicYear::START_DATE[:month] ? today.year - 1 : today.year
        Date.new(start_year + 1, AcademicYear::END_DATE[:month], AcademicYear::END_DATE[:day])
      end

      name { "#{starts_on.year} to #{ends_on.year}" }
    end

    trait :next do
      starts_on do
        start_year = Date.current.month < AcademicYear::START_DATE[:month] ? Date.current.year : Date.current.year + 1
        Date.new(start_year, AcademicYear::START_DATE[:month], AcademicYear::START_DATE[:day])
      end

      ends_on do
        start_year = Date.current.month < AcademicYear::START_DATE[:month] ? Date.current.year : Date.current.year + 1
        Date.new(start_year + 1, AcademicYear::END_DATE[:month], AcademicYear::END_DATE[:day])
      end

      name { "#{starts_on.year} to #{ends_on.year}" }
    end
  end
end
