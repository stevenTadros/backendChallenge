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
      rent[:days_price] = days_price_calculator(rent[:car_price_per_day], rent[:rental_duration]).to_i
      rent[:kms_price] = rent[:car_price_per_km] * rent[:rental_duration]
      rent[:price] = rent[:days_price] + rent[:kms_price]

      friendly_hash << rent
    end
    friendly_hash
  end

  def self.days_price_calculator(car_price_per_day, duration)
    price_step_1 = car_price_per_day
    price_step_2 = car_price_per_day * 0.9
    price_step_3 = car_price_per_day * 0.7
    price_step_4 = car_price_per_day * 0.5

    case duration
    when 0..1
      price_step_1
    when 2..4
      price_step_1 + ((duration - 1) * price_step_2)
    when 5..10
      price_step_1 + (3 * price_step_2) + ((duration - 4) * price_step_3)
    when 11..Float::INFINITY
      price_step_1 + (3 * price_step_2) + (6 * price_step_3) + ((duration - 10) * price_step_4)
    end
  end

  def self.delete_unwanted_keys(data)
    data.map do |rental|
      rental.delete_if {|key, value| key != :id && key != :price }
    end
  end

end
