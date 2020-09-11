class JobsController < ApplicationController

  def create
    @job = Job.new(params_job)
    @info = Info.find(params[:info_id])
    @job.info_id = params[:info_id]
    if @job.save
      redirect_to new_info_document_path(params[:info_id])
    else
      respond_to do |format|
        format.js { render 'documents/modal_job' }
      end
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @info = Info.find(params[:info_id])
    @job.destroy
    redirect_to new_info_document_path(params[:info_id])
  end

  private

  def params_job
    params.require(:job).permit(:company, :work, :start_at, :end_at)
  end

end
