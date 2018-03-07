import Component from '@ember/component';
import d3 from 'd3';

export default Component.extend({
  didRender() {
    this._super(...arguments);
    let chartData = {children: this.get('chartData')};
    let clickCallback = this.get('onClick');

    let element = d3.select('div.chart-area');
    let diameter = element.node().getBoundingClientRect().width;

    let bubble = d3.pack()
      .size([diameter, diameter])
      .padding(1.5);

    let svg = element.append("svg")
      .attr("width", diameter)
      .attr("height", diameter)
      .attr("class", "bubble");

    let root = d3.hierarchy(chartData)
      .sum(function(d) { return d.size; })
      .sort(function(a, b) { return b.size- a.size; });

    bubble(root);
    let node = svg.selectAll(".node")
      .data(root.children)
      .enter()
      .append("g")
      .style("cursor", "pointer")
      .attr("class", "node")
      .on('click', function(d) { clickCallback(d.data.id) })
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });

    node.append("title")
      .text(function(d) {
        return d.data.tooltip;
      });

    node.append("circle")
      .attr("r", function(d) { return d.r; })
      .style("fill", function(d) {
        return d.data.color;
      });

    node.append("text")
      .attr("dy", ".3em")
      .style("text-anchor", "middle")
      .text(function(d) { return d.data.label.substring(0, d.r / 3); });


    d3.select(self.frameElement).style("height", diameter + "px");
  },
  willUpdate(){
    this._super(...arguments);
    d3.select('div.chart-area svg').remove();
  }

});
