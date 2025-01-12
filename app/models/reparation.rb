class Reparation < ApplicationRecord
  belongs_to :vehicle

  validates :vehicle_id,
            numericality: {only_integer: true},
            presence: true

  validates :entry_day,
            :exit_day,
            presence: true

end
