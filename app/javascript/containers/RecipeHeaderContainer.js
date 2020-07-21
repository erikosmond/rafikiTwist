import { connect } from 'react-redux'
import { withRouter } from 'react-router-dom'

import RecipeHeader from 'components/recipes/RecipeHeader'

import { loadRecipeOptions } from 'bundles/recipes'

import { loadIngredientOptions } from 'bundles/tags'

export default withRouter(connect(
  (state) => ({
    authenticated: state.recipesReducer.authenticated,
    recipeOptions: state.recipesReducer.recipeOptions,
    ingredientOptions: state.tagsReducer.ingredientOptions,
    categoryOptions: state.tagsReducer.categoryOptions,
    firstName: state.recipesReducer.firstName,
    selectedTag: state.tagsReducer.selectedTag,
  }),
  {
    loadRecipeOptions,
    loadIngredientOptions,
  },
)(RecipeHeader))
