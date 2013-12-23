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

      def grab_events
        raise NotImplementedError, 'This is the responsibility of a subclass'
      end

      def events
        events = grab_events || []
        save_etag
        events
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

    # make sure not to return events that we've already seen
    class UniqueEvents < Events
      def events
        remove_old_events(super)
      end

      def remove_old_events(events)
        events = reject_old_events(events)
        save_last_id(events)
      end

      def save_last_id(events)
        events.sort_by! { |event| event['id'].to_i }
        if last = events.last
          @last_id_seen = last['id'].to_i
        end
        events
      end

      def reject_old_events(events)
        return events if @last_id_seen.nil?

        events.reject do |event|
          event['id'].to_i < @last_id_seen
        end
      end
    end


    class OrgEvents < UniqueEvents
      def initialize(organization, octokit = mil)
        set_octokit(octokit)
        @organization = organization
      end

      def grab_events
        @octokit.organization_events(@organization, headers)
      end
      alias_method :organization_events, :events
    end


    class UserEvents < UniqueEvents
      def initialize(username, octokit = mil)
        set_octokit(octokit)
        @username = username
      end

      def grab_events
        events = @octokit.user_events(@username, headers)
        save_etag
        events || []
      end
      alias_method :user_events, :events
    end
  end
end
