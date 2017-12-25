require 'openssl'
OpenSSL::Random.seed(File.read("/dev/random", 16))

class Node

  def initialize(id)
    @rsa = OpenSSL::PKey::RSA.generate(2048)
    @id = id
    @blockchain = Blockchain.new
    @current_block = Array.new
  end

  def wallet(id)
    txs = @blockchain.get_all_transaction_to(id)
    txs.reject do |tx|
      @blockchain.used_as_input?(tx.hash)
    end

    coins = 0
    txs.each do |tx|
      coins += tx.sum_of_coin_to(@id)
    end
		
    coins
  end

  def send(target, coin)
    txs = wallet(@id)
    txs.each do |tx|
      puts "#{@id} to #{tx.hash} #{coin} coin"
    end
    input_coins = 0
    hashs = Array.new
    txs.each do |tx|
      input_coins += tx.sum_of_coin_to(@id)
      hashs << tx.hash
      break if input_coins > coin.to_i
    end
    to_and_coin_values = [{to: target, coin_value: coin}]
    if (input_coins - coin.to_i) > 0
      to_and_coin_values << {to: @id, coin_value: (input_coins - coin.to_i).to_s}
    end
    tx = Transaction.create_transaction(hashs, to_and_coin_values)
    puts tx.to_s
  end

  def receive_transaction(tx)
    @current_block.add_transaction(tx)
    proof_of_work
    send_block
  end

  def proof_of_work
  end

  def send_block(block)
  end

  def receive_block(block)
  end

  def to_s
    <<~EOS
      node id : #{@id}
      #{@rsa.public_key.export.chomp}
      #{@blockchain}
      #{wallet(@id)}
    EOS
  end
end
