import Component from '@ember/component';
import d3 from 'd3';
import { isBlank } from '@ember/utils';

export default Component.extend({
  classNames: ['graph-visualization row'],
  didRender() {
    this._super(...arguments);
    if (isBlank(this.get('graph'))) return;

    let element = d3.select('div.chart-area');
    let width = element.node().getBoundingClientRect().width;
    let height = 960;


    let color = d3.scaleOrdinal(d3.schemeCategory10);

    let simulation = d3.forceSimulation()
      .force("link", d3.forceLink().id(function(d) { return d.id; }))
      .force("charge", d3.forceManyBody())
      .force("center", d3.forceCenter(width / 2, height / 2));

    let graph = this.get('graph');


    let svg = element.append("svg")
      .attr("width", width)
      .attr("height", height);
    //add encompassing group for the zoom
    let container = svg.append("g")
      .attr("class", "everything");

    let link = container
      .append("g")
      .attr("class", "links")
      .selectAll("line")
      .data(graph.links)
      .enter().append("line")
      .attr("stroke-width", function(d) { return Math.sqrt(d.value); });

    let node = container
      .append("g")
      .attr("class", "nodes")
      .selectAll("g")
      .data(graph.nodes)
      .enter()
      .append("g");

    let linkedByIndex = {};
    graph.links.forEach((d) => {
      linkedByIndex[`${d.source},${d.target}`] = true;
    });

    const isConnected = function(a, b) {
      return linkedByIndex[`${a.id},${b.id}`] || linkedByIndex[`${b.id},${a.id}`] || a.id === b.id;
    }

    const mouseOverFunction = function (d) {
      node.transition(500).style('opacity', o => (isConnected(o, d) ? 1.0 : 0.2));
      link.transition(500).style('stroke-opacity', o => (o.source === d || o.target === d ? 1 : 0.2));
    };

    const mouseOutFunction = function () {
      node.transition(2000).style('opacity', 1.0);
      link.transition(2000).style('stroke-opacity', 1.0);
    };

    node.append("circle").attr("r", 5).attr("fill", function(d) {
      return color(d.group);
    })
      .on('mouseover', mouseOverFunction)
      .on('mouseout', mouseOutFunction)
      .call(d3.drag().on("start", (d) => {
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

    node.append("text").text(function(d) {
      return d.title;
    }).attr('x', 6).attr('y', 3);

    node.append("title").text(function(d) { return d.title; });

    simulation.nodes(graph.nodes).on("tick", ()=> {
      link.attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

      node.attr("transform", function(d) {
        return "translate(" + d.x + "," + d.y + ")";
      })
    });

    simulation.force("link").links(graph.links);

    //add zoom capabilities
    let zoom_handler = d3.zoom().on("zoom", () => {
      container.attr("transform", d3.event.transform)
    });

    zoom_handler(svg);
  },
  willUpdate(){
    this._super(...arguments);
    d3.select('div.chart-area svg').remove();
  }
});
