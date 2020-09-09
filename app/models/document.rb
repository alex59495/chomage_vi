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
end
