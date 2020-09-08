class Profile < ApplicationRecord
  PROFILE_TYPE = ["J'étais étudiant(e)", "Je travaillais", "J'étais au chômage"]
  validates :profile_type, presence: true
end
