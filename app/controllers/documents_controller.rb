class DocumentsController < ApplicationController
  
  def show
    @document = Document.find(params[:id])
    @duration = (@document.end_date - @document.start_date).to_i/30
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(params_document)
    if @document.save
      redirect_to document_path(@document)
    else
      render(:new)
    end
  end

  private
  def params_document
    params.require(:document).permit(:first_name, :last_name,
    :company, :work, :work_type, :start_date, :end_date, :old_work,
    :old_company, :old_start_date, :old_end_date)
  end
end
