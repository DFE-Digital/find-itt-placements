class Organisations::FilterForm < ApplicationForm
  include ActiveModel::Attributes

  attribute :search_location, default: nil
  attribute :search_by_name, default: nil
  attribute :phases, default: []
  attribute :itt_statuses, default: []
  attribute :schools_to_show, default: "active"

  def initialize(params = {})
    params.each_value { |v| v.compact_blank! if v.is_a?(Array) }

    super(params)
  end

  def filters_selected?
    attributes
      .except("schools_to_show")
      .values
      .compact
      .flatten
      .select(&:present?)
      .any?
  end

  def clear_filters_path
    organisations_path
  end

  def index_path_without_filter(filter:, value: nil)
    without_filter = if SINGULAR_ATTRIBUTES.include?(filter)
                       compacted_attributes.reject { |key, _| key == filter }
    else
                       compacted_attributes.merge(filter => compacted_attributes[filter].reject { |filter_value| filter_value == value })
    end

    organisations_path(
      params: { filters: without_filter },
    )
  end

  def query_params
    {
      search_location:,
      search_by_name:,
      phases:,
      itt_statuses:,
        schools_to_show:
    }
  end

  def primary_selected?
    phases.include?("Primary")
  end

  def secondary_selected?
    phases.include?("Secondary")
  end

  def primary_only?
    primary_selected? && !secondary_selected?
  end

  def secondary_only?
    !primary_selected? && secondary_selected?
  end

  private

  SINGULAR_ATTRIBUTES = %w[search_location search_by_name schools_to_show].freeze

  def compacted_attributes
    @compacted_attributes ||= attributes.compact_blank
  end
end
