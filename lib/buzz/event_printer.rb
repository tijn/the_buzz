# :id, :type, :actor, :repo, :payload, :public, :created_at, :org

class EventPrinter
  attr_reader :event

  def self.event_to_s(event)
    new(event).to_s
  end

  def initialize(event)
    @event = event
  end

  def to_s
    case @event['type']
    # when 'CommitCommentEvent'
    when 'CreateEvent'
      case ref_type
      when "branch"
        "#{actor_name} created a branch \"#{ref}\" on #{repo_name}"
      when "tag"
        "#{actor_name} tagged \"#{ref}\" on #{repo_name}"
      when "repository"
        "#{actor_name} created a new repository \"#{repo_name}\""
      else
        "#{actor_name} created a new #{ref_type}"
      end

    # when 'DeleteEvent'

    # when 'DownloadEvent'

    # when 'FollowEvent'

    when 'ForkEvent'
      "#{actor_name} forked #{repo_name}"

    # when 'ForkApplyEvent'

    # when 'GistEvent'

    # when 'GollumEvent'

    when 'IssueCommentEvent'
      "#{actor_name} commented on issue #{issue} on #{repo_name}"

    when 'IssuesEvent'
      "#{actor_name} #{action} issue #{issue} on #{repo_name}"

    # when 'MemberEvent'

    # when 'PublicEvent'

    # when 'PullRequestEvent'

    # when 'PullRequestReviewCommentEvent'

    when 'PushEvent'
      "#{actor_name} pushed to #{repo_name}"
      # TODO: show commits

    # when 'ReleaseEvent'

    # when 'StatusEvent'

    # when 'TeamAddEvent'

    # when 'WatchEvent'

    else
      @event.type.to_s
      # raise "I don't support #{@event.type} yet"
    end
  end

  def actor_name
    @event['actor']['login']
  end

  def repo_name
    @event['repo']['name']
  end

  def action
    @event['payload']['action']
  end

  def ref_type
    @event['payload']['ref_type']
  end

  def ref
    @event['payload']['ref']
  end


  def issue
    "\##{issue_number} \"#{issue_text}\""
  end

  def issue_number
    @event['payload']['issue']['number']
  end

  def issue_text
    @event['payload']['issue']['title']
  end
end
