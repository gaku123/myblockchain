class Transaction

  def self.create_genesis_transaction
    inputs = [Input.new(coinbase: "my blockchain")]
    outputs = [Output.new(to: 0, coin_value: 1000)]
    new(inputs: inputs, outputs: outputs)
  end

  def initialize(args)
    @inputs = args[:inputs]
    @outputs = args[:outputs]
    @previous_hash = args[:previous_hash]
    @hash = args[:hash]
    @sign = args[:sign]
  end

  def transaction_to?(id)
    @outputs.each do |output|
      return true if output.to == id
    end
    return false
  end

  def to_s
    <<~EOS
      inputs : #{@inputs}
      outputs : #{@outputs}
    EOS
  end

  private 

  class Input

    def initialize(args)
      @coinbase = args[:coinbase]
    end

  end

  class Output
  attr_reader :to

    def initialize(args)
      @to = args[:to]
      @coin_value = args[:coin_value]
    end

  end
end
