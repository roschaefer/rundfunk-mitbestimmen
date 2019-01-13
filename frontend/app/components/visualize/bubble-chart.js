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
      .attr("d", "M0 20 v-20 h20 a10,10 9 0,1 0,20 a10,10 9 0,1 -20,0 z")
      .attr("transform", d => `scale(${0.05 * d.r}) translate(0, 15) rotate(225)`)
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
