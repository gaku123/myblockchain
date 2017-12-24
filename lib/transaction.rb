class Transaction
  attr_reader :hash

  def self.create_genesis_transaction
    inputs = [Input.new(coinbase: "my blockchain")]
    outputs = [Output.new(to: "0", coin_value: "1000")]
    new(inputs: inputs, outputs: outputs)
  end

  def self.create_transaction(hashs, to_and_coin_values)
    outputs = Array.new
    to_and_coin_values.each do |to_and_cv|
      outputs << Output.new(to: to_and_cv[:to], coin_value: to_and_cv[:coin_value])
    end
    inputs = Array.new
    hashs.each do |hash|
      inputs << Input.new(hash: hash)
    end
    new(inputs: inputs, outputs: outputs)
  end

  def initialize(args)
    @inputs = args[:inputs]
    @outputs = args[:outputs]

    digest = OpenSSL::Digest.new('sha256')
    @inputs.each do |input|
      digest.update(input.to_s)
    end
    @outputs.each do |output|
      digest.update(output.to_s)
    end
    @hash = digest.hexdigest()
    @sign = args[:sign]
  end

  def transaction_to?(id)
    @outputs.each do |output|
      return true if output.to == id
    end
    return false
  end

  def sum_of_coin_to(id)
    sum = 0
    @outputs.each do |output|
      sum += output.coin_value.to_i if output.to == id
    end
    sum
  end

  def used_as_input?(hash)
    @inputs.each do |input|
      return true if input.hash == hash
    end
    false
  end

  def to_s
    <<~EOS
      inputs : #{@inputs.to_s}
      outputs : #{@outputs.to_s}
    EOS
  end

  private 

  class Input

    def initialize(args)
      @coinbase = args[:coinbase]
      @hash = args[:hash]
    end

    def to_s
      string = ""
      string += @coinbase unless @coinbase.nil?
      string += @hash unless @hash.nil?
      string
    end

  end

  class Output
  attr_reader :to, :coin_value

    def initialize(args)
      @to = args[:to]
      @coin_value = args[:coin_value]
    end

    def to_s
      string = ""
      string += @to unless @to.nil?
      string += @coin_value unless @coin_value.nil?
      string
    end

  end
end
