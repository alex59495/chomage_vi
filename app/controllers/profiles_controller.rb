class ProfilesController < ApplicationController

  def new
    @profile = Profile.new
  end

  def create
    if params_profile.include?("Je travaillais")
      redirect_to new_document_path
    else
      redirect_to error_path
    end
  end

  def error
  end

  private

  # array of the check_boxes selected for the profile
  def params_profile
    params.require(:profile).require(:profile_type)
  end
end
