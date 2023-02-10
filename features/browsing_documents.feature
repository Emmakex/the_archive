Feature: Browsing documents

  As a user, I can browse documents

  Background:
    Given there are the following documents in the archive
      | Title | Location | Tags       |
      | doc1  | Basement | tag1       |
      | doc2  | Basement | tag2, tag1 |
      | doc3  | Basement | tag3       |
      | doc4  | Basement | tag1       |
      | doc5  | Basement | tag2, tag1 |
      | doc6  | Basement | tag3       |
      | doc7  | Attic    | tag1       |
      | doc8  | Attic    | tag2, tag1 |
      | doc9  | Attic    | tag3       |
      | doc10 | Attic    | tag1       |
      | doc11 | Attic    | tag2, tag1 |

  Scenario: Browse all documents, first page
    Given I go to the document list page
    Then I should see the following documents
      | Title | Location | Tags       |
      | doc1  | Basement | tag1       |
      | doc2  | Basement | tag2, tag1 |
      | doc3  | Basement | tag3       |
      | doc4  | Basement | tag1       |
      | doc5  | Basement | tag2, tag1 |
      | doc6  | Basement | tag3       |
      | doc7  | Attic    | tag1       |
      | doc8  | Attic    | tag2, tag1 |
      | doc9  | Attic    | tag3       |
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
      | doc1  | Basement | tag1       |
      | doc2  | Basement | tag2, tag1 |
      | doc4  | Basement | tag1       |
      | doc5  | Basement | tag2, tag1 |
      | doc7  | Attic    | tag1       |
      | doc8  | Attic    | tag2, tag1 |
      | doc10 | Attic    | tag1       |
      | doc11 | Attic    | tag2, tag1 |

  Scenario: Browse documents by location
    Given I go to the document list page
    When I click on "Basement"
    Then I should see the following documents
      | Title | Location | Tags       |
      | doc1  | Basement | tag1       |
      | doc2  | Basement | tag2, tag1 |
      | doc3  | Basement | tag3       |
      | doc4  | Basement | tag1       |
      | doc5  | Basement | tag2, tag1 |
      | doc6  | Basement | tag3       |

