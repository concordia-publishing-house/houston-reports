class @AlertsOpenedClosedView extends Backbone.View

  initialize: (options)->
    @data = options.data
    @margin = {top: 40, right: 0, bottom: 24, left: 50}
    @width = 960 - @margin.left - @margin.right
    @height = 260 - @margin.top - @margin.bottom

    max = Math.max d3.max(@data, (d)-> d.closed), d3.max(@data, (d)-> d.opened)
    @y = d3.scale.linear()
      .range [@height, 0]
      .domain [-max, max]

    @x = d3.scale.ordinal()
      .rangeRoundBands([0, @width], .1)
      .domain @data.map (d)-> d.date

    formatDate = d3.time.format("%A")
    @xAxis = d3.svg.axis()
      .scale(@x)
      .orient("bottom")
      .tickFormat (date)-> formatDate(date)

    @yAxis = d3.svg.axis()
      .scale(@y)
      .orient("left")
  
  render: ->
    svg = @$el.html('<svg class="alerts-opened-closed-graph"></svg>').children()[0]
    @chart = d3.select(svg)
      .attr("width", @width + @margin.left + @margin.right)
      .attr("height", @height + @margin.top + @margin.bottom)
      .append("g")
        .attr("transform", "translate(#{@margin.left},#{@margin.top})")

    @chart.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0,#{@height})")
      .call(@xAxis)

    @chart.append("g")
      .attr("class", "y axis")
      .call(@yAxis)

    @chart.selectAll(".bar.alerts-opened")
        .data(@data)
      .enter().append("rect")
        .attr("class", "bar alerts-opened")
        .attr("x", (d)=> @x(d.date))
        .attr("y", (d)=> @y(d.opened))
        .attr("height", (d)=> @y(0) - @y(d.opened))
        .attr("width", @x.rangeBand())

    @chart.selectAll(".bar.alerts-closed")
        .data(@data)
      .enter().append("rect")
        .attr("class", "bar alerts-closed")
        .attr("x", (d)=> @x(d.date))
        .attr("y", (d)=> @y(0))
        .attr("height", (d)=> @y(0) - @y(d.closed))
        .attr("width", @x.rangeBand())
