Feature: Adding documents to the archive

  Users can add documents, optionally with an attachment, to the archive.

  Background: There is a user in the system

    Given there is a user named "Riley Smith"

  Scenario: Adding a document to the archive

    Given I am logged in as "Riley Smith"
    When I go to the "add document" page
    And I fill the form with
      | Title       | My first document         |
      | Description | This is my first document |
      | Tags        | first, document           |
      | Location    | Basement                  |
      | Date        | 2012-01-01                |
      | Identifier  | 1234                      |
    And I press "Add"
    Then the document is added to the archive
    And the document identifier is "basement-1234"

  Scenario: Adding a document with an attachment to the archive

    Given I am logged in as "Riley Smith"
    When I go to the "add document" page
    And I fill the form with
      | Title       | My first document         |
      | Description | This is my first document |
      | Tags        | first, document           |
      | Location    | Basement                  |
      | Date        | 2012-01-01                |
      | Identifier  | 1234                      |
    And I attach the file "test.txt" to "Attachment"
    And I press "Add"
    Then the document is added to the archive
    And the attachment is added to the archive

  Scenario: Automatic identifier generation

    Given I am logged in as "Riley Smith"
    And a document with the identifier "basement-000001" exists
    When I go to the "add document" page
    And I fill the form with
      | Title       | My first document         |
      | Description | This is my first document |
      | Tags        | first, document           |
      | Location    | Basement                  |
      | Date        | 2012-01-01                |
    And I press "Add"
    Then the document is added to the archive
    And the document identifier is "basement-000002"
