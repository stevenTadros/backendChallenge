class Rentals

  def self.build_friendly_hash(data)
    rent = []

    data["rentals"].each do |rental|
      targeted_car = data["cars"].select{|i| i["id"] == rental["car_id"]}

      friendly_hash = {
        id: rental["id"],
        car_id: rental["car_id"],
        distance: rental["distance"],
        start_date: Date.parse(rental["start_date"]),
        end_date: Date.parse(rental["end_date"]),
        car_price_per_day: targeted_car.first["price_per_day"],
        car_price_per_km: targeted_car.first["price_per_km"]
      }

      rent << friendly_hash
    end
    rent
  end

end
