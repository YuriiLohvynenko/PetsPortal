# app/models/concerns/prohibited_words_validation.rb
module ProhibitedWordsValidation
    extend ActiveSupport::Concern

    class_methods do
      def validate_prohibited_words(*attributes)
        validate do
          check_for_prohibited_words(attributes)
        end
      end
    end

    private

    def check_for_prohibited_words(attributes)
      prohibited_words = ProhibitedWord.pluck(:word)

      attributes.each do |attribute|
        attribute_content = self[attribute]
        next unless attribute_content.present?

        found_prohibited_words = prohibited_words.select { |word| attribute_content.downcase.include?(word.downcase) }

        if found_prohibited_words.any?
          errors.add(attribute.to_sym, "禁止ワードが含まれています")
        end
      end
    end
  end
