module Matchers
  module XSD
    class XSD
      def matches?(actual)
        @actual = actual.collect do |e|
          e.to_s
        end
        @actual.empty?
      end

      def failure_message
        "expected the stylesheet to validate but got errors:\n\t* #{@actual.join("\n\t* ")}"
      end

      def negative_failure_message
        "expected the stylesheet to not validate, but it did"
      end
    end

    def successfully_validate
      XSD.new
    end
  end
end

