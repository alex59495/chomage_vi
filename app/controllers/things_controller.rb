class ThingsController < ApplicationController
  def show
    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: 'mon_doc',
          enable_local_file_access: true,
          encoding: 'utf8',
          template: 'ppsps/show.pdf.erb',
          layout: 'pdf.html.erb'
        )  # Excluding ".pdf" extension.
      end
    end
  end
end