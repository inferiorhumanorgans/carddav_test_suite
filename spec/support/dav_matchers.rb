module Matchers
  module DAV
    class HREFDirectoryMatch
      def initialize(expected)
        @expected = expected
      end

      def matches?(actual)
        @actual = actual
        [@actual, @actual+'/'].include? @expected
      end

      def failure_message
        "expected it to be similar to \`#{@expected}', got \`#{@actual}' instead"
      end

      def negative_failure_message
        "expected \`#{@expected}' and \`#{@actual}' to differ, but they match"
      end
    end

    class HTTPResponseCodeMatch
      def initialize(status_code)
        @status_code = status_code.to_i
      end
      def matches?(actual)
        @captures = actual.match(/(HTTP\/1\.1).(\d{3}).(.*)$/).captures
        @captures[1].to_i == @status_code
      end

      def failure_message
        "expected response to be #{@status_code}, got #{@captures[1]} instead"
      end

      def negative_failure_message
        "did not expect HTTP #{@status_code}"
      end
    end
    
    def be_similar_to_href(expected)
      HREFDirectoryMatch.new(expected)
    end
    
    def be_success
      HTTPResponseCodeMatch.new(200)
    end

    def be_bad_request
      HTTPResponseCodeMatch.new(400)
    end

    def be_unauthorized
      HTTPResponseCodeMatch.new(401)
    end

    def be_forbidden
      HTTPResponseCodeMatch.new(402)
    end

    def be_not_found
      HTTPResponseCodeMatch.new(404)
    end

    def be_internal_error
      HTTPResponseCodeMatch.new(500)
    end

  end

end