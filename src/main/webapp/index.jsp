<%@page import="org.neo4j.graphdb.factory.GraphDatabaseFactory"%>
<%@page import="org.neo4j.cypher.javacompat.ExecutionEngine"%>
<%@page import="org.neo4j.graphdb.GraphDatabaseService"%>
<%@page import="com.mycompany.finaljavaneoservlet.NeoUtilities"%>
<%@page import="com.mycompany.finaljavaneoservlet.NeoUtiliSessionBean"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="javax.naming.NamingException"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="style.css">
        <link rel="stylesheet" href="style.css" type="text/css"/>
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
        <script src="//code.jquery.com/jquery-1.10.2.js"></script>
        <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
        <script src="//d3js.org/d3.v3.min.js" charset="utf-8"></script>
        <title>SAP Home</title>
    </head>
    <body>       
        <form method="Post" action="NewServlet">
            <fieldset  class="align-center">
                <legend>Product Finder</legend>
                <br>
                <label for="search_string">*Search: </label>
                <input type="text" name="search_string" id="search_string">
                <br> <br> <br>
                <label for="known_string">*What product do you see in front of you? </label>
                <input type="text" name="known_string" id="known_string">
                <br><br> <br>
                <input type="submit" class="button-0" id= "searchButton" value="Submit">
                <div id="chart" align="center"></div>
            </fieldset>
        </form>
        <script>
            $(document).ready(function () {

                var availableTags = [
                    "Apple",
                    "Orange Juice",
                    "Pils",
                    "Water",
                    "Fish",
                    "Bread",
                    "Milk",
                    "Pesto",
                    "Pasta",
                    "Yoghurt",
                    "Cauliflower",
                    "Cigars",
                    "Tissues"
                ];
                $("#search_string").autocomplete({
                    source: availableTags
                });
                $("#known_string").autocomplete({
                    source: availableTags
                });

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



            });
        </script>
    </body>
</html>
