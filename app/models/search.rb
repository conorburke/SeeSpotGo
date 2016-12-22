class Search
  attr_accessor :location, :mile_range, :size, :price_range, :price, :start_time, :end_time, :errors, :locations, :space_params

  def initialize(params)
    self.location = params[:search] || ""
    self.mile_range = params[:miles]
    self.size = params[:size]
    self.price_range = params[:constrain]
    self.price = params[:price]
    self.start_time = params[:start_time]
    self.end_time = params[:end_time]
    self.errors = []
    self.locations = []
    self.space_params = {}
  end

  def valid?
    if self.location.empty?
      errors << "Location is not valid"
    elsif (price_range != "any") && (!self.price || self.price < "0")
      errors << "Price is not valid"
    elsif (!self.start_time || self.start_time.empty?) || (!self.end_time || self.end_time.empty?)
      errors << "Start/End time is not valid"
    else
      prepare_search
      # if self.start_time < Time.zone.now || self.end_time < self.start_time
      #   errors << "Start/End time is not valid"
      # end
    end

    self.errors.empty? ? true : false
  end

  def search_locations
    location_in_range
    location_with_available_spaces
  end

  private

  def prepare_search
    # prepare price
    self.price_range == "any" ? self.price = 999 : self.price = self.price.to_i
    # prepare time
    self.start_time = Time.zone.parse(self.start_time)
    self.end_time = Time.zone.parse(self.end_time)
    # prepare space_params
    self.space_params[:price] = self.price
    self.space_params[:size] = self.size
    self.space_params[:start_time] = self.start_time
    self.space_params[:end_time] = self.end_time
  end

  def location_in_range
    self.locations = Location.near(self.location, self.mile_range)
  end

  def location_with_available_spaces
    self.locations = self.locations.select do |location|
      location.spaces.find { |space| space.space_available?(self.space_params) }
    end
  end
end
