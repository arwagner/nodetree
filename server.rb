require 'sinatra'
require 'rackup'
require 'mongoid'

Mongoid.load! "mongoid.config"

class Node
  include Mongoid::Document

  belongs_to :node, optional: true
end

get '/' do
  Node.all.to_json
end