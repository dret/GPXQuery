import module namespace gpxquery = "https://github.com/dret/GPXQuery" at "GPXQuery.xq";

declare namespace gpx = "http://www.topografix.com/GPX/1/1";

declare variable $GPX := doc('demo.gpx')/gpx:gpx;
declare variable $dateTime-format := "[MNn] [D], [Y]; [H]:[m]:[s] [z]";

<html>
    <head>
        <title>GPXQuery Demo</title>
        <style>th, td {{ padding: 5px; border: 1px solid gray ; }} </style>
    </head>
    <body>
        <h1>GPXQuery Demo: GPX Track Information</h1>
        <table>
            <tr>
                <th>Nr.</th>
                <th>Name</th>
                <th>Segments</th>
                <th>Points</th>
                <th>Distance (m)</th>
                <th>Ascent (m)</th>
                <th>Descent (m)</th>
                <th>Start Time</th>
                <th>End Time</th>
                <th>Duration</th>
            </tr>
            { for $trk in 1 to gpxquery:trk-count($GPX) return
                <tr>
                    <td> { $trk } </td>
                    <td> { gpxquery:trk-names($GPX)[$trk] } </td>
                    <td> { gpxquery:trk-segments($GPX)[$trk] } </td>
                    <td> { gpxquery:trk-points($GPX)[$trk] } </td>
                    <td> { gpxquery:trk-distance($GPX)[$trk] } </td>
                    <td> { gpxquery:trk-ascent($GPX)[$trk] } </td>
                    <td> { gpxquery:trk-descent($GPX)[$trk] } </td>
                    <td> { fn:format-dateTime(gpxquery:trk-start($GPX)[$trk], $dateTime-format) } </td>
                    <td> { fn:format-dateTime(  gpxquery:trk-end($GPX)[$trk], $dateTime-format) } </td>
                    <td> { gpxquery:trk-end($GPX)[$trk] - gpxquery:trk-start($GPX)[$trk] } </td>
                </tr>
            }
        </table>
    </body>
</html>
