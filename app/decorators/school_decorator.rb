class SchoolDecorator < ApplicationDecorator
  include ActionView::Helpers::TextHelper

  delegate_all
  def formatted_inspection_date
    return "" if last_inspection_date.blank?

    I18n.l(last_inspection_date, format: :long)
  end

  def age_range
    "#{minimum_age} to #{maximum_age}"
  end

  def percentage_free_school_meals_percentage
    "#{percentage_free_school_meals}%" if percentage_free_school_meals.present?
  end

  def formatted_address(wrapper_tag: "p")
    return if address_string.blank?

    simple_format(address_string, {}, wrapper_tag:)
  end
end
