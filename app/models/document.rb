class Document < ApplicationRecord
  WORK_TYPE = ['VIE - Volontariat International en Entreprise', 'VIA - Volontariat International en Administration']
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :company, presence: true
  validates :work, presence: true
  validates :work_type, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :old_company, presence: true, unless: :unemployment?
  validates :old_work, presence: true, unless: :unemployment?
  validates :old_start_date, presence: true, unless: :unemployment?
  validates :old_end_date, presence: true, unless: :unemployment?
  validates :unemployment, presence: true
  validates :start_unemployment_at, presence: true, if: :unemployment?
  validate :start_date_cannot_be_in_the_future
  validate :end_date_cannot_be_before_start_date
  validate :old_end_date_cannot_be_after_start_date
  validate :end_date_cannot_be_too_big
  validate :start_unemployment_at_cannot_be_after_start_date
  # validate :start_unemployment_at_cannot_be_before_old_end_date, if: :unemployment?
  validate :jobs_validation
  belongs_to :info

  def unemployment?
    unemployment == true
  end

  def start_date_cannot_be_in_the_future
    if start_date.present? && start_date > Date.today 
      errors.add(:start_date, "ne peut pas être une date future")
    end
    if old_start_date.present? && old_start_date > Date.today
      errors.add(:old_start_date, "ne peut pas être une date future")
    end
    if start_unemployment_at.present? && start_unemployment_at > Date.today 
      errors.add(:start_unemployment_at, "ne peut pas être une date future")
    end
    if old_end_date.present? && old_end_date > Date.today 
      errors.add(:old_end_date, "ne peut pas être une date future")
    end
  end

  def end_date_cannot_be_before_start_date
    if start_date.present? && end_date.present? && end_date < start_date
      errors.add(:end_date, "ne peut pas être avant la date de début du contrat")
    end
    if old_end_date.present? && old_start_date.present? && old_end_date < old_start_date
      errors.add(:old_end_date, "ne peut pas être avant la date de début du contrat")
    end
  end

  def old_end_date_cannot_be_after_start_date
    if old_end_date.present? && start_date.present? && old_end_date > start_date
      errors.add(:old_end_date, "ne peut pas être après la date de début de V.I")
    end
    if old_start_date.present? && start_date.present? && old_start_date > start_date
      errors.add(:old_start_date, "ne peut pas être après la date de début de V.I")
    end
  end

  def start_unemployment_at_cannot_be_after_start_date
    if start_unemployment_at.present? && start_unemployment_at >= start_date
      errors.add(:start_unemployment_at, "ne peut pas être égale ou après la date de début de V.I")
    end
  end

  # def start_unemployment_at_cannot_be_before_old_end_date
  #   if start_unemployment_at.present? && start_unemployment_at < old_end_date
  #     errors.add(:start_unemployment_at, "ne peut pas être avant la date de fin de dernier emploi")
  #   end
  # end

  def end_date_cannot_be_too_big
    if end_date.present? && old_end_date.present? && end_date - old_end_date > 1080
      errors.add(:old_end_date, "Tu ne peux pas ouvrir tes droits aux chômage après trois ans")
    end
    if end_date.present? && Date.today - end_date > 360
      errors.add(:end_date, "Tu ne peux pas ouvrir tes droits aux chômage plus d'un an après la fin de ton V.I")
    end
  end
  
  def days_worked_other_jobs_calc
    days_worked = 0
    info.jobs.each do |job|
      days_worked += (job.end_at - job.start_at).to_i
    end
    days_worked
  end

  def verify_start_date
    if old_start_date.present? && old_start_date < start_date.advance(days: -730 + self.latency)
      start_date.advance(days: -730 + self.latency)
    else
      old_start_date
    end
  end

  def latency
    if end_date < Date.today
      (Date.today - end_date).to_i
    else 
      0
    end
  end

  def jobs_validation
    if info.jobs.present? && info.document.start_date.present? && info.document.end_date.present?
      sort_jobs = info.jobs.order(:start_at)
      sort_jobs.to_a.each_with_index do |job, index|
        if (index < sort_jobs.length - 1 && job.end_at > sort_jobs[index + 1].start_at) || job.end_at > old_start_date
          errors.add(:old_end_date, "Il y a un problème au niveau des dates saisies pour les différents jobs.")
        end
      end
    end
  end

  def recalculate_jobs
    info.jobs.each do |job| 
      if job.start_at < start_date.advance(days: -730 + self.latency)
        job.start_at = start_date.advance(days: -730 + self.latency)
        job.save
        if job.start_at > job.end_at
          job.destroy
        end
      else
        job.start_at
      end
    end
  end
  
end
