import Component from '@ember/component';
import d3 from 'd3';

export default Component.extend({
  didInsertElement() {
    this._super(...arguments);

    let svg = d3.select("svg"),
        width = +svg.attr("width"),
        height = +svg.attr("height");

    let color = d3.scaleOrdinal(d3.schemeCategory20);

    let simulation = d3.forceSimulation()
        .force("link", d3.forceLink().id(function(d) { return d.id; }))
        .force("charge", d3.forceManyBody())
        .force("center", d3.forceCenter(width / 2, height / 2));

    let graph = this.get('graph');
    let link = svg.append("g")
        .attr("class", "links")
      .selectAll("line")
      .data(graph.links)
      .enter().append("line")
        .attr("stroke-width", function(d) { return Math.sqrt(d.value); });

    let node = svg.append("g")
        .attr("class", "nodes")
      .selectAll("g")
      .data(graph.nodes)
      .enter().append("g")
    let circles = node.append("circle")
        .attr("r", 5)
        .attr("fill", function(d) { return color(d.group); })
        .call(d3.drag()
          .on("start", (d) => {
          if (!d3.event.active) simulation.alphaTarget(0.3).restart();
          d.fx = d.x;
          d.fy = d.y;
          }).on("drag", (d) => {
            d.fx = d3.event.x;
            d.fy = d3.event.y;
          }).on("end", (d) => {
            if (!d3.event.active) simulation.alphaTarget(0);
            d.fx = null;
            d.fy = null;
          }));

    let lables = node.append("text")
        .text(function(d) {
          return d.id;
        })
        .attr('x', 6)
        .attr('y', 3);

    node.append("title").text(function(d) { return d.id; });

    simulation
        .nodes(graph.nodes)
        .on("tick", ()=> {
      link.attr("x1", function(d) { return d.source.x; })
          .attr("y1", function(d) { return d.source.y; })
          .attr("x2", function(d) { return d.target.x; })
          .attr("y2", function(d) { return d.target.y; });

      node.attr("transform", function(d) {
            return "translate(" + d.x + "," + d.y + ")";
          })
    });

    simulation.force("link").links(graph.links);

  }
});
