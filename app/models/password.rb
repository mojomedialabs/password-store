require "openssl"

class Password < ActiveRecord::Base
  attr_accessor :key, :plain_text

  #belongs_to :user
  #has_paper_trail

  after_initialize :initialize_key
  before_create :create_iv
  #before_save :encrypt

  validates :name,
    :presence => true

  validates :plain_text,
    :confirmation => true

  def initialize_key
    self.key = File.read(Rails.root.join("config/key"))
  end

  def create_iv
    cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")

    self.iv = cipher.random_iv
  end

  def encrypt
    if self.key.blank?
      self.initalize_key
    end

    if self.iv.blank?
      self.create_iv
    end

    #unless self.key.blank? or self.iv.blank? or self.plain_text.blank?
    #if !self.key.blank? and !self.iv.blank? and !self.plain_text.blank?
    if plain_text.present?
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
    unless self.key.blank? or self.iv.blank? or self.cipher_text.blank?
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

  def self.search(search)
    if search
      where("name LIKE :search OR url LIKE :search", { :search => "%#{search}%" })
    else
      scoped
    end
  end
end
