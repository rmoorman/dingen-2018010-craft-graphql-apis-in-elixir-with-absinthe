import React, { Component } from 'react';
import {QueryRenderer, graphql} from "react-relay"

import environment from "./relay-environment"
import './App.css';

import NewMenuItemSubscription from "./subscriptions/NewMenuItemSubscription"

const query = graphql`
  query AppQuery {menuItems{id name}}
`

class App extends Component {
  componentDidMount() {
    NewMenuItemSubscription()
  }

  render() {
    return (
      <QueryRenderer
        environment={environment}
        query={query}
        render={({error, props}) => {
          if (!error && !props) {
            return <div>Loading...</div>
          }
          if (error) {
            return <div>{error.message}</div>
          }

          return (
            <ul>
              {props.menuItems.map(item =>
                <li key={item.id}>{item.name}</li>
              )}
            </ul>
          )
        }}
      />
    );
  }
}

export default App;
