import module namespace gpxquery = "https://github.com/dret/GPXQuery" at "GPXQuery.xq";

declare namespace gpx = "http://www.topografix.com/GPX/1/1";

declare variable $GPX := doc('demo.gpx')/gpx:gpx;

<html>
    <head><title>GPXQuery Demo</title></head>
    <body>
        <dl>
            <dd>GPX Track Name(s):</dd>
            <dt> <ol> {
                for $trk-name in gpxquery:trk-name($GPX) 
                return <li> { $trk-name } </li>
            } </ol> </dt>
        </dl>
    </body>
</html>

