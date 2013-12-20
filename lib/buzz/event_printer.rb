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

    when 'CommitCommentEvent'
      "#{actor_name} commented on a commit"

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

    when 'DeleteEvent'
      "#{actor_name} deleted a tag or a branch. Thank you for keeping our repository clean #{actor_name}!"

    # when 'DownloadEvent'
      # doesn't apply anymore

    when 'FollowEvent'
      "#{actor_name} started following #{payload['target']['name']}"

    when 'ForkEvent'
      "#{actor_name} forked #{repo_name}"

    # when 'ForkApplyEvent'
      # doesn't apply anymore

    # when 'GistEvent'
      # doesn't apply anymore

    when 'GollumEvent'
      "#{actor_name} worked on a wiki-page"

    when 'IssueCommentEvent'
      "#{actor_name} commented on issue #{issue} on #{repo_name}"

    when 'IssuesEvent'
      "#{actor_name} #{action} issue #{issue} on #{repo_name}"

    when 'MemberEvent'
      "#{member_name} became a collaborator on #{repo_name}"

    when 'PublicEvent'
      "#{actor_name} open sourced #{repo_name}. Awesome!"

    when 'PullRequestEvent'
      "#{actor_name} #{action} a pull request"

    when 'PullRequestReviewCommentEvent'
      "#{actor_name} commented on a pull request"

    when 'PushEvent'
      "#{actor_name} pushed to #{repo_name}"
      # TODO: show commits

    when 'ReleaseEvent'
      "#{actor_name} released #{repo_name}: #{release_name}. Yeah! High five!"

    # when 'StatusEvent'
      # ?
      # I don't get this event

    when 'TeamAddEvent'
      # boh, not too interesting, is it?
      ""

    when 'WatchEvent'
      "#{actor_name} started watching #{repo_name}"

    else
      @event.type.to_s
      # raise "I don't support #{@event.type} yet"
    end
  end

  def payload
    @event.fetch('payload', {})
  end

  def actor_name
    @event['actor']['login']
  end

  def repo_name
    @event['repo']['name']
  end

  def release_name
    @event['repo']['release']['name']
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

  def member_name
    @event['payload']['member']['name']
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
