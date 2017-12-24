class Block
  attr_reader :transactions

  def self.create_genesis_block
    Block.new(timestamp: Time.utc(1990,6,5), transactions: [Transaction.create_genesis_transaction])
  end

  def self.create_block
    Block.new(timestamp: Time.utc(1990,6,5), transactions: [Transaction.create_genesis_transaction])
  end

  def initialize(args)
    @timestamp = args[:timestamp]
    @transactions = args[:transactions]
    @hash = args[:hash]
    @previous_hash = args[:previous_hash]
  end

  def get_all_transaction_to(id)
    @transactions.select do |tx|
      tx.transaction_to? id
    end
  end

  def used_as_input?(hash)
    @transactions.each do |tx|
      return true if tx.used_as_input?(hash) == true
    end
    false
  end

  def to_s
    <<~EOS.chomp
      timestamp : #{@timestamp}
      transactions : #{@transactions}
      hash : #{@hash}
      previous_hash : #{@previous_hash}
    EOS
  end
end

class CurrentBlock < Block

  def add_transaction(tx)
    @transactions << tx
    @hash.update(tx.to_s)
  end

  def add_transaction(tx)
    @transactions.length
  end
end
