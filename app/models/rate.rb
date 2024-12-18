class Rate < ApplicationRecord
    belongs_to :season

    validates :car_type, :value_per_day, :season_id, presence: true
        
end
