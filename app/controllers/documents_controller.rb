class DocumentsController < ApplicationController
  def show
    @document = Document.find(params[:id])
    @info = Info.find(params[:info_id])
    @days_worked = (@document.old_end_date - @document.verify_start_date).to_i unless @document.old_end_date.nil?
    if @document.start_unemployment_at
      unemployment_calc(@document.start_date, @document.start_unemployment_at)
    elsif @document.info.jobs.present?
      @days_worked += @document.days_worked_other_jobs_calc
      @days_worked = 730 if @days_worked > 730
      @document.recalculate_jobs
    end
    @duration = (@document.end_date - @document.start_date).to_i / 30
    respond_to do |format|
      format.pdf do
        render(
          pdf: 'document',
          enable_local_file_access: true,
          encoding: 'UTF-8',
          template: 'documents/show.pdf.erb',
          layout: 'pdf.html.erb',
          footer: {
            html: {
              template: 'documents/footer.html.erb'
            }
          },
          margin: {
            top: 16, # default 10 (mm)
            bottom: 16
          }
        )
      end
    end
  end

  def new
    @job = Job.new
    @info = Info.find(params[:info_id])
    @info.unemployment == "Oui" ? @document = Document.new(unemployment: true) : @document = Document.new(unemployment: false)
  end

  def create
    @document = Document.new(params_document)
    @info = Info.find(params[:info_id])
    @info.unemployment == "Oui" ? @document.unemployment = true : @document.unemployment = false
    @job = Job.new
    @document.info_id = params[:info_id]
    @days_worked = (@document.old_end_date - @document.verify_start_date).to_i unless @document.old_end_date.nil?
    @days_worked += @document.days_worked_other_jobs_calc if @document.info.jobs.present?
    unemployment_calc(@document.start_date, @document.start_unemployment_at) if @document.start_unemployment_at
    # Si le nombre de jours restant est négatif
    if @unemployment_days_remaining.present? && @unemployment_days_remaining.negative?
      redirect_to error_path(key: :not_anymore)
    # Si la personne n'a pas cotisé au moins 4 mois avant nov 2019 et/ou 6 mois après nov 2019 (+ 4 mois pour la période 1/8/2020 - 31/12/2020 avec le Covid)
    elsif ((@days_worked < 130 && @document.old_end_date < Date.parse('1/9/2019'))  || (@days_worked < 130 && @document.old_end_date.between?(Date.parse('1/8/2020'),Date.parse('31/12/2020'))) || @days_worked < 180 && @document.old_end_date.between?(Date.parse('1/8/2020'),Date.parse('31/12/2020')) == false && @document.old_end_date >= Date.parse('1/9/2019'))
      redirect_to error_path(key: :not_enough)
    else
      if @document.save        
        redirect_to info_document_path(@info, @document, format: :pdf)
      else
        flash.now.alert = 'Le formulaire a été mal rempli, merci de vérifier les infos.'
        render(:new)
      end
    end
  end
  
  private

  def unemployment_calc(start_date, start_unemployment_at)
    @unemployment_days_paid = (start_date - start_unemployment_at).to_i
    @unemployment_days_remaining = @info.days_unemployment - @unemployment_days_paid
  end

  def params_document
    params.require(:document).permit(:first_name, :last_name,
    :company, :work, :work_type, :start_date, :end_date, :old_work,
    :old_company, :old_start_date, :old_end_date, :start_unemployment_at)
  end

end
