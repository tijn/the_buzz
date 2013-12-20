require 'octokit'

module Buzz
  module GitHub


    # this class basically exists as a Base class that keeps track of the etag for you
    class Events

      def initialize
        raise "This is a base class; please don't try to instantiate it."
      end

      def set_octokit(octokit = mil)
        if octokit
          @octokit = octokit
        else
          @octokit = Octokit::Client.new :netrc => true
          @octokit.login
        end
      end

      def save_etag
        if @octokit.last_response.status == 200
          @etag = @octokit.last_response.headers['etag']
        end
      end

      def headers
        if @etag
          { :headers => { 'If-None-Match' => @etag } }
        else
          {}
        end
      end
    end


    class OrgEvents < Events
      def initialize(organization, octokit = mil)
        set_octokit(octokit)
        @organization = organization
      end

      def organization_events
        events = @octokit.organization_events(@organization, headers)
        save_etag
        events || []
      end
      alias_method :events, :organization_events
    end


    class UserEvents < Events
      def initialize(username, octokit = mil)
        set_octokit(octokit)
        @username = username
      end

      def user_events
        events = @octokit.user_events(@username, headers)
        save_etag
        events || []
      end
      alias_method :events, :user_events
    end
  end
end
