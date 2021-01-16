# frozen_string_literal: true

module Graph
  # Singleton to index tags that have been modified in recipes.

  # TODO: consider getting rid of this. Check recipes' ingredients for modifications (cached in a hash)
  class UserAccessModifiedTagIndex < Index
    def add_modifier_tag(modified_id, modifier_id, access)
      add_to_hash(modified_id, modifier_id, access)
    end

    private

      def generate_index
        {}
      end
  end
end
