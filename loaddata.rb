require './server.rb'
require 'CSV'

Node.destroy_all

File.open('./nodes.csv') do |file|
  nodes = CSV.parse(file)
  nodes.shift
  nodes.each {|node| Node.create!(id: node[0], node_id: node[1])}
end