# frozen_string_literal: true

require 'rails_helper'
require_relative '../../contexts/graph_index_context'

# rubocop: disable Metrics/BlockLength
describe Graph::RecipeIndex do
  include_context 'graph_index_context'
  let(:expected_hash) do
    {
      0 => [
        self_rising_flour_recipe.id,
        pizza_dough_recipe.id,
        pizza.id,
        veggie_soup.id,
        veggie_plate.id
      ],
      user1.id => [
        pumpkin_pie.id, mashed_potatoes.id
      ],
      user2.id => [
        almond_milk_recipe.id, orgeat_recipe.id, awesome_blossom.id, mai_tai.id
      ]
    }
  end
  let(:index) { Graph::RecipeIndex.instance }

  # TODO: make sure the associations of the recipe are `loaded?`
  it 'generates and returns the recipes index' do
    expect(index.hash.values.map(&:name).sort).to eq [
      'Awesome Blossom',
      'Mai Tai',
      'Mashed Potatoes',
      'Pizza',
      'Pumpkin Pie',
      'Veggie Plate',
      'Veggie Soup',
      'almond milk',
      'orgeat',
      'pizza dough',
      'self-rising flour'
    ]
  end

  it 'assigns appropriate attributes' do
    index.reset
    expect(index.hash[self_rising_flour_recipe.id].ingredients.first.amount).to eq '1 cup'
    expect(index.hash[self_rising_flour_recipe.id].ingredients.first.name).to eq 'flour'
    expect(index.hash[self_rising_flour_recipe.id].ingredients.first.modification_name).
      to eq 'bleached'
    expect(index.hash[self_rising_flour_recipe.id].ingredients.first.modification_id).
      to eq bleached.id
    expect(index.hash[self_rising_flour_recipe.id].ingredients.first.body).to eq 'sifted'
    expect(index.hash[self_rising_flour_recipe.id].ingredients.first.id).to eq flour.id
  end

  it 'loads tag ids by type' do
    index.reset
    expect(index.hash[self_rising_flour_recipe.id].tag_ids_by_type).
      to eq({ 'vessels' => [bowl.id], 'sources' => [cook_book.id] })
  end

  it 'loads objective tag ids' do
    index.reset
    expect(index.hash[self_rising_flour_recipe.id].objective_tag_ids).
      to eq([flour.id, bowl.id, cook_book.id, baking_soda.id])
  end

  it 'loads filter tag ids' do
    index.reset
    expect(index.hash[self_rising_flour_recipe.id].filter_tag_ids).
      to eq([flour.id, wheat.id, grains.id, bowl.id, cook_book.id, baking_soda.id])
  end

  it 'loads filter tag ids with nested recipes' do
    index.reset
    expect(index.hash[mai_tai.id].filter_tag_ids.sort).
      to eq([
        plant_protein.id, nut.id, water.id, almond.id,
        sugar.id, almond_milk.id, orgeat.id, rum.id
      ].sort)
  end

  it 'shows tag modifications by user' do
    index.reset
    modified = Graph::UserAccessModifiedTagIndex.instance.hash
    modifications = Graph::UserAccessModificationTagIndex.instance.hash
    flour_tag = Graph::TagIndex.instance.fetch_by_user(flour.id, user1)
    expect(modified).to eq(
      {
        0 => { bleached.id => [flour.id] }, user2.id =>
        {
          dry_roasted.id => [almond.id], distilled.id => [water.id]
        }
      }
    )

    expect(modifications).to eq(
      {
        0 => { flour.id => [bleached.id] }, user2.id =>
        {
          almond.id => [dry_roasted.id], water.id => [distilled.id]
        }
      }
    )
    almond_tag = Graph::TagIndex.instance.fetch_by_user(almond.id, user2)
    almond_user2 = almond_tag.api_response(user2.id)
    expect(almond_user2).to eq(
      {
        modification_tags: { dry_roasted.id => dry_roasted.name },
        modified_tags: {},
        description: almond.description,
        id: almond.id,
        name: almond.name,
        recipe_id: nil,
        tag_type_id: ingredient_tag_type.id,
        tags: { almond.id => almond.name },
        child_tags: {},
        grandchild_tags: {},
        grandparent_tags: { plant_protein.id => plant_protein.name },
        parent_tags: { nut.id => nut.name },
        sister_tags: { cashew.id => cashew.name }
      }
    )

    almond_user1 = almond_tag.api_response(user1.id)
    expect(almond_user1[:sister_tags]).to eq(
      { cashew.id => cashew.name, hazelnut.id => hazelnut.name }
    )

    dr = Graph::TagIndex.instance.fetch_by_user(dry_roasted.id, user2)
    expect(dr.api_response(user2)[:modified_tags]).to eq(
      { almond.id => almond.name }
    )

    expect(dr.api_response(user1)[:modified_tags]).to eq({})

    binding.pry

    nr = Graph::TagIndex.instance.fetch_by_user(dry_roasted.id, user2 )
    expect(nr.api_response(user1)[:modified_tags]).to eq(
      { nut.id => almond.name }
    )

    expect(nr.api_response(user1)[:modified_tags]).to eq({})
  end
end
# rubocop: enable Metrics/BlockLength
