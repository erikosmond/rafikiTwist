# frozen_string_literal: true

RSpec.shared_context 'basic_setup', shared_context: :metadata do
  let!(:ingredient_tag_type) { create(:tag_type, name: TagType.ingredient) }
  let!(:ingredient_type_tag_type) { create(:tag_type, name: TagType.ingredient_type) }
  let!(:ingredient_family_tag_type) do
    create(:tag_type, name: TagType.ingredient_family)
  end
  let!(:ingredient_mod_tag_type) do
    create(:tag_type, name: TagType.ingredient_modification)
  end
end
