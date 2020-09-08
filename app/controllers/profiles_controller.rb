class ProfilesController < ApplicationController

  def show
    @profile = Profile.find(params[:id])
  end

  def new
    @profile = Profile.new
  end


 def create
    @profile = Profile.new(params_profile)
    if @profile.save
      if @profile.profile_type == Profile::PROFILE_TYPE[1]
        redirect_to new_document_path(@document)
      else
        redirect_to error_path
      end
    else
      render(:new)
    end
  end

  def error
  end

  private
  def params_profile
    params.require(:profile).permit(:profile_type)
  end
end
