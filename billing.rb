class Billing

  def self.add_billing_info(data)
    data.each do |rental|
      rental[:rental_duration] = ((rental[:end_date] - rental[:start_date]).to_i)+1
      rental[:days_price] = days_price_calculator(rental[:car_price_per_day], rental[:rental_duration])
      rental[:kms_price] = rental[:car_price_per_km] * rental[:distance]
      rental[:price] = rental[:days_price] + rental[:kms_price]
      rental[:commission] = split_commission(rental[:price], rental[:rental_duration])
    end
  end

  def self.days_price_calculator(car_price_per_day, duration)
    price_step_1 = car_price_per_day
    price_step_2 = car_price_per_day * 0.9
    price_step_3 = car_price_per_day * 0.7
    price_step_4 = car_price_per_day * 0.5

    case duration
    when 1
      price = price_step_1
    when 2..4
      price = price_step_1 + ((duration - 1) * price_step_2)
    when 5..10
      price = price_step_1 + (3 * price_step_2) + ((duration - 4) * price_step_3)
    when 11..Float::INFINITY
      price = price_step_1 + (3 * price_step_2) + (6 * price_step_3) + ((duration - 10) * price_step_4)
    end
    price.to_i
  end

  def self.split_commission(price, duration)
    total_commission = price * 0.3
    commission = Hash.new
    commission[:insurance_fee] = (total_commission * 0.5)
    commission[:assistance_fee] = (duration * 100)
    commission[:drivy_fee] = (total_commission - commission[:assistance_fee] - commission[:insurance_fee])
    commission.transform_values!(&:to_i)
  end

end
