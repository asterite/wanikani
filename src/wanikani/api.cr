require "http/client"
require "json"

# Provides access to [wanikani](https://www.wanikani.com)'s [API](https://www.wanikani.com/api):
#
# - `Wanikani::API` is the main entry for the API
# - `Wanikani::UserInformation`, `Wanikani::StudyQueue`, etc., are models returns from the API
# - `Wanikani::API::Error` is returned in case of an error (wrong level passed, or invalid API key)
module Wanikani
  # Wanikani API access.
  class API
    # Raises in case of an API error: either an invalid API key, or invalid
    # levels argument to some of the methods (radicals, kanji and vocabulary).
    class Error < Exception
      getter code

      def initialize(@code : String, message : String)
        super(message)
      end
    end

    # Creates a new API with the given key.
    def initialize(@api_key : String)
      @client = HTTP::Client.new("www.wanikani.com", tls: true)
    end

    def user_information : UserInformation
      get_response("user-information", Nil).user_information
    end

    def study_queue : StudyQueue
      get("study-queue", StudyQueue)
    end

    def level_progression : LevelProgression
      get("level-progression", LevelProgression)
    end

    def srs_distribution : Hash(String, SrsDistribution)
      get("srs-distribution", Hash(String, SrsDistribution))
    end

    def recent_unlocks : Array(RecentUnlock)
      get("recent-unlocks", Array(RecentUnlock))
    end

    def critical_items : Array(CriticalItem)
      get("critical-items", Array(CriticalItem))
    end

    def radicals(level = nil) : Array(Radical)
      get(level_path("radicals", level), Array(Radical))
    end

    def kanji(level = nil) : Array(Kanji)
      get(level_path("kanji", level), Array(Kanji))
    end

    def vocabulary(level = nil) : Array(Vocabulary)
      path = level_path("vocabulary", level)

      if level
        get(path, Array(Vocabulary))
      else
        # this is undocumented in the API, but in practice it works this way
        get(path, General(Array(Vocabulary)))
      end
    end

    private def level_path(base, level)
      level ? "#{base}/#{level}" : base
    end

    private def get_response(path, type : T.class) forall T
      response = @client.get("/api/user/#{@api_key}/#{path}")
      case code = response.status_code
      when 200
        begin
          Response(T).from_json(response.body)
        rescue JSON::Error
          ErrorResponse.from_json(response.body)
        end
      when 401
        raise Error.new(code: "unauthorized", message: "Invalid API key")
      else
        raise Error.new(code: "uknown", message: "Unexpected HTTP status code: #{code}")
      end
    end

    private def get(path, type : T.class) forall T
      response = get_response(path, type)
      if response.is_a?(ErrorResponse)
        raise Error.new(code: response.error[:code], message: response.error[:message])
      else
        response.requested_information
      end
    end
  end

  # :nodoc:
  class Response(T)
    JSON.mapping(
      user_information: UserInformation,
      requested_information: T,
    )
  end

  # :nodoc:
  class ErrorResponse
    JSON.mapping(
      user_information: UserInformation,
      error: NamedTuple(code: String, message: String),
    )
  end

  # :nodoc:
  class General(T)
    JSON.mapping(
      general: T,
    )
  end
end
