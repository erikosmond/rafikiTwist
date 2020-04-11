import React from 'react'
import PropTypes from 'prop-types'
import RecipeForm from './RecipeForm'

class RecipeFormSkeleton extends React.Component {
  componentDidMount() {
    const { loadIngredientOptions, loadTagOptions } = this.props
    loadIngredientOptions('Ingredients')
    loadTagOptions()
  }

  submit = (values) => {
    // send the values to the store
    const { handleRecipeSubmit } = this.props
    handleRecipeSubmit(values)
  }

  render() {
    const { ingredientOptions, ingredientModificationOptions } = this.props
    return (
      <RecipeForm
        ingredientOptions={ingredientOptions}
        ingredientModificationOptions={ingredientModificationOptions}
        onSubmit={this.submit}
      />
    )
  }
}

RecipeFormSkeleton.propTypes = {
  handleRecipeSubmit: PropTypes.func.isRequired,
  ingredientOptions: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string,
  })),
  ingredientModificationOptions: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string,
  })),
  loadIngredientOptions: PropTypes.func.isRequired,
  loadTagOptions: PropTypes.func.isRequired,
}

RecipeFormSkeleton.defaultProps = {
  ingredientOptions: [],
  ingredientModificationOptions: [],
}

export default RecipeFormSkeleton
