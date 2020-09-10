class InfoPreliminaire < ApplicationRecord
  REPONSE = ["Oui", "Non"]
  validates :chomage, :travail, presence: true
  has_one :document
end
