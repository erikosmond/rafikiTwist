import Select from 'react-select'
import styled from 'styled-components'

const StyledSelect = styled(Select)`
  width: 30%;
  display: inline-block;
  margin: 10px 3px 10px 3px;
  width: ${(props) => (props.mobile ? '90%' : '30%')};
`

export default StyledSelect
