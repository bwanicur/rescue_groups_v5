module RescueGroupsV5
  module Helpers
    module CaseConverter
      # borrowed from Rails:
      # https://github.com/rails/rails/blob/fc5dd0b85189811062c85520fd70de8389b55aeb/activesupport/lib/active_support/inflector/methods.rb#L92
      def convert_camel_to_snake_case(camel_case_word)
        camel_case_word.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
      end
      
      def convert_snake_to_camel_case(snake_case_word)
        words = snake_case_word.split('_')
        first_word = words.shift
        first_word + words.map(&:capitalize).join('')
      end
    end
  end
end
