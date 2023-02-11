Feature: Browsing documents

  As a user, I can browse documents

  Background:
    Given there are the following documents in the archive
      | Title | Location | Tags       |
      | doc01 | Basement | tag1       |
      | doc02 | Basement | tag2, tag1 |
      | doc03 | Basement | tag3       |
      | doc04 | Basement | tag1       |
      | doc05 | Basement | tag2, tag1 |
      | doc06 | Basement | tag3       |
      | doc07 | Attic    | tag1       |
      | doc08 | Attic    | tag2, tag1 |
      | doc09 | Attic    | tag3       |
      | doc10 | Attic    | tag1       |
      | doc11 | Attic    | tag2, tag1 |

  Scenario: Browse all documents, first page
    Given I go to the document list page
    Then I should see the following documents
      | Title | Location | Tags       |
      | doc01 | Basement | tag1       |
      | doc02 | Basement | tag2, tag1 |
      | doc03 | Basement | tag3       |
      | doc04 | Basement | tag1       |
      | doc05 | Basement | tag2, tag1 |
      | doc06 | Basement | tag3       |
      | doc07 | Attic    | tag1       |
      | doc08 | Attic    | tag2, tag1 |
      | doc09 | Attic    | tag3       |
      | doc10 | Attic    | tag1       |

  Scenario: Browse all documents, second page
    Given I go to the document list page
    When I click on "Next"
    Then I should see the following documents
      | Title | Location | Tags       |
      | doc11 | Attic    | tag2, tag1 |

  Scenario: Browse documents by tag
    Given I go to the document list page
    When I click on "tag1"
    Then I should see the following documents
      | Title | Location | Tags       |
      | doc01 | Basement | tag1       |
      | doc02 | Basement | tag2, tag1 |
      | doc04 | Basement | tag1       |
      | doc05 | Basement | tag2, tag1 |
      | doc07 | Attic    | tag1       |
      | doc08 | Attic    | tag2, tag1 |
      | doc10 | Attic    | tag1       |
      | doc11 | Attic    | tag2, tag1 |

  Scenario: Browse documents by location
    Given I go to the document list page
    When I click on "Basement"
    Then I should see the following documents
      | Title | Location | Tags       |
      | doc01 | Basement | tag1       |
      | doc02 | Basement | tag2, tag1 |
      | doc03 | Basement | tag3       |
      | doc04 | Basement | tag1       |
      | doc05 | Basement | tag2, tag1 |
      | doc06 | Basement | tag3       |

