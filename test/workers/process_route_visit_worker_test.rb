require 'test_helper'

class ProcessRouteVisitWorkerTest < ActiveSupport::TestCase

  test "Should generate notifications of fulfillments" do
    route_visit = create(:route_visit_with_fulfilled_fulfillments, :fulfilled)

    aws_props = {
      pdf_url: "https://#{ENV['PDF_BUCKET']}.s3.amazonaws.com/#{route_visit.fulfillments.first.id}.pdf"
    }

    firebase_props = {
      firebase_url: ENV['FIREBASE_URL']
    }

    google_props = {
      api_key: ENV['GOOGLE_API_KEY']
    }

    VCR.use_cassette('mail_gun/001') do
      VCR.use_cassette('slack/001') do
        VCR.use_cassette('aws/put_pdf', erb: aws_props) do
            VCR.use_cassette('google/url_shortener/001', erb:google_props) do
              VCR.use_cassette('firebase/001', erb:firebase_props, allow_playback_repeats:true) do

              ProcessRouteVisitWorker.new.perform
            end
          end
        end
      end
    end

    assert_equal(route_visit.fulfillments.first.notifications.pending.count, 1)
  end
end
