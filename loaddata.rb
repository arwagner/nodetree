require './server.rb'
require 'CSV'

Node.destroy_all

File.open('./nodes2.csv') do |file|
  nodes = CSV.parse(file)
  nodes.shift
  nodes.each do |node|
    node_id = node[1].present? ? node[1].to_i : nil
    Node.create!(id: node[0].to_i, node_id:)
  end
end