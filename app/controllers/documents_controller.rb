class DocumentsController < ApplicationController
  def show
    @document = Document.find(params[:id])
    @info = Info.find(params[:info_id])    
    @days_worked = (@document.old_end_date - @document.verify_start_date).to_i unless @document.old_end_date.nil?
    if @document.start_unemployment_at
      unemployment_calc(@document.start_date, @document.start_unemployment_at)
    elsif @document.info.jobs.present?
      @days_worked += @document.days_worked_other_jobs_calc
      @document.recalculate_jobs
    end
    @duration = (@document.end_date - @document.start_date).to_i / 30
    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: 'document',
          enable_local_file_access: true,
          encoding: 'utf8',
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
    if @document.save
      # Si les jours restant sont négatifs, redirige vers la page d'erreur
      if @unemployment_days_remaining.present? && @unemployment_days_remaining.negative?
        redirect_to error_path(key: :not_anymore)
      # Si la personne a cumulé moins de 180 jours de travail sur les 2 dernières années elle n'a pas le droit au chômage
      elsif @days_worked.nil? || @days_worked >= 180
        redirect_to info_document_path(@info, @document, format: :pdf)
      else
        redirect_to error_path(key: :not_enough)
      end
    else
      flash.now.alert = 'Le formulaire a été mal rempli, merci de vérifier les infos.'
      render(:new)
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
