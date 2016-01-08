import module namespace gpxquery = "https://github.com/dret/GPXQuery" at "GPXQuery.xq" ;

declare namespace gpxquery-demo = "https://github.com/dret/GPXQuery-demo" ;
declare namespace xsd           = "http://www.w3.org/2001/XMLSchema" ;
declare namespace gpx           = "http://www.topografix.com/GPX/1/1" ;

declare variable $GPX := doc('demo.gpx')/gpx:gpx ;
declare variable $dateTime-format := "[MNn] [D], [Y]; [H]:[m]:[s] [z]" ;
declare variable $moving-threshold := 5.0 ;

declare function gpxquery-demo:format-duration($duration as xs:duration)
    as xs:string
{
    fn:format-time(xs:dayTimeDuration($duration) + xs:time("00:00:00Z"), "[H1]h [m1]m [s1]s")
} ;


<html>
    <head>
        <title>GPXQuery Demo</title>
        <style>th, td {{ padding: 5px; border: 1px solid gray ; }} </style>
    </head>
    <body>
        <h1>GPXQuery Demo</h1>
        <h2>GPX Track Information</h2>
        <table>
            <tr>
                <th>Nr.</th>
                <th>Name</th>
                <th>Segments/<br/>Points</th>
                <th>Distance<br/>(km)</th>
                <th>Ascent (m)/<br/>Descent (m)</th>
                <th>Min. Elevation (m)/<br/>Max. Elevation (m)</th>
                <th>Start Time</th>
                <th>End Time</th>
                <th>Total Time</th>
                <th>Moving Time<br/>({ $moving-threshold } km/h threshold)</th>
                <th>Bounding Box</th>
            </tr>
            { for $trk in 1 to gpxquery:trk-count($GPX) return
                <tr>
                    <td> { $trk } </td>
                    <td> { gpxquery:trk-names($GPX)[$trk] } </td>
                    <td> { gpxquery:trk-segments($GPX)[$trk] } / { gpxquery:trk-points($GPX)[$trk] } </td>
                    <td> { xsd:int(gpxquery:trk-distance($GPX)[$trk]) div 1000 } </td>
                    <td> { xsd:int(gpxquery:trk-ascent($GPX)[$trk]) } / { xsd:int(gpxquery:trk-descent($GPX)[$trk]) } </td>
                    <td> { xsd:int(gpxquery:trk-min-elevation($GPX)[$trk]) } / { xsd:int(gpxquery:trk-max-elevation($GPX)[$trk]) } </td>
                    <td> { fn:format-dateTime(gpxquery:trk-start($GPX)[$trk], $dateTime-format) } </td>
                    <td> { fn:format-dateTime(  gpxquery:trk-end($GPX)[$trk], $dateTime-format) } </td>
                    <td> { gpxquery-demo:format-duration(gpxquery:trk-end($GPX)[$trk] - gpxquery:trk-start($GPX)[$trk]) } </td>
                    <td> { gpxquery-demo:format-duration(gpxquery:moving-time($GPX, $moving-threshold)[$trk]) } </td>
                    <td> { let $bbox := gpxquery:bbox($GPX, $trk) return
                           <a href="http://mvjantzen.com/tools/map.php?width=900&amp;height=600&amp;top={$bbox[1]}&amp;left={$bbox[2]}&amp;bottom={$bbox[3]}&amp;right={$bbox[4]}" title="{$bbox}">Map</a>
                         }
                    </td>
                </tr>
            }
        </table>
        { if ( not(empty(gpxquery:waypoints($GPX))) ) then (
            <h2>Waypoints</h2> ,
            <ol> { for $wpt in gpxquery:waypoints($GPX) return
                <li>
                  <b> { $wpt/gpx:name/text() } </b>
                  { if ( exists($wpt/gpx:desc) ) then ( ": ", $wpt/gpx:desc/text() ) else () }
                </li> }
            </ol> )
        else () }
    </body>
</html>
