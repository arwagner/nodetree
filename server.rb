require 'sinatra'
require 'rackup'
require 'mongoid'

Mongoid.load! "mongoid.config"

class Node
  include Mongoid::Document

  belongs_to :node, optional: true
end

get '/common_ancestor' do
  a = Node.find(params['a'].to_i) rescue nil
  b = Node.find(params['b'].to_i) rescue nil

  return "{root_id: null, lowest_common_ancestor: null, depth: null}" if a.nil?
  return "{root_id: null, lowest_common_ancestor: null, depth: null}" if b.nil?

  lca = lowest_common_ancestor(a, b)
  "root_id: #{root(lca).id}, lowest_common_ancestor: #{lca.id}, depth: #{depth(lca)}"
end

def lowest_common_ancestor(a, b)
  return nil if a.nil? || b.nil?

  return a if a.id === b.id

  depth_of_a = depth(a)
  depth_of_b = depth(b)
  return lowest_common_ancestor(a, nth_ancestor(b, depth_of_b - depth_of_a)) if depth_of_b > depth_of_a
  return lowest_common_ancestor(nth_ancestor(a, depth_of_a - depth_of_b), b) if depth_of_a > depth_of_b

  return lowest_common_ancestor(a.node, b.node)
end

def depth(node)
  return 1 if node.node_id.nil?
  return 1 + depth(node.node)
end

def root(node)
  return node if node.node.nil?
  return root(node.node)
end

def nth_ancestor(node, n)
  return nil if node.nil?
  return node if n == 0
  nth_ancestor(node.node, n-1)
end