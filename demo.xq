import module namespace gpxquery = "https://github.com/dret/GPXQuery" at "GPXQuery.xq";

declare namespace gpx = "http://www.topografix.com/GPX/1/1";

declare variable $GPX := doc('demo.gpx')/gpx:gpx;

<html>
    <head><title>GPXQuery Demo</title></head>
    <body>
        <h1>GPX Track Information</h1>
        <table>
            <tr>
                <th>Nr.</th>
                <th>Name</th>
                <th>Segments</th>
                <th>Points</th>
                <th>Start Time</th>
                <th>End Time</th>
            </tr>
            { for $trk in 1 to gpxquery:trk-count($GPX) return
                <tr>
                    <td> { $trk } </td>
                    <td> { gpxquery:trk-names($GPX)[$trk] } </td>
                    <td> { gpxquery:trk-segments($GPX)[$trk] } </td>
                    <td> { gpxquery:trk-start($GPX)[$trk] } </td>
                    <td> { gpxquery:trk-end($GPX)[$trk] } </td>
                </tr>
            }
        </table>
    </body>
</html>
