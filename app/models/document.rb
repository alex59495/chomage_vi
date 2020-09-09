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

  def start_date_cannot_be_in_the_future
    if start_date.present? && start_date > Date.today 
      errors.add(:start_date, "ne peut pas être une date future")
    end
    if old_start_date.present? && old_start_date > Date.today
      errors.add(:old_start_date, "ne peut pas être une date future")
    end
  end

  def end_date_cannot_be_in_before_start_date
    if start_date.present? && end_date.present? && end_date < start_date
      errors.add(:end_date, "ne peut pas être avant la date de début du contrat")
    end
    if old_end_date.present? && old_start_date.present? && old_end_date < old_start_date
      errors.add(:old_end_date, "ne peut pas être avant la date de début du contrat")
    end
  end

  def old_end_date_cannot_be_in_after_start_date
    if old_end_date.present? && start_date.present? && old_end_date >= start_date
      errors.add(:old_end_date, "ne peut pas être après la date de début de V.I")
    end
    if old_start_date.present? && start_date.present? && old_start_date >= start_date
      errors.add(:old_start_date, "ne peut pas être après la date de début de V.I")
    end
  end

  def end_date_cannot_be_too_big
    if end_date.present? && old_end_date.present? && end_date - old_end_date > 1080
      errors.add(:old_end_date, "Tu ne peux pas ouvrir tes droits aux chômage après trois ans")
    end
    if end_date.present? && Date.today - end_date > 360
      errors.add(:end_date, "Tu ne peux pas ouvrir tes droits aux chômage plus d'un an après la fin de ton V.I")
    end
  end
end
