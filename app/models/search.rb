class Search
  attr_accessor :location, :mile_range, :size, :price_range, :price, :start_time, :end_time, :errors, :locations

  def initialize(params)
    self.location = params[:search]
    self.mile_range = params[:miles]
    self.size = params[:size]
    self.price_range = params[:constrain]
    self.price = params[:price]
    self.start_time = params[:start_time]
    self.end_time = params[:end_time]
    self.errors = []
    self.locations = []
  end

  def valid?
    if !self.location || self.location.empty?
      errors << "Location is not valid"
    elsif (price_range != "any") && (!self.price || !(self.price.is_a? Integer) || self.price < "2")
      errors << "Price is not valid"
    elsif (!self.start_time || self.start_time.empty?) || (!self.end_time || self.end_time.empty?)
      errors << "Start/End time is not valid"
    else
        prepare_search
    end

    errors.empty? ? true : false
  end

  def search_locations
    location_in_range
    location_with_active_spaces
    location_with_required_space
    self.locations
  end

  private

  def prepare_search
    # prepare price
    self.price_range == "any" ? self.price = 999 : self.price = self.price.to_i
    # prepare time
    self.start_time = Time.zone.parse(self.start_time)
    self.end_time = Time.zone.parse(self.end_time)
  end

  def location_in_range
    self.locations = Location.near(self.location, self.mile_range)
  end

  def location_with_active_spaces
    self.locations = self.locations.select { |location| location.active_spaces.count != 0 }
  end

  def location_with_required_space
    self.locations = self.locations.select do |location|
      spaces = location.active_spaces
      !!(spaces.find { |space| space.size == self.size })
    end
  end
end
