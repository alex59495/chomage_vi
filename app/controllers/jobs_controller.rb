class JobsController < ApplicationController

  def create
    @job = Job.new(params_job)
    @info = Info.find(params[:info_id])
    @job.info_id = params[:info_id]
    respond_to do |format|
      if @job.save
        # Respond with the view jobs/create.js.erb to close the modal and come back to the form
        format.js {}
      else
        format.js { render 'documents/modal_job' }
      end
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @info = Info.find(params[:info_id])
    @job.destroy
    respond_to do |format|
      format.js { render 'jobs/create'}
    end
  end

  private

  def params_job
    params.require(:job).permit(:company, :work, :start_at, :end_at)
  end

end
