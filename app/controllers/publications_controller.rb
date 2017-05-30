class PublicationsController < ApplicationController
  def index
  	@company = Company.find params[:company_id]
    @presented_company = present @company
    @publications = @company.publications.page(params[:page]).order(created_at: :desc).per(10)
  end

  def new
    @publication = Publication.new company_name: params[:company_name]
  end
  def publication_redirect_path
    if @publication.company
      company_path(@publication.company)
    else
      @publication
    end
  end

  def publication_params
    params.require(:publication).permit(:link, :title, :head,
                                   :annotation, :date_of_publication)
  end
end
