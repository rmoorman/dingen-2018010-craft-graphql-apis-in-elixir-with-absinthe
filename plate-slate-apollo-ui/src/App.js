import React from "react"
import "./App.css"

import {graphql} from "react-apollo"
import gql from "graphql-tag"

class App extends React.Component {
  componentWillMount() {
    this.props.subscribeToNewMenuItems()
  }

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

const subscription = gql`
  subscription {
    newMenuItem { id name}
  }
`

const AppContainer = graphql(query, {
  props: props => ({
    ...props,
    subscribeToNewMenuItems: params => props.data.subscribeToMore({
      document: subscription,
      updateQuery: (prev, {subscriptionData}) => {
        if (!subscriptionData.data) {
          return prev
        }
        const {newMenuItem} = subscriptionData.data
        return {...prev, menuItems: [newMenuItem, ...prev.menuItems]}
      }
    }),
  })
})(App)

export default AppContainer
