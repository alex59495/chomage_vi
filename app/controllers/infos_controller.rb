class InfosController < ApplicationController
  def new
    @info = Info.new
  end

  def create
    @info = Info.new(params_info)
    if @info.save
      if @info.work == "Oui"
        redirect_to new_info_document_path(@info)
      else
        redirect_to error_path
      end
    else
      flash[:alert] = 'Le formulaire a été mal rempli, merci de vérifier les infos.'
      render(:new)
    end
  end

  def error
  end

  private

  def params_info
    params.require(:info).permit(:work, :unemployment, :days_unemployment)
  end
end
