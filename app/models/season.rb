class Season < ApplicationRecord
    has_many :rates
  
    validates :season, presence: true
    validates :start_date, presence: true
    validates :end_date, presence: true
    validate :start_date_before_end_date
  
    private
  
    def start_date_before_end_date
      if start_date && end_date && start_date >= end_date
        errors.add(:end_date, "must be after the start date")
      end
    end
  end
  