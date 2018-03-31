import Component from '@ember/component';
import { isBlank } from '@ember/utils';
import d3 from 'd3';

export default Component.extend({
  monthTitle (t0) {
    return t0.toLocaleString("en-us", { month: "long" });
  },
  yearTitle(t0) {
    return t0.toString().split(" ")[3];
  },
  didRender(){
    this._super(...arguments);
    // avoid enter() is not a function error
    if (isBlank(this.get('calendarItems'))) return;

    let element_rect = d3.select('#calendar-chart').node().getBoundingClientRect();
    let width = element_rect.width,
      height = 720000/width,
      cellSize = 25; // cell size

    let no_months_in_a_row = Math.floor(width / (cellSize * 7 + 50));
    let shift_up = cellSize * 3;

    let day = d3.timeFormat("%w"), // day of the week
      day_of_month = d3.timeFormat("%e"), // day of the month
      day_of_year = d3.timeFormat("%j"),
      week = d3.timeFormat("%U"), // week number of the year
      month = d3.timeFormat("%m"), // month number
      year = d3.timeFormat("%Y"),
      percent = d3.format(".1%"),
      format = d3.timeFormat("%Y-%m-%d");

    let color = d3.scaleSequential()
      .domain([0, 20])
      .interpolator(d3.interpolateReds);

    let svg = d3.select("#calendar-chart").selectAll("svg")
      .data(d3.range(2013, 2019))
      .enter().append("svg")
      .attr("width", width)
      .attr("height", height)
      .append("g")

    let rect = svg.selectAll(".day")
      .data(function(d) {
        return d3.timeDays(new Date(d, 0, 1), new Date(d + 1, 0, 1));
      })
      .enter().append("rect")
      .attr("class", "day")
      .attr("width", cellSize)
      .attr("height", cellSize)
      .attr("x", function(d) {
        let month_padding = 1.2 * cellSize*7 * ((month(d)-1) % (no_months_in_a_row));
        return day(d) * cellSize + month_padding;
      })
      .attr("y", function(d) {
        let week_diff = week(d) - week(new Date(year(d), month(d)-1, 1) );
        let row_level = Math.ceil(month(d) / (no_months_in_a_row));
        return (week_diff*cellSize) + row_level*cellSize*8 - cellSize/2 - shift_up;
      })
      .datum(format);

    let month_titles = svg.selectAll(".month-title")  // Jan, Feb, Mar and the whatnot
      .data(function(d) {
        return d3.timeMonths(new Date(d, 0, 1), new Date(d + 1, 0, 1)); })
      .enter().append("text")
      .text(this.monthTitle)
      .attr("x", function(d, i) {
        let month_padding = 1.2 * cellSize*7* ((month(d)-1) % (no_months_in_a_row));
        return month_padding;
      })
      .attr("y", function(d, i) {
        let week_diff = week(d) - week(new Date(year(d), month(d)-1, 1) );
        let row_level = Math.ceil(month(d) / (no_months_in_a_row));
        return (week_diff*cellSize) + row_level*cellSize*8 - cellSize - shift_up;
      })
      .attr("class", "month-title")
      .attr("d", this.monthTitle);

    svg.selectAll(".year-title")  // Jan, Feb, Mar and the whatnot
      .data(function(d) {
        return d3.timeYears(new Date(d, 0, 1), new Date(d + 1, 0, 1)); })
      .enter().append("text")
      .text(this.yearTitle)
      .attr("x", function(d, i) { return width/2 - 100; })
      .attr("y", function(d, i) { return cellSize*5.5 - shift_up; })
      .attr("class", "year-title")
      .attr("d", this.yearTitle);


    let data = d3.nest()
      .key(function(d) { return d.date; })
      .rollup(function(d) { return d[0].aired_count; })
      .map(this.get('calendarItems'));

    let dataFunction = (d) => { return data.has(d) ? data.get(d) : 0; }
    rect
      .attr("fill", (d) => { return color(dataFunction(d)); })
      .attr('stroke', '#AAAAAA')
      .append("title")
      .text(function(d) { return `${(new Date(Date.parse(d))).toLocaleDateString('de-DE')}: ${dataFunction(d)}`; });

  }
});
