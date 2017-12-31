module Wanikani
  class UserInformation
    JSON.mapping(
      username: String,
      gravatar: String?,
      level: Int32,
      title: String,
      about: String,
      website: String?,
      twitter: String?,
      topics_count: Int32,
      posts_count: Int32,
      creation_date: {type: Time, converter: Time::EpochConverter},
      vacation_date: {type: Time?, converter: NilEpochConverter},
    )
  end

  class StudyQueue
    JSON.mapping(
      lessons_available: Int32,
      reviews_available: Int32,
      next_review_date: {type: Time, converter: Time::EpochConverter},
      reviews_available_next_hour: Int32,
      reviews_available_next_day: Int32,
    )
  end

  class LevelProgression
    JSON.mapping(
      radicals_progress: Int32,
      radicals_total: Int32,
      kanji_progress: Int32,
      kanji_total: Int32,
    )
  end

  class SrsDistribution
    JSON.mapping(
      radicals: Int32,
      kanji: Int32,
      vocabulary: Int32,
      total: Int32,
    )
  end

  class RecentUnlock
    JSON.mapping(
      type: String,
      character: String,
      kana: String,
      meaning: String,
      level: Int32,
      unlocked_date: {type: Time, converter: Time::EpochConverter},
    )
  end

  class CriticalItem
    JSON.mapping(
      type: String,
      character: String,
      kana: String,
      meaning: String,
      level: Int32,
      percentage: {type: Int32, converter: StringToInt32Converter},
    )
  end

  class Radical
    JSON.mapping(
      level: Int32,
      character: String?,
      meaning: String,
      image_file_name: String?,
      image_content_type: String?,
      image_file_size: Int32?,
      user_specific: UserSpecific?,
    )
  end

  class Kanji
    JSON.mapping(
      level: Int32,
      character: String,
      meaning: String,
      onyomi: String?,
      kunyomi: String?,
      important_reading: String,
      nanori: String?,
      user_specific: UserSpecific?,
    )
  end

  class Vocabulary
    JSON.mapping(
      level: Int32,
      character: String,
      kana: String,
      meaning: String,
      user_specific: UserSpecific?,
    )
  end

  class UserSpecific
    JSON.mapping(
      srs: String,
      srs_numeric: Int32,
      unlocked_date: {type: Time?, converter: NilEpochConverter},
      available_date: {type: Time?, converter: NilEpochConverter},
      burned: Bool,
      burned_date: {type: Time?, converter: NilEpochConverter},
      meaning_correct: Int32?,
      meaning_incorrect: Int32?,
      meaning_max_streak: Int32?,
      meaning_current_streak: Int32?,
      reading_correct: Int32?,
      reading_incorrect: Int32?,
      reading_max_streak: Int32?,
      reading_current_streak: Int32?,
      meaning_note: String?,
      reading_note: String?,
      user_synonyms: String?,
    )
  end

  # :nodoc:
  module NilEpochConverter
    def self.from_json(value : JSON::PullParser) : Time?
      value.read_null_or do
        seconds = value.read_int
        seconds == 0 ? nil : Time.epoch(seconds)
      end
    end
  end

  # :nodoc:
  module StringToInt32Converter
    def self.from_json(value : JSON::PullParser) : Int32
      value.read_string.to_i
    end
  end
end
