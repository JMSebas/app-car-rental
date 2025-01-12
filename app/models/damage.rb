class Damage < ApplicationRecord
  belongs_to :rental
  validates :damage_type, presence: true
  validates :value, presence: true, numericality: true

end
