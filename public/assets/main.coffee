
# current page
page = _.last(location.pathname.split('/')) or 'index'

# sidebar active
$sidebar = $('.sidebar')
$sidebar.find('a[href^=\'' + page + '\']').parent().addClass('active')

# sidebar toggle
$sidebarToggle = $('.sidebar-toggle')
$('.sidebar-toggle, .sidebar .mask').click ->
  $sidebarToggle.children('i').toggleClass('fa-navicon fa-times')
  $sidebar.toggle()


mapWidth = 700
mapHeight = 400
xScale = d3.scale.linear().domain([0,mapWidth]).range([0,100]).clamp(true)
yScale = d3.scale.linear().domain([0,mapHeight]).range([0,100]).clamp(true)

if page == 'heatmap'
  $heatmap = $('.heatmap')
  heatmap = h337.create(
    container: $heatmap[0]
    maxOpacity: .7
  )
  $heatmap.children('canvas').attr('width', mapWidth).attr('height', mapHeight)
  data = for i in _.range(200)
    x: _.random(mapWidth)
    y: _.random(mapHeight)
    value: _.random(10, 30)
  heatmap.addData(data)

if page == 'traffic'
  clientIds = ['a', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', ]

  trafficData = for clientId in clientIds
    clientId: clientId
    x: _.random(mapWidth)
    y: _.random(mapHeight)

  $$svg = d3.select('svg')
  $$current = $$svg.select('.current')
  $$track = $$svg.select('.track')

  drawPoints = (data) ->
    circles = $$current.selectAll('circle')
      .data(data, (d) -> d.clientId)
    circles.enter().append('circle')
      .on('click', showTrack)
      .attr('class', 'point')
      .attr('r', 5)
    circles.transition()
      .attr('cx', (d) -> xScale(d.x)+'%')
      .attr('cy', (d) -> yScale(d.y)+'%')

  setInterval(->
    data = _.sample(trafficData, _.random(4, trafficData.length))
    for item in data
      item.x = Math.abs(item.x + _.random(-50, 50))
      item.y = Math.abs(item.y + _.random(-50, 50))
    drawPoints(data)
  , 3000)

  entries = [
    {x: 340, y: 0}
    {x: 0, y: 180}
    {x: 550, y: 500}
    {x: 700, y: 80}
  ]
  showTrack = (d) ->
    $$track.append('circle')
      .on('click', hideTrack)
      .attr('class', 'point')
      .attr('r', 5)
      .attr('cx', xScale(d.x)+'%')
      .attr('cy', yScale(d.y)+'%')
    $$current.transition().style('opacity', 0).each 'end', ->
      $$current.classed('hide', true)
      points = for i in _.range(0, _.random(2, 6))
        x: _.random(mapWidth)
        y: _.random(mapHeight)
      points.unshift(_.sample(entries))
      points.push(d)
      drawTrack = (i) ->
        p1 = points[i]
        p2 = points[i+1]
        $$track.append('circle')
          .on('click', hideTrack)
          .attr('class', 'point')
          .attr('r', 5)
          .attr('cx', xScale(p1.x)+'%')
          .attr('cy', yScale(p1.y)+'%')
          .style('opacity', 0)
          .transition()
          .style('opacity', 1)
          .each 'end', ->
            $$track.insert('line', ":first-child")
              .attr('class', 'track')
              .attr('x1', xScale(p1.x)+'%')
              .attr('y1', yScale(p1.y)+'%')
              .attr('x2', xScale(p1.x)+'%')
              .attr('y2', yScale(p1.y)+'%')
              .transition()
              .duration(1000)
              .attr('x2', xScale(p2.x)+'%')
              .attr('y2', yScale(p2.y)+'%')
              .each 'end', ->
                if i < points.length - 2
                  drawTrack(i+1)
      drawTrack(0)
  hideTrack = (d) ->
    $$track.selectAll('*').transition().style('opacity', 0).each 'end', ->
      d3.select(this).remove()
      $$current.classed('hide', false).transition().style('opacity', 1)

  drawPoints(trafficData)
