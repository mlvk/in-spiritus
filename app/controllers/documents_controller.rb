class DocumentsController < ApplicationJsonApiResourcesController
  include AwsUtils
  include PdfUtils

  def generate_packing_documents
    authorize :documents, :generate_packing_documents?

    route_plans = RoutePlan
      .where(id: params['route_plans'])

    pdf_url = RoutePlanUtils.new.generate_and_upload_packing_documents route_plans

    p "pdf_url"

    render json: {url:pdf_url}
  end
end
