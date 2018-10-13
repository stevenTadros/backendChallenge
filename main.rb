require 'json'
require 'date'
require_relative 'rentals'
require_relative 'json_methods'

file = File.read "data/input.json"

data = JSON.parse(file)

rentals_friendly_hash = Rentals.build_friendly_hash(data)

rentals_data = Rentals.delete_unwanted_keys(rentals_friendly_hash)

formated_data = JsonMethods.format_hash(rentals_data)

JsonMethods.generate_json(formated_data)
