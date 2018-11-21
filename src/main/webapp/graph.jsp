<%-- 
    Document   : graph
    Created on : Mar 31, 2016, 10:10:16 AM
    Author     : D064548
--%>

<%@page import="java.util.Arrays"%>
<%@page import="com.mycompany.finaljavaneoservlet.GraphInterface"%>
<%@page import="javax.ejb.EJB"%>
<%@page import="com.mycompany.finaljavaneoservlet.GraphSessionBean"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Graph Page</title>
        <%

            GraphInterface graphSessionBean = new GraphSessionBean();
            String queryResponse = request.getAttribute("graphData").toString();
            //out.println(queryResponse);
            String[] graphData = graphSessionBean.getDataForGraph(queryResponse);

            String[] textResponse = graphSessionBean.getSimpleGuidedText(queryResponse);
            //out.println(textResponse);
            Integer count = 0;
            for (String name : textResponse) {
                count++;
                //out.println("<b>"+"<br>" + count + ": " + name);
                out.println("<span style=\"font-weight:bold; color:#000080; font-size: 20px \">" + count + ": " + name + " </span>");
                out.println("<br>");
            }

        %>

        <link rel="stylesheet" type="text/css" href="style.css">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
        <script src="//code.jquery.com/jquery-1.10.2.js"></script>
        <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
        <script src="//d3js.org/d3.v3.min.js" charset="utf-8"></script>
        <script>
            function drawGraph()
            {
                var data = '<%=Arrays.toString(graphData)%>';
                console.log(data);
                var ele = eval("(" + data + ")");
                var productData = [];
                var path = [];
                var item;
                console.log(JSON.stringify(ele[0]));
                var samplePathResponse = ele;
                var frameOfReferenceData = [{"polyline": [{"x": 30, "y": 40}, {"x": 30, "y": 460}, {"x": 190, "y": 460}],
                        "color": "#000080"} // left contingous wall
                    , {"polyline": [{"x": 40, "y": 40}, {"x": 40, "y": 450}, {"x": 190, "y": 450}],
                        "color": "LightBlue"} // left continous shelf 
                    , {"polyline": [{"x": 150, "y": 40}, {"x": 590, "y": 40}, {"x": 590, "y": 450}],
                        "color": "#000080"} // right continous wall
                    , {"polyline": [{"x": 150, "y": 50}, {"x": 580, "y": 50}, {"x": 580, "y": 450}],
                        "color": "LightBlue"} // right contingous shelf
                    , {"polyline": [{"x": 200, "y": 130}, {"x": 200, "y": 270}],
                        "color": "#000080"} // mid left wall
                    , {"polyline": [{"x": 190, "y": 130}, {"x": 190, "y": 270}],
                        "color": "LightBlue"} // mid left wall - left shelf
                    , {"polyline": [{"x": 210, "y": 130}, {"x": 210, "y": 270}],
                        "color": "LightBlue"} // mid left wall - right shelf
                    , {"polyline": [{"x": 410, "y": 130}, {"x": 410, "y": 270}],
                        "color": "#000080"} // mid right wall
                    , {"polyline": [{"x": 400, "y": 130}, {"x": 400, "y": 270}],
                        "color": "LightBlue"} // mid right wall - left shelf
                    , {"polyline": [{"x": 420, "y": 130}, {"x": 420, "y": 270}],
                        "color": "LightBlue"} // mid right wall - right shelf
                    , {"polyline": [{"x": 190, "y": 350}, {"x": 190, "y": 510}],
                        "color": "#98AFC7"} // left cash counter
                    , {"polyline": [{"x": 200, "y": 350}, {"x": 200, "y": 450}],
                        "color": "LightBlue"} // shelf of left cash counter
                    , {"polyline": [{"x": 400, "y": 350}, {"x": 400, "y": 510}],
                        "color": "#98AFC7"} // right cash counter
                    , {"polyline": [{"x": 410, "y": 350}, {"x": 410, "y": 450}],
                        "color": "LightBlue"}]; // shelf of right cash counter

                var max_x = 0;
                var max_y = 0;
                var temp_x, temp_y;

                for (var i = 0; i < frameOfReferenceData.length; i++) {
                    for (var j = 0; j < frameOfReferenceData[i].polyline.length; j++) {

                        temp_x = frameOfReferenceData[i].polyline[j].x;
                        temp_y = frameOfReferenceData[i].polyline[j].y;

                        if (temp_x >= max_x) {
                            max_x = temp_x;
                        }
                        if (temp_y >= max_y) {
                            max_y = temp_y;
                        }
                    }
                }

                var svgContainer = d3.select("#chart").append("svg")
                        .attr("width", max_x + 100)
                        .attr("height", max_y + 100);

                var lineFunction = d3.svg.line()
                        .x(function (d) {
                            return d.x;
                        })
                        .y(function (d) {
                            return d.y;
                        })
                        .interpolate("linear");

                for (var idx = 0; idx < frameOfReferenceData.length; idx++) {
                    svgContainer.append("path")
                            .attr("d", lineFunction(frameOfReferenceData[idx].polyline))
                            .attr("stroke", frameOfReferenceData[idx].color)
                            .attr("stroke-width", 10)
                            .attr("fill", "none");
                }

                var productData = [];
                var path = [];
                var item;

                item = samplePathResponse.splice(0, 1);
                productData.push(item[0]);

                item = samplePathResponse.splice(samplePathResponse.length - 1, 1);
                productData.push(item[0]);

                for (var idx = 0; idx < samplePathResponse.length; idx++) {
                    item = samplePathResponse.splice(0, 1);
                    idx = idx - 1;
                    path.push(item[0]);
                }

                svgContainer.selectAll("text")
                        .data(productData)
                        .enter()
                        .append("text")
                        .attr("x", function (d) {
                            return d.x;
                        })
                        .attr("y", function (d) {
                            return d.y;
                        })
                        .text(function (d) {
                            return d.name;
                        })
                        .attr("font-family", "Helvetica")
                        .attr("font-size", "15px")
                        .attr("fill", "#C11B17");

                svgContainer.append("path")
                        .attr("d", lineFunction(path))
                        .attr("stroke", "#C11B17")
                        .attr("stroke-width", 5)
                        .attr("fill", "none");


                svgContainer.selectAll("scatter-dots")
                        .data(path)
                        .enter()
                        .append("circle")
                        .attr("cx", function (d) {
                            return d.x;
                        })
                        .attr("cy", function (d) {
                            return d.y;
                        })
                        .attr("r", 10)
                        ;
            }
            ;
        </script>
    </head>
    <body>
        <h1></h1>
        <input type="submit" class="button-0" value="Display Route" onclick="drawGraph()" />
        <div id="chart" align="center"></div>
    </body>

</html>
