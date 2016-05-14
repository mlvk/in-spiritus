class DocumentsController < ApplicationJsonApiResourcesController
  include AwsUtils
  include PdfUtils

  def generate_packing_documents
    authorize :documents, :generate_packing_documents?

    route_plans = RoutePlan.where(id: params['route_plans'])

    url = generate_and_upload_route_plans_pdf route_plans

    render json: {url:url}
  end
end
