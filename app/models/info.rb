class Info < ApplicationRecord
  REPONSE = ["Oui", "Non"]
  validates :work, presence: true
  validates :unemployment, presence: true
  validates :days_unemployment, presence: true, if: :unemployment_true?
  validate :unemployment_max_min
  has_one :document
  has_many :jobs

  def unemployment_max_min
    if days_unemployment.present? && unemployment == "Oui" && (days_unemployment > 730 || days_unemployment < 182) 
      errors.add(:days_unemployment, "doit être comprise entre 182 et 730 jours")
    end
  end

  def unemployment_true?
    unemployment == "Oui"
  end
end