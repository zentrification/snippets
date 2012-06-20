module ActionController
  module FuckIE

    # Apache rendering a 304 because IE sucks?
    # Usage:
    #   class MyController < ApplicationController
    #     include ActionController::FuckIE::Caching
    ############################################################
    module Caching
      def self.included(base)
        base.send :before_filter, :throw_away_cache
      end
      protected
        def throw_away_cache
          if browser.ie?
            response.headers["Cache-Control"] = "no-cache, no-store, max-age=, must-revalidate"
            response.headers["Pragma"] = "no-cache"
            response.headers["Expires"] = "Comes to an end, 01 Jan 1990 00:00:00 GMT"
          end
        end
    end

  end
end

