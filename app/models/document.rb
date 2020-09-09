class Document < ApplicationRecord
  WORK_TYPE = ['VIE - Volontariat International en Entreprise', 'VIA - Volontariat International en Administration']
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :company, presence: true
  validates :work, presence: true
  validates :work_type, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :old_company, presence: true
  validates :old_work, presence: true
  validates :old_start_date, presence: true
  validates :old_end_date, presence: true
  validate :start_date_cannot_be_in_the_future
  validate :end_date_cannot_be_in_before_start_date
  validate :old_end_date_cannot_be_in_after_start_date
  validate :end_date_cannot_be_too_big
  belongs_to :info_preliminaire

  def start_date_cannot_be_in_the_future
    if start_date > Date.today
      errors.add(:start_date, "can't be in the future")
    end
    if old_start_date > Date.today
      errors.add(:old_start_date, "can't be in the future")
    end
    if chomage_start_date > Date.today
      errors.add(:chomage_start_date, "can't be in the future")
    end
  end

  def end_date_cannot_be_in_before_start_date
    if end_date < start_date
      errors.add(:end_date, "can't be before the start date")
    end
    if old_end_date < old_start_date
      errors.add(:old_end_date, "can't be before the start date")
    end
  end

  def old_end_date_cannot_be_in_after_start_date
    if old_end_date > start_date
      errors.add(:old_end_date, "can't be after the starting VI date")
    end
  end

  def end_date_cannot_be_too_big
    if end_date - old_end_date > 1080
      errors.add(:old_end_date, "is too far away")
    end
    if Date.today - end_date > 360
      errors.add(:end_date, "is too far away")
    end
  end

end
