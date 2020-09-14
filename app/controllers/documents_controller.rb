class DocumentsController < ApplicationController

  def show
    @document = Document.find(params[:id])
    @info = Info.find(params[:info_id])
    @days_worked = (@document.old_end_date - @document.verify_start_date).to_i - @document.latency
    if @document.start_unemployment_at
      unemployment_calc(@document.start_date, @document.start_unemployment_at)
    elsif @document.info.jobs.present?
      @days_worked += @document.days_worked_other_jobs_calc
      @document.recalculate_jobs
    end
    @duration = (@document.end_date - @document.start_date)/30
    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: 'document',
          enable_local_file_access: true,
          encoding: 'utf8',
          template: 'documents/show.pdf.erb',
          layout: 'pdf.html.erb'
        )  # Excluding ".pdf" extension.
      end
    end
  end

  def new
    @info = Info.find(params[:info_id])
    @job = Job.new
    @document = Document.new
  end

  def create
    @document = Document.new(params_document)
    @info = Info.find(params[:info_id])
    @job = Job.new
    @document.info_id = params[:info_id]
    if @document.save
      redirect_to info_document_path(@info, @document, format: :pdf)
    else
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
