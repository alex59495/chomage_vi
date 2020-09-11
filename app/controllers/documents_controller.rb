class DocumentsController < ApplicationController

  def show
    @document = Document.find(params[:id])
    @duration = (@document.end_date - @document.start_date).to_i/30
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
      redirect_to document_path(@document, format: :pdf)
    else
      render(:new)
    end
  end

  private
  def params_document
    params.require(:document).permit(:first_name, :last_name,
    :company, :work, :work_type, :start_date, :end_date, :old_work,
    :old_company, :old_start_date, :old_end_date, :start_employment_at)
  end
end
