class Block

  def self.create_genesis_block
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

  def to_s
    <<~EOS.chomp
      timestamp : #{@timestamp}
      transactions : #{@transactions}
      hash : #{@hash}
      previous_hash : #{@previous_hash}
    EOS
  end

end
