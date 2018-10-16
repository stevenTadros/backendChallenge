class Billing

  def self.add_billing_info(data)
    data.each do |rental|
      rental[:rental_duration] = ((rental[:end_date] - rental[:start_date]).to_i)+1
      rental[:days_price] = days_price_calculator(rental[:car_price_per_day], rental[:rental_duration])
      rental[:kms_price] = rental[:car_price_per_km] * rental[:distance]
      rental[:bill] = split_commission(rental[:days_price] + rental[:kms_price],
                                       rental[:rental_duration],
                                       rental[:id])
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

  def self.split_commission(price, duration, id)
    total_commission = price * 0.3
    bill = Hash.new
    bill[:id] = id
    bill[:total_price] = price
    bill[:owner_benefit] = price - total_commission
    bill[:insurance_fee] = (total_commission * 0.5)
    bill[:assistance_fee] = (duration * 100)
    bill[:drivy_fee] = (total_commission - bill[:assistance_fee] - bill[:insurance_fee])
    bill.transform_values!(&:to_i)
  end

  def self.transfer_summary(data)
    person_types = %w[
      driver
      owner
      insurance
      assistance
      drivy
    ]

    bills = data.map{|com| com[:bill]}

    rentals = []

    bills.each do |bill|
      rental_bill = Hash.new
      rental_bill[:id] = bill[:id]
      rental_bill[:actions] = []

      person_types.each do |person_type|
        transfer_type = Hash.new
        transfer_type[:who] = person_type
        transfer_type[:type] = action_type(person_type)
        transfer_type[:ammount] = find_amount(person_type, bill)

        rental_bill[:actions] << transfer_type
      end
      rentals << rental_bill
    end
    rentals
  end

  def self.action_type(person_type)
    if person_type == "driver"
      "debit"
    else
      "credit"
    end
  end

  def self.find_amount(person_type, bill)
    case person_type
    when "driver"
      bill[:total_price]
    when "owner"
      bill[:owner_benefit]
    when "insurance"
      bill[:insurance_fee]
    when "assistance"
      bill[:assistance_fee]
    when "drivy"
      bill[:drivy_fee]
    end
  end

end
