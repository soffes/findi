module Findi
  class Device
    attr_reader :model, :status, :id, :name, :kind, :battery_status, :battery_level, :location_type, :horizontal_accuracy, :longitude, :latitude, :location_timestamp

    def initialize(json)
      if location = json['location'] and location.is_a?(Hash)
        @location_timestamp = Time.at(location['timeStamp'] / 1000)
        @location_type = location['positionType']
        @horizontal_accuracy = location['horizontalAccuracy']
        @location_finished = location['locationFinished']
        @longitude = location['longitude']
        @latitude = location['latitude']
      end

      @is_locating = json['isLocating']
      @model = json['deviceModel']
      @status = json['deviceStatus']
      @id = json['id']
      @name = json['name']
      @kind = json['deviceClass']
      @battery_status = json['batteryStatus']
      @battery_level = json['batteryLevel']
    end

    def is_locating?
      @is_locating
    end

    def location_finished?
      @location_finished
    end
  end
end
