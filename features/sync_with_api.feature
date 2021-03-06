Feature:
  As an APP
  In order to sync all users with API
  RabbitMQ messages should be published on user events

  Scenario Outline: Publish message on user created|updated
    Given the following fixtures are loaded:
      | LoadAdherentData |
    Given I clean the "api_sync" queue
    When I dispatch the "<event>" user event with "michelle.dufour@example.ch"
    Then "api_sync" should have 1 message
    And "api_sync" should have message below:
      | routing_key   | body                                                                                                                                                                   |
      | <routing_key> | {"uuid":"313bd28f-efc8-57c9-8ab7-2106c8be9697","country":"CH","zipCode":"8057","emailAddress":"michelle.dufour@example.ch","firstName":"Michelle","lastName":"Dufour"} |
    Examples:
      | event        | routing_key  |
      | user.created | user.created |
      | user.updated | user.updated |

  Scenario: Publish message on user deleted
    Given the following fixtures are loaded:
      | LoadAdherentData |
    Given I clean the "api_sync" queue
    When I dispatch the "user.deleted" user event with "michel.vasseur@example.ch"
    Then "api_sync" should have 1 message
    And "api_sync" should have message below:
      | routing_key  | body                                            |
      | user.deleted | {"uuid":"46ab0600-b5a0-59fc-83a7-cc23ca459ca0"} |

  Scenario: Publish message on user update subscriptions
    Given the following fixtures are loaded:
      | LoadAdherentData |
    Given I clean the "api_sync" queue
    When I dispatch the "user.update_subscriptions" user event with "jacques.picard@en-marche.fr" and email subscriptions
    Then "api_sync" should have 1 message
    And "api_sync" should have message below:
      | routing_key               | body                                                                                                                            |
      | user.update_subscriptions | {"uuid":"a046adbe-9c7b-56a9-a676-6151a6785dda","subscriptions":["123abc"],"unsubscriptions":[]} |
