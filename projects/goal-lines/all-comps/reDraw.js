function reDraw(vars, scales, xFormat, contexts, canvasMouse, dims, pathGens, dataSets, highlights, tooltip){
	let xVar0 = vars[0],
		yVar0 = vars[1],
		xVar = vars[2],
 		yVar = vars[3];
	let x0 = scales[0],
 		y0 = scales[1],
 		x = scales[2],
 		y = scales[3];
	let context = contexts[0],
		contextHover = contexts[1],
		contextOverlay = contexts[2];
	let canvas = canvasMouse;
	let width = dims[0],
		height = dims[1],
		PR = window.devicePixelRatio || 1,
		scaledWidth = width*PR,
		scaledHeight = height*PR;
	let pathVoronoi = pathGens[0],
		path = pathGens[1],
		pathOverlay = pathGens[2];
	let data = dataSets[0],
		linesData = dataSets[1],
		voronoi = dataSets[2],
		quadtree = dataSets[3];
	let colours = highlights;

	// Function that will animate between two paths for any array of [from, to] path strings
	function pathTween(pairs, precision, ticks, duration) {

		let pointHolder = [];

		pairs.forEach(p => {
			let from = p[0];
			let to = p[1];
		  let path0 = spp.svgPathProperties(from);
		  let path1 = spp.svgPathProperties(to);
		  let n0 = path0.getTotalLength();
		  let n1 = path1.getTotalLength();

		  // Uniform sampling of distance based on specified precision.
		  let distances = [0], i = 0, dt = precision / Math.max(n0, n1);
		  while ((i += dt) < 1) distances.push(i);
		  distances.push(1);
		  
		  // Compute point-interpolators at each distance.
		  let points = distances.map(function(f) {
		    let p0 = path0.getPointAtLength(f * n0),
		        p1 = path1.getPointAtLength(f * n1);
		    return d3.interpolate([p0.x, p0.y], [p1.x, p1.y]);
		  });

		  pointHolder.push({points: points, colour:p[2], lineWidth:p[3]});

		});
		  
		  let animate = d3.interval(function(t){
		    if(t >= duration){
		      context.clearRect(0, 0, width, height);
			    pointHolder.forEach(ph => {
			    	let c;
			    	context.strokeStyle = ph.colour;
			    	context.fillStyle = ph.colour;
			    	context.lineWidth = ph.lineWidth;
			    	context.beginPath();
				    ph.points.map(p => p(1)).forEach(function(p, i) {
				      context[i == 0 ? "moveTo" : "lineTo"](...p);
				      if(i == ph.points.length-1) c = p;
				    });
				    context.stroke();
				    context.beginPath();
			      context.arc(...c, 4, 0, Math.PI * 2);
			      context.globalAlpha = 0.6;
			      context.fill();
			      context.globalAlpha = 1;
			      context.lineWidth = 1;
			      context.stroke();
			    });
		      animate.stop();
		    }else{		  
			    context.clearRect(0, 0, width, height);
			    pointHolder.forEach(ph => {
			    	let c;
			    	context.strokeStyle = ph.colour;
			    	context.fillStyle = ph.colour;
			    	context.lineWidth = ph.lineWidth;
			    	context.beginPath();
				    ph.points.map(p => p(t/duration)).forEach(function(p, i) {
				      context[i == 0 ? "moveTo" : "lineTo"](...p);
				      if(i == ph.points.length-1) c = p;
				    });
				    context.stroke();
				    context.beginPath();
			      context.arc(...c, 4, 0, Math.PI * 2);
			      context.globalAlpha = 0.6;
			      context.fill();
			      context.globalAlpha = 1;
			      context.lineWidth = 1;
			      context.stroke();
			    });
		    	
		    }
		    
		  },(duration/ticks));
	}

	// Path string generator for old paths
	let lineGen1 = d3.line()
		// .curve(d3.curveStepAfter)
		.x(d => x0(d[xVar0]))
		.y(d => y0(d[yVar0]));

	// Path string generator for new paths
	let lineGen2 = d3.line()
		// .curve(d3.curveStepAfter)
		.x(d => x(d[xVar]))
		.y(d => y(d[yVar]));

	// Create and populate an array of old and new paths
	let pathPairs = [];
	linesData.forEach(l => {
		pathPairs.push([lineGen1(l.values), lineGen2(l.values), l.colour, l.strokeWidth])
	});

	// Update voronoi polygon generator
	// voronoi
	// .x(d => x(d[xVar]))
	// .y(d => y(d[yVar]));

	// Update quadtree
	quadtree = d3.quadtree()
    .x(d => x(d[xVar]))
    .y(d => y(d[yVar]))
    .addAll(data);

	// Re-draw voronoi
	// contextHover.clearRect(0, 0, scaledWidth, scaledHeight);
	// voronoi.polygons(data).forEach((d,i) => {
	// 	contextHover.fillStyle = data[i].pointID;
	// 	contextHover.strokeStyle = data[i].pointID;
	// 	contextHover.lineWidth = 0.5;
	// 	contextHover.beginPath();
	// 	pathVoronoi(d);
	// 	contextHover.fill();
	// 	contextHover.stroke();
	// });

	// Update path generator
	path
		.x(d => x(d[xVar]))
		.y(d => y(d[yVar]));

	// Update overlay path generator
	pathOverlay
		.x(d => x(d[xVar]))
		.y(d => y(d[yVar]));

	// Reposition permaLabels

	d3.selectAll("text.permaLabel")
		.transition()
		.ease(d3.easeLinear)
		.duration(1000)
		.attr("transform", d => `translate(${x(d.lastVal[xVar])}, ${y(d.lastVal[yVar])})`);

	if(x0 != x){
		d3.select(".axis.x").transition().duration(1000).call(d3.axisBottom(x).ticks(5).tickFormat(xFormat));
	}

	// Update mouse events
	canvas.on("mousemove", () => {
				
		contextOverlay.clearRect(0, 0, scaledWidth, scaledHeight);

		let coords = d3.mouse(canvas.node());
		let absX = d3.event.clientX;
		// let pixCol = contextHover.getImageData(coords[0]*PR, coords[1]*PR, 1, 1).data;
		// pixCol = `rgb(${pixCol[0]},${pixCol[1]},${pixCol[2]})`;
		// let dataPoint = data.filter(d => d.pointID == pixCol)[0];
		let dataPoint = quadtree.find((coords[0]), (coords[1]), width/6);
		if(dataPoint == undefined){
			contextOverlay.clearRect(0, 0, scaledWidth, scaledHeight);
			tooltip
				.styles({
					display: "none"
				})
				.select(".inner")
				.html("");
				svg.selectAll(".permaLabel").attrs({display: "block"});
		}else{
		let dataID = dataPoint.id;
		let dataGroup = linesData.filter(d => d.key == dataID)[0];

		tooltip
				.styles({
					left: `${x(dataPoint[xVar])}px`,
					top: `${y(dataPoint[yVar])}px`,
					display: "block"
				})
				.select(".inner")
				.styles({
					left: absX < 135 ? "5px":"",
					right: absX < 135 ? "":"5px",
					bottom: absX < 135 ? "":"5px",
					top: absX < 135 ? "5px":""
				})
				.html(toolTipper(dataGroup, yVar));

		[dataGroup].forEach((d,i) => {
			contextOverlay.strokeStyle = "white";
			contextOverlay.lineWidth = d.strokeWidth + 6;
			contextOverlay.beginPath();
			pathOverlay(d.values);
			contextOverlay.stroke();
			// contextOverlay.strokeStyle = colours.domain().includes(dataPoint.name) ? colours(dataPoint.name):"#212121";
			contextOverlay.strokeStyle = "#212121";
			contextOverlay.lineWidth = 5;
			contextOverlay.beginPath();
			pathOverlay(d.values);
			contextOverlay.stroke();
		});

	[dataGroup].forEach((d,i) => {
			contextOverlay.lineWidth = 1;
			// contextOverlay.fillStyle = colours.domain().includes(dataPoint.name) ? colours(dataPoint.name):"#212121";
			contextOverlay.fillStyle = "#212121";
			contextOverlay.beginPath();
	    contextOverlay.arc(x(d.lastVal[xVar]), y(d.lastVal[yVar]), 5, 0, Math.PI * 2);
	    contextOverlay.fill();
		});

	d3.selectAll("text.permaLabel")
			.attrs({
				display: d => d.lastVal.name == dataPoint.name ? "none":"block"
			});
		}
	});

	canvas.on("mouseout", () => {
		contextOverlay.clearRect(0, 0, scaledWidth, scaledHeight);
		tooltip
			.styles({
				display: "none"
			})
			.select(".inner")
			.html("");
		svg.selectAll(".permaLabel").attrs({display: "block"});
	});

	pathTween(pathPairs, 4, 50, 1000);
}