class MapComponent < ApplicationComponent
  attr_reader :organisations, :base_longitude, :base_latitude

  def initialize(organisations:, base_longitude:, base_latitude:, classes: [], html_attributes: {})
    super(classes:, html_attributes:)

    @organisations = organisations
    @base_longitude = base_longitude
    @base_latitude = base_latitude
  end

  def map_id
    SecureRandom.uuid
  end

  def render?
    !organisations.pluck(:longitude, :latitude).compact.flatten.uniq.all?(nil)
  end
end
