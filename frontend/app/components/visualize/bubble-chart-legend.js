import Component from '@ember/component';
import d3 from 'd3';

export default Component.extend({
  legendheight: 200,
  legendwidth: 100,

  static(selector_id, color){
    let legendheight = this.get('legendheight'),
      legendwidth = this.get('legendwidth'),
      margin = {top: 10, right: 80, bottom: 10, left: 2};
    let svg = d3.select(selector_id)
      .append("svg")
      .attr("height", (legendheight) + "px")
      .attr("width", (legendwidth) + "px")

    let legendscale = d3.scaleLinear()
      .domain([0, 2])
      .range([1, legendheight - margin.top - margin.bottom]);

    let legendaxis = d3.axisRight()
      .scale(legendscale)
      .tickValues([1])
      .tickFormat(this.get('staticLabel'));

    svg.append('rect')
      .attr('x', margin.left)
      .attr('y', margin.top)
      .attr('width', legendwidth - margin.left - margin.right)
      .attr('height', legendheight - margin.top - margin.bottom)
      .attr('fill', color);

    svg
      .append("g")
      .attr("class", "axis")
      .attr("transform", "translate(" + (legendwidth - margin.left - margin.right + 3) + "," + (margin.top) + ")")
      .call(legendaxis);
  },
  continuous(selector_id, colorscale) {
    let legendheight = this.get('legendheight'),
      legendwidth = this.get('legendwidth'),
      margin = {top: 10, right: 80, bottom: 10, left: 2};

    let canvas = d3.select(selector_id)
      .style("height", legendheight + "px")
      .style("width", legendwidth + "px")
      .style("position", "relative")
      .append("canvas")
      .attr("height", legendheight - margin.top - margin.bottom)
      .attr("width", 1)
      .style("height", (legendheight - margin.top - margin.bottom) + "px")
      .style("width", (legendwidth - margin.left - margin.right) + "px")
      .style("border", "1px solid #000")
      .style("position", "absolute")
      .style("top", (margin.top) + "px")
      .style("left", (margin.left) + "px")
      .node();

    let ctx = canvas.getContext("2d");

    let legendscale = d3.scaleLinear()
      .range([1, legendheight - margin.top - margin.bottom])
      .domain(colorscale.domain());

    // image data hackery based on http://bl.ocks.org/mbostock/048d21cf747371b11884f75ad896e5a5
    let image = ctx.createImageData(1, legendheight);
    d3.range(legendheight).forEach(function(i) {
      let c = d3.rgb(colorscale(legendscale.invert(i)));
      image.data[4*i] = c.r;
      image.data[4*i + 1] = c.g;
      image.data[4*i + 2] = c.b;
      image.data[4*i + 3] = 255;
    });
    ctx.putImageData(image, 0, 0);

    // A simpler way to do the above, but possibly slower. keep in mind the legend width is stretched because the width attr of the canvas is 1
    // See http://stackoverflow.com/questions/4899799/whats-the-best-way-to-set-a-single-pixel-in-an-html5-canvas
    /*
  d3.range(legendheight).forEach(function(i) {
    ctx.fillStyle = colorscale(legendscale.invert(i));
    ctx.fillRect(0,i,1,1);
  });
  */

    let legendaxis = d3.axisRight()
      .scale(legendscale)
      .ticks(10)
      .tickFormat(d3.format("+.2%"));

    let svg = d3.select(selector_id)
      .append("svg")
      .attr("height", (legendheight) + "px")
      .attr("width", (legendwidth) + "px")
      .style("position", "absolute")
      .style("left", "0px")
      .style("top", "0px")

    svg
      .append("g")
      .attr("class", "axis")
      .attr("transform", "translate(" + (legendwidth - margin.left - margin.right + 3) + "," + (margin.top) + ")")
      .call(legendaxis);
  },
  didRender(){
    this.continuous(".legend-area .continuous", this.get('colorScale'));
    this.static(".legend-area .static", this.get('staticColor'));
  },
  willUpdate(){
    this._super(...arguments);
    d3.select('.legend-area .continuous svg').remove();
    d3.select('.legend-area .static svg').remove();
  }
});
