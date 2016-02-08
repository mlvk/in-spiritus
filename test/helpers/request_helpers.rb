module Helpers
  module RequestHelpers
    def prep_jr_headers
      @request.headers["Content-Type"] = JSONAPI::MEDIA_TYPE
    end
  end
end
