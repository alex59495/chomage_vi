class DocumentJob < ApplicationRecord
  belongs_to :document
  belongs_to :job
end
