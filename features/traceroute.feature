Feature: Trace Route
    In order to see the route to a domain
    As someone interested in networks
    I want to run a trace route

    Scenario: Bad domain
        Given I have entered the domain "oops"
        When I submit the form
        Then I see an error message

    Scenario: Existing domain
        Given I have entered the domain "duckduckgo.com"
        When I submit the form
        Then I see a graph
        And I see a table
