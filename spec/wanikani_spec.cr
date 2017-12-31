require "./spec_helper"

describe Wanikani::API do
  it "checks API compiles" do
    # Just check that it compiles
    typeof(begin
      api = Wanikani::API.new "some_api_key"
      api.user_information
      api.study_queue
      api.level_progression
      api.srs_distribution
      api.recent_unlocks
      api.critical_items
      api.radicals
      api.radicals(level: 1)
      api.radicals(level: "1,2")
      api.kanji
      api.kanji(level: 1)
      api.kanji(level: "1,2")
      api.vocabulary
      api.vocabulary(level: 1)
      api.vocabulary(level: "1,2")
    end)
  end
end
