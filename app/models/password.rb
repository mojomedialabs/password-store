require "openssl"

class Password < ActiveRecord::Base
  attr_accessor :cipher, :key, :plain_text

  after_initialize :initialize_cipher
  before_create :create_iv

  def initialize_cipher
    #self.cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")

    self.key = File.read(Rails.root.join("config/key"))
  end

  def create_iv
    cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")

    self.iv = cipher.random_iv
  end

  def encrypt
    unless self.key.blank?
      cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")

      cipher.encrypt

      cipher.key = self.key

      cipher.iv = self.iv

      ct = cipher.update(self.plain_text)

      ct << cipher.final

      self.cipher_text = ct.clone
    else
      ""
    end
  end

  def decrypt
    if !self.key.blank? and !self.iv.blank? and !self.cipher_text.blank?
      cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")

      cipher.decrypt

      cipher.key = self.key

      cipher.iv = self.iv

      pt = cipher.update(self.cipher_text)

      pt << cipher.final

      self.plain_text = pt.clone
    else
      ""
    end
  end
end
