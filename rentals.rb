class Rentals

  def self.build_friendly_hash(data)
    friendly_hash = []

    data["rentals"].each do |rental|
      targeted_car = data["cars"].select{|i| i["id"] == rental["car_id"]}

      rent = {
        id: rental["id"],
        car_id: rental["car_id"],
        distance: rental["distance"],
        start_date: Date.parse(rental["start_date"]),
        end_date: Date.parse(rental["end_date"]),
        car_price_per_day: targeted_car.first["price_per_day"],
        car_price_per_km: targeted_car.first["price_per_km"]
      }
      rent[:rental_duration] = (rent[:end_date] - rent[:start_date]).to_i
      rent[:days_price] = rent[:car_price_per_day] * rent[:rental_duration]
      rent[:kms_price] = rent[:car_price_per_km] * rent[:rental_duration]
      rent[:price] = rent[:days_price] + rent[:kms_price]

      friendly_hash << rent
    end
    friendly_hash
  end

  def self.delete_unwanted_keys(data)
    data.map do |rental|
      rental.delete_if {|key, value| key != :id && key != :price }
    end
  end

end
