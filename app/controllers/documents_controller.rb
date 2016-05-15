class DocumentsController < ApplicationJsonApiResourcesController
  include AwsUtils
  include PdfUtils

  def generate_packing_documents
    authorize :documents, :generate_packing_documents?

    records = RoutePlan
      .where(id: params['route_plans'])
      .flat_map(&method(:build_route_plan))

    pdf_url = generate_and_upload_pdfs records

    render json: {url:pdf_url}
  end

  private
  def build_route_plan route_plan
    [route_plan]
      .concat route_plan.route_visits
			.sort {|x,y| y.position <=> x.position}
			.flat_map(&:fulfillments)
      .flat_map(&:order)
      .select(&:has_quantity?)
  end
end
