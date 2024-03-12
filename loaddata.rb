require './server.rb'
require 'CSV'

def load_data(path_to_file)
  Node.destroy_all

  File.open(path_to_file) do |file|
    nodes = CSV.parse(file)
    nodes.shift
    nodes.each do |node|
      node_id = node[1].present? ? node[1].to_i : nil
      Node.create!(id: node[0].to_i, node_id:)
    end
  end
end

if __FILE__ == $0
  load_data('./nodes2.csv')
end