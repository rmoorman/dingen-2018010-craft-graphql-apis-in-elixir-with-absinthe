import {graphql, requestSubscription} from "react-relay"

import environment from "../relay-environment"

const newMenuItemSubscription = graphql`
  subscription NewMenuItemSubscription {
    newMenuItem {id name}
  }
`

export default () => {
  const subscriptionConfig = {
    subscription: newMenuItemSubscription,
    variables: {},
    updater: proxyStore => {
      // Get the new menu item
      const newMenuItem = proxyStore.getRootField("newMenuItem")
      // Get existing menu items
      const root = proxyStore.getRoot()
      const menuItems = root.getLinkedRecords("menuItems")
      // Prepend the new menu item
      root.setLinkedRecords([newMenuItem, ...menuItems], "menuItems")
    },
    onError: error => console.log("An error occurred:", error)
  }

  requestSubscription(
    environment,
    subscriptionConfig
  )
}
