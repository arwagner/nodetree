require './server.rb'
require 'CSV'

def load_rows(path_to_file, model)
  model.destroy_all

  File.open(path_to_file) do |file|
    rows = CSV.parse(file)
    rows.shift
    rows.each do |row|
      node_id = row[1].present? ? row[1].to_i : nil
      model.create!(id: row[0].to_i, node_id:)
    end
  end
end

if __FILE__ == $0
  load_rows('./nodes2.csv', Node)
  load_rows('./birds.csv', Bird)
end