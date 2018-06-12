Feature: FAQ page
  As a maintainer of the application
  I want a dedicated page for every frequently asked question
  So that I can send journalists and other users a deep-link into the FAQ

  Scenario: Navigate to the FAQ page
    Given you are a journalist and interested in who is maintaining this app
    When you click on a link to "/faq/who-are-you" somewhere on the website
    Then you are on a dedicated faq page which has nothing but the explanation:
    """
    "Rundfunk Mitbestimmen" is mainly developed by volunteers of Agile
    Ventures, an online learner community for open-source software developers.
    """
