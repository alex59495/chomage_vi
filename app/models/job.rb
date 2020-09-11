class Job < ApplicationRecord
  belongs_to :info
  validates :company, presence: true
  validates :work, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :start_at_cannot_be_in_the_future
  
  def start_at_cannot_be_in_the_future
    if start_at.present? && start_at > Date.today 
      errors.add(:start_at, "ne peut pas être une date future")
    end
  end

  def end_at_cannot_be_before_start_at
    if start_at.present? && end_at.present? && end_at < start_at
      errors.add(:end_at, "ne peut pas être avant la date de début du contrat")
    end
  end

end
