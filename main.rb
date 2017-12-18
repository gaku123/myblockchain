require 'thor'
require './lib/node.rb'
require './lib/blockchain.rb'
require './lib/block.rb'
require './lib/transaction.rb'

class BCSimulator < Thor

  desc "create NUM_OF_NODES", "create nodes"
  def create(num_of_nodes=100)
    @@nodes = Array.new
    num_of_nodes.to_i.times do |id|
      @@nodes << Node.new(id)
    end
  end

  desc "print", "print nodes"
  def print
    return if not defined?(@@nodes)
    @@nodes.each do |node|
      Kernel.print node
    end
  end

  desc "send A B", "send A to B"
  def send(a, b)
    @@nodes[a].send(b)
  end

  desc "exit", "exit this program."
  def exit
    Kernel.exit
  end
end

loop do
  print 'bcsimulator$ '
  command = gets.split
  BCSimulator.start(command)
end
