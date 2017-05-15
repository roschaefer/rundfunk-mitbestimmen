Feature:
  As a data scientist
  I want to see a distribution of the desired funds grouped by station
  In order to see the best station

  Scenario:
    Given the statistics look like this:
      | Broadcast            | Station       | Reviews | Approval | Total  |
      | extra3               | NDR Fernsehen | 1       | 100%     | 8.00€  |
      | Löwenzahn            | ZDF           | 1       | 100%     | 7.00 € |
      | Heute Show           | ZDF           | 1       | 100%     | 6.00€  |
      | Quarks & Co          | WDR Fernsehen | 1       | 100%     | 5.00€  |
      | Zapp                 | NDR Fernsehen | 1       | 100%     | 4.00€  |
      | Sendung mit der Maus | WDR Fernsehen | 1       | 100%     | 3.00€  |
      | Lokalzeit            | WDR Fernsehen | 1       | 100%     | 2.00€  |
    When I visit the visualization page
    And download the chart as SVG
    Then the downloaded chart is exactly the same like the one in "data/expected/distribution_by_station.svg"
    And from the diff in the distribution I can see that ZDF is doing well and WDR is not:
      | Station       | Total amount | Random expectation |
      | ZDF           | 13.00€       | 10.00€             |
      | NDR Fernsehen | 12.00€       | 10.00€             |
      | WDR Fernsehen | 10.00€       | 15.00€             |
