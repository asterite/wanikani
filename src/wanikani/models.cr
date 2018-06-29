module Wanikani
  class UserInformation
    include JSON::Serializable

    property username : String
    property gravatar : String?
    property level : Int32
    property title : String
    property about : String
    property website : String?
    property twitter : String?
    property topics_count : Int32
    property posts_count : Int32

    @[JSON::Field(converter: Time::EpochConverter)]
    property creation_date : Time

    @[JSON::Field(converter: ::Wanikani::NilEpochConverter)]
    property vacation_date : Time?
  end

  class StudyQueue
    include JSON::Serializable

    property lessons_available : Int32
    property reviews_available : Int32

    @[JSON::Field(converter: Time::EpochConverter)]
    property next_review_date : Time

    property reviews_available_next_hour : Int32
    property reviews_available_next_day : Int32
  end

  class LevelProgression
    include JSON::Serializable

    property radicals_progress : Int32
    property radicals_total : Int32
    property kanji_progress : Int32
    property kanji_total : Int32
  end

  class SrsDistribution
    include JSON::Serializable

    property radicals : Int32
    property kanji : Int32
    property vocabulary : Int32
    property total : Int32
  end

  class RecentUnlock
    include JSON::Serializable

    property type : String
    property character : String
    property kana : String
    property meaning : String
    property level : Int32

    @[JSON::Field(converter: Time::EpochConverter)]
    property unlocked_date : Time
  end

  class CriticalItem
    include JSON::Serializable

    property type : String
    property character : String
    property kana : String
    property meaning : String
    property level : Int32

    @[JSON::Field(converter: ::Wanikani::StringToInt32Converter)]
    property percentage : Int32
  end

  class Radical
    include JSON::Serializable

    property level : Int32
    property character : String?
    property meaning : String
    property image_file_name : String?
    property image_content_type : String?
    property image_file_size : Int32?
    property user_specific : UserSpecific?
  end

  class Kanji
    include JSON::Serializable

    property level : Int32
    property character : String
    property meaning : String
    property onyomi : String?
    property kunyomi : String?
    property important_reading : String
    property nanori : String?
    property user_specific : UserSpecific?
  end

  class Vocabulary
    include JSON::Serializable

    property level : Int32
    property character : String
    property kana : String
    property meaning : String
    property user_specific : UserSpecific?
  end

  class UserSpecific
    include JSON::Serializable

    property srs : String
    property srs_numeric : Int32

    @[JSON::Field(converter: ::Wanikani::NilEpochConverter)]
    property unlocked_date : Time?

    @[JSON::Field(converter: ::Wanikani::NilEpochConverter)]
    property available_date : Time?

    property burned : Bool

    @[JSON::Field(converter: ::Wanikani::NilEpochConverter)]
    property burned_date : Time?

    property meaning_correct : Int32?
    property meaning_incorrect : Int32?
    property meaning_max_streak : Int32?
    property meaning_current_streak : Int32?
    property reading_correct : Int32?
    property reading_incorrect : Int32?
    property reading_max_streak : Int32?
    property reading_current_streak : Int32?
    property meaning_note : String?
    property reading_note : String?
    property user_synonyms : Array(String)?
  end

  # :nodoc:
  module NilEpochConverter
    def self.from_json(value : JSON::PullParser) : Time?
      value.read_null_or do
        seconds = value.read_int
        seconds == 0 ? nil : Time.epoch(seconds)
      end
    end

    def self.to_json(value : Time?, json : JSON::Builder)
      if value
        json.scalar(value.epoch)
      else
        json.null
      end
    end
  end

  # :nodoc:
  module StringToInt32Converter
    def self.from_json(value : JSON::PullParser) : Int32
      value.read_string.to_i
    end

    def self.to_json(value : Int32, json : JSON::Builder)
      json.scalar(value.to_s)
    end
  end
end
