import React from "react"
import "./App.css"

import {graphql} from "react-apollo"
import gql from "graphql-tag"

class App extends React.Component {
  get menuItems() {
    const {data} = this.props
    if (data && data.menuItems) {
      return data.menuItems
    } else {
      return []
    }
  }

  renderMenuItem(menuItem) {
    return (
      <li key={menuItem.id}>{menuItem.name}</li>
    )
  }

  render() {
    return (
      <ul>
        {this.menuItems.map(this.renderMenuItem)}
      </ul>
    )
  }
}

const query = gql`
  {menuItems { id name }}
`

export default graphql(query)(App)
