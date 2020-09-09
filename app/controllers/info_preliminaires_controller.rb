class InfoPreliminairesController < ApplicationController
  def new
    @info_preliminaire = InfoPreliminaire.new
  end

  def create
    @info_preliminaire = InfoPreliminaire.new(params_info_preliminaire)
    if @info_preliminaire.save
      if (@info_preliminaire.chomage == "Oui" || @info_preliminaire.travail == "Oui")
        redirect_to new_document_path
      else
        redirect_to error_path
      end
    else
      redirect_to error_path
    end
  end

  def error
  end

  private

  def params_info_preliminaire
    params.require(:info_preliminaire).permit(:travail, :chomage)
  end
end
