import React from "react"
import "./App.css"

import {graphql} from "react-apollo"
import gql from "graphql-tag"

const query = gql`
  {
    menuItems(first: 100) {
      edges {
        node {id name}
      }
    }
  }
`

const subscription = gql`
  subscription {
    newMenuItem {
      id name
    }
  }
`


class App extends React.Component {
  componentWillMount() {
    this.props.subscribeToNewMenuItems()
  }

  get menuItems() {
    const {data} = this.props
    if (data && data.menuItems) {
      return data.menuItems.edges.map(({node: item}) => item)
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
        return {
          ...prev,
          menuItems: {
            ...prev.menuItems,
            edges: [
              {
                node: newMenuItem,
                __typename: "MenuItemEdge",
              },
              ...prev.menuItems.edges
            ]
          }
        }
      }
    }),
  })
})(App)

export default AppContainer
