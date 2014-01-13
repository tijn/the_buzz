require 'buzz'

config_file = File.dirname(File.expand_path(__FILE__)) + '/../config/the_buzz.yml'
config = YAML::load(File.open(config_file))

# we will share the same octokit for multiple "clients"
# see https://github.com/octokit/octokit.rb#using-a-netrc-file
octokit = Octokit::Client.new(:netrc => true)
octokit.login
EVENT_TRACKERS = []

config.each do |entry|
  case entry.type
  when 'github-org'
    EVENT_TRACKERS << Buzz::GitHub::OrgEvents.new(entry.orgname, octokit)
  when 'github-user'
    EVENT_TRACKERS << Buzz::GitHub::UserEvents.new(entry.username, octokit)
  else
  # when 'gitorious'
  # when 'gitlab'
    raise NotImplementedError, "I have no support for #{entry.type} yet"
  end
end

def current_events
  events = EVENT_TRACKERS.inject([], :+) { |memo, tracker| memo + tracker.events }
  events.sort_by! { |event| event['id'].to_i }
  events
end

SCHEDULER.every('3m', first_in: '10s') do
  current_events.each do |event|
    send_event('the_buzz', { event: event })
  end
end
