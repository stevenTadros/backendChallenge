class JsonMethods

  def self.format_hash(data)
    formated_hash = Hash.new
    formated_hash[:rentals] = data
    formated_hash
  end

  def self.delete_unwanted_keys(data)
    data.map do |rental|
      rental.delete_if {|key, value| key != :id && key != :price && key != :commission}
    end
  end

  def self.generate_json(data)
    Dir.mkdir('data') unless Dir.exists?('data')
    File.open("data/output.json", "w") do |file|
      file.puts JSON.pretty_generate(data)
    end
  end

end
