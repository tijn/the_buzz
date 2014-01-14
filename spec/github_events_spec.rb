require "spec_helper"


describe Buzz::GitHub::OrgEvents do
  context "just one peek at the current state of affairs" do
    let(:github)  { Buzz::GitHub::UserEvents.new('github') }

    it "should find the latest commits" do
      VCR.use_cassette('github') do
        github.events.should_not be_empty
      end
    end
  end
end


describe Buzz::GitHub::UserEvents do

  context "just one peek at the current state of affairs" do
    let(:tijn)  { Buzz::GitHub::UserEvents.new('tijn') }

    it "should find the latest commits" do
      VCR.use_cassette('tijn') do
        tijn.events.should_not be_empty
      end
    end

  end


  context "multiple requests" do
    let(:linus) { Buzz::GitHub::UserEvents.new('torvalds') }

    before do
      VCR.use_cassette('torvalds') do
        @events = linus.events
        @more_events = linus.events
      end
    end

    it "should find some commits" do
      @events.should_not be_empty
    end

    it "should not find more commits" do
      # because the time between the first and second request is too short
      @more_events.should be_empty
    end
  end

end
