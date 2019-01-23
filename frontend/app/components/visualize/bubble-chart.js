import Component from '@ember/component';
import { isBlank } from '@ember/utils';
import { select } from "d3-selection";
import { hierarchy, pack } from 'd3-hierarchy';

export default Component.extend({
  didRender() {
    this._super(...arguments);
    // avoid enter() is not a function error
    if (isBlank(this.get('chartData'))) return;
    let chartData = {children: this.get('chartData')};

    let clickCallback = this.get('onClick');

    let element = select('div.chart-area');
    let diameter = element.node().getBoundingClientRect().width;

    let bubble = pack()
      .size([diameter, diameter])
      .padding(1.5);

    let svg = element.append("svg")
      .attr("width", diameter)
      .attr("height", diameter)
      .attr("class", "bubble");

    let root = hierarchy(chartData)
      .sum(d => d.size)
      .sort((a, b) => b.size- a.size);

    bubble(root);
    let node = svg.selectAll(".node")
      .data(root.children)
      .enter()
      .append("g")
      .style("cursor", "pointer")
      .attr("class", "node")
      .on('click', d => clickCallback(d.data.id))
      .attr("transform", d => "translate(" + d.x + "," + d.y + ")");

    node.append("title")
      .text(d => d.data.tooltip);

    node.append("path")
      .attr("d", "M0 8 l -5-5 c -3-3 1-8 5-5 3-3 8 1 5 5")
      .attr("transform", d => `scale(${0.17 * d.r})`)
      .style("fill", d => d.data.color) ;

    node.append("text")
      .attr("dy", ".3em")
      .style("fill", d => d.data.textColor)
      .style("text-anchor", "middle")
      .text(d => d.data.label.substring(0, d.r / 3));


    select(self.frameElement).style("height", diameter + "px");
  },
  willUpdate(){
    this._super(...arguments);
    select('div.chart-area svg').remove();
  }

});
