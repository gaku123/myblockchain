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
    @blockchain.get_all_transaction_to(id)
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
