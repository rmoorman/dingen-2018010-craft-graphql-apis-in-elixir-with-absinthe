/**
 * @flow
 * @relayHash ae89a69f8b190499e2f644f76b950e98
 */

/* eslint-disable */

'use strict';

/*::
import type { ConcreteRequest } from 'relay-runtime';
export type NewMenuItemSubscriptionVariables = {||};
export type NewMenuItemSubscriptionResponse = {|
  +newMenuItem: ?{|
    +id: string,
    +name: ?string,
  |}
|};
export type NewMenuItemSubscription = {|
  variables: NewMenuItemSubscriptionVariables,
  response: NewMenuItemSubscriptionResponse,
|};
*/


/*
subscription NewMenuItemSubscription {
  newMenuItem {
    id
    name
  }
}
*/

const node/*: ConcreteRequest*/ = (function(){
var v0 = [
  {
    "kind": "LinkedField",
    "alias": null,
    "name": "newMenuItem",
    "storageKey": null,
    "args": null,
    "concreteType": "MenuItem",
    "plural": false,
    "selections": [
      {
        "kind": "ScalarField",
        "alias": null,
        "name": "id",
        "args": null,
        "storageKey": null
      },
      {
        "kind": "ScalarField",
        "alias": null,
        "name": "name",
        "args": null,
        "storageKey": null
      }
    ]
  }
];
return {
  "kind": "Request",
  "operationKind": "subscription",
  "name": "NewMenuItemSubscription",
  "id": null,
  "text": "subscription NewMenuItemSubscription {\n  newMenuItem {\n    id\n    name\n  }\n}\n",
  "metadata": {},
  "fragment": {
    "kind": "Fragment",
    "name": "NewMenuItemSubscription",
    "type": "RootSubscriptionType",
    "metadata": null,
    "argumentDefinitions": [],
    "selections": v0
  },
  "operation": {
    "kind": "Operation",
    "name": "NewMenuItemSubscription",
    "argumentDefinitions": [],
    "selections": v0
  }
};
})();
// prettier-ignore
(node/*: any*/).hash = '78cf2d42e003573d71a2ab204e5087fa';
module.exports = node;
