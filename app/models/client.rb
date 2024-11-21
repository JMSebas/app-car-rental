# app/models/client.rb
class Client < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :phone, allow_blank: true, format: { with: /\A\d{3}-\d{3}-\d{4}\z/, message: "must be in the format xxx-xxx-xxxx" }

  enum role: { client: 0, administrator: 1, employee: 2 }, _default: :client


  has_many :reservations
  has_many :rentals
  has_many :invoices

  def full_name
    "#{name} #{lastname}"
  end
end
  