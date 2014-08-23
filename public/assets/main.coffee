
# sidebar active
currentHref = location.pathname.split('/')[1] or 'index'
$('.sidebar').find('a[href^=\'' + currentHref + '\']').parent().addClass('active')


# traffic points

clientIds = ['a', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', ]
mapWidth = 700
mapHeight = 400

trafficData = for clientId in clientIds
  clientId: clientId
  x: _.random(mapWidth)
  y: _.random(mapHeight)

$$svg = d3.select('.traffic-box svg')

xScale = d3.scale.linear().domain([0,mapWidth]).range([0,100]).clamp(true)
yScale = d3.scale.linear().domain([0,mapHeight]).range([0,100]).clamp(true)
drawPoints = (data) ->
  circle = $$svg.selectAll('circle')
    .data(data, (d) -> d.clientId)
  circle.enter().append('circle')
    .attr('class', 'point')
    .attr('r', 5)
  circle.transition()
    .attr('cx', (d) -> xScale(d.x)+'%')
    .attr('cy', (d) -> yScale(d.y)+'%')
drawPoints(trafficData)

setInterval(->
  data = _.sample(trafficData, _.random(4, trafficData.length))
  for item in data
    item.x = Math.abs(item.x + _.random(-50, 50))
    item.y = Math.abs(item.y + _.random(-50, 50))
  drawPoints(data)
, 3000)
