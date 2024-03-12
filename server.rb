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

def lowest_common_ancestor(*nodes)
  return nil if nodes.any? {|node| node.nil? }
  
  return nodes[0] if nodes.all? {|node| node.id === nodes[0].id }
  
  depths = nodes.map {|node| depth(node) }
  if (depths.all? {|current_depth| current_depth === depths[0] })
    return lowest_common_ancestor(*nodes.map {|node| node.node })
  end
  
  minimum_depth = depths.min
  nodes = nodes.map.with_index {|node, index| nth_ancestor(node, depths[index] - minimum_depth)}
  return lowest_common_ancestor(*nodes)
end

def depth(node)
  return 1 if node.node_id.nil?
  return memoized[node.id] if memoized.has_key?(node.id)

  answer = 1 + depth(node.node)
  memoized[node.id] = answer
  answer
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

def memoized
  @memoized ||= {}
end