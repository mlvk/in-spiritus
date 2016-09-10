class RoutingController < ApplicationJsonApiResourcesController
  def optimize_route
    authorize :routing

    route_plan_id = params['id']
    request_data = prepare_request_data route_plan_id
    respone_data = send_routific_request request_data

    render json: respone_data
  end

  private
  def prepare_request_data route_plan_id
    request_data = {
                    :network => {
                      :headquarters => {
                        :lat => 34.1693692,
                        :lng => -118.3149415,
                        :name => 'Vegan Kitchen',
                      }
                    },
                    :visits => {},
                    :solution => {
                      :driver => []
                    },
                    :fleet => {
                      :driver => {
                        "start-location" => 'headquarters',
                        "end-location" => 'headquarters'
                      }
                    }
                  }

    # Get route plan data
    route_plan = RoutePlan
                  .includes(:route_visits)
                  .find(route_plan_id)


    # Get visits of current route plan
    route_plan
      .route_visits
      .order('position')
      .each do |route_visit|
        id = route_visit.id.to_s
        lat = route_visit.address.lat
        lng = route_visit.address.lng
        name = route_visit.address.street_and_city

        visit_windows = route_visit.visit_windows || OpenStruct.new({
                                                        :min_formated => '06:00',
                                                        :max_formated => '22:00',
                                                        :service => 15
                                                      })
        start_time = visit_windows.min_formated
        end_time = visit_windows.max_formated
        duration = visit_windows.service

        request_data[:network][id] = {
          :lat => lat,
          :lng => lng,
          :name => name
        }
        request_data[:visits][id] = {
          :start => start_time,
          :end => end_time,
          :duration => duration
        }
        request_data[:solution][:driver].push(id)
    end
    request_data
  end

  def send_routific_request data
    token = ENV['ROUTIFIC_API_KEY']
    uri = URI.parse("https://api.routific.com/min-idle")
    header = {
      'Content-Type': 'application/json',
      'Authorization': "bearer #{token}"
    }

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = JSON.generate(data)

    # Send the request
    response = http.request(request)

    JSON.parse(response.body)
  end
end
