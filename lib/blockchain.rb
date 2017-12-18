class Blockchain
  def initialize
    @blockchain = [Block.create_genesis_block]
  end

  def get_all_transaction_to(id)
    txs = Array.new
    @blockchain.each do |block|
      tx = block.get_all_transaction_to id
      txs << tx unless txs.nil?
    end
    txs.flatten
  end

  def to_s
    string = ""
    @blockchain.each do |block|
      string += block.to_s
    end
    string
  end

end
