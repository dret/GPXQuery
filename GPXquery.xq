module namespace gpxquery = "https://github.com/dret/GPXQuery";

declare namespace xsd = "http://www.w3.org/2001/XMLSchema";
declare namespace math = "http://www.w3.org/2005/xpath-functions/math";

declare namespace gpx = "http://www.topografix.com/GPX/1/1";
declare namespace gpxtpx = "http://www.garmin.com/xmlschemas/TrackPointExtension/v1";

(: Please keep in mind that all units are metric. There is no option for other units of measurements. :)

(: 
   in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
   out: Number of tracks contained in the GPX document (*not* the number of track segments).
:)
declare function gpxquery:trk-count($gpx as element(gpx:gpx))
    as xsd:integer
{
    count($gpx/gpx:trk)
};


(: 
   in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
   out: Sequence of waypoints, returning the original GPX data.
:)
declare function gpxquery:waypoints($gpx as element(gpx:gpx))
    as element(gpx:wpt)*
{
    $gpx/gpx:wpt
};


(: 
   in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
   out: Sequence of number of track segments per track, one value for each track.
:)
declare function gpxquery:trk-segments($gpx as element(gpx:gpx))
    as xsd:integer*
{
    for $trk in 1 to count($gpx/gpx:trk)
    return count($gpx/gpx:trk[$trk]/gpx:trkseg)
};


(: 
   in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
   out: Sequence of number of track points per track (ignoring segments), one value for each track.
:)
declare function gpxquery:trk-points($gpx as element(gpx:gpx))
    as xsd:integer*
{
    for $trk in 1 to count($gpx/gpx:trk)
    return count($gpx/gpx:trk[$trk]/gpx:trkseg/gpx:trkpt)
};


(: 
   in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
   out: Sequence of names of tracks as strings, as many values as there are tracks.
:)
declare function gpxquery:trk-names($gpx as element(gpx:gpx))
    as xsd:string*
{
    $gpx/gpx:trk/gpx:name/text()
};


(: 
   in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
   out: Sequence of start/first timestamp per track, as many values as there are tracks.
:)
declare function gpxquery:trk-start($gpx as element(gpx:gpx))
    as xsd:dateTime*
{
    for $trk in 1 to count($gpx/gpx:trk)
    return $gpx/gpx:trk[$trk]/gpx:trkseg[1]/gpx:trkpt[1]/gpx:time/text()
};


(: 
   in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
   out: Sequence of end/last timestamp per track, as many values as there are tracks.
:)
declare function gpxquery:trk-end($gpx as element(gpx:gpx))
    as xsd:dateTime*
{
    for $trk in 1 to count($gpx/gpx:trk)
    return $gpx/gpx:trk[$trk]/gpx:trkseg[last()]/gpx:trkpt[last()]/gpx:time/text()
};


(: 
   in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
   out: Sequence of minimum elevation per track, as many values as there are tracks.
:)
declare function gpxquery:trk-min-elevation($gpx as element(gpx:gpx))
    as xsd:double*
{
    for $trk in 1 to count($gpx/gpx:trk)
    return min($gpx/gpx:trk[$trk]/gpx:trkseg/gpx:trkpt/gpx:ele/text())
};


(: 
   in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
   out: Sequence of maximum elevation per track, as many values as there are tracks.
:)
declare function gpxquery:trk-max-elevation($gpx as element(gpx:gpx))
    as xsd:double*
{
    for $trk in 1 to count($gpx/gpx:trk)
    return max($gpx/gpx:trk[$trk]/gpx:trkseg/gpx:trkpt/gpx:ele/text())
};


(: 
   in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
   out: Sequence of total ascent per track, as many values as there are tracks.
:)
declare function gpxquery:trk-ascent($gpx as element(gpx:gpx))
    as xsd:double*
{
    for $trk in 1 to count($gpx/gpx:trk)
    let $eles := $gpx/gpx:trk[$trk]/gpx:trkseg/gpx:trkpt/gpx:ele/text()
    return sum(
        for $i in 1 to count($eles)-1
        let $ascent := $eles[$i+1]-$eles[$i]
        return if ( $ascent gt 0.0 ) then $ascent else 0.0
    )
};


(: 
   in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
   out: Sequence of total descent per track, as many values as there are tracks.
:)
declare function gpxquery:trk-descent($gpx as element(gpx:gpx))
    as xsd:double*
{
    for $trk in 1 to count($gpx/gpx:trk)
    let $eles := $gpx/gpx:trk[$trk]/gpx:trkseg/gpx:trkpt/gpx:ele/text()
    return sum(
        for $i in 1 to count($eles)-1
        let $descent := $eles[$i]-$eles[$i+1]
        return if ( $descent gt 0.0 ) then $descent else 0.0
    )
};


(: 
   in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
   out: Sequence of total distance per track, as many values as there are tracks.
:)
declare function gpxquery:trk-distance($gpx as element(gpx:gpx))
    as xsd:double*
{
    for $trk in 1 to count($gpx/gpx:trk)
    let $trkpts := $gpx/gpx:trk[$trk]/gpx:trkseg/gpx:trkpt
    return sum(
        for $i in 1 to count($trkpts)-1
        return gpxquery:haversine($trkpts[$i]/@lat, $trkpts[$i]/@lon, $trkpts[$i+1]/@lat, $trkpts[$i+1]/@lon)
    )
};


(: 
   in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element, and threshold speed (in km/h) for identifying "rest intervals".
   out: Sequence of moving time per track, calculated according to $moving-threshold, as many values as there are tracks.
:)
declare function gpxquery:moving-time($gpx as element(gpx:gpx), $moving-threshold as xs:double)
    as xsd:duration*
{
    for $trk in 1 to count($gpx/gpx:trk)
    return xs:duration("PT1S")
};


(:
  in:  Two points in decimal coordinates.
  out: The distance between the points (in meters) according to the Haversine formula as described by http://stackoverflow.com/questions/365826/calculate-distance-between-2-gps-coordinates
:)
declare function gpxquery:haversine($lat1 as xsd:double, $lon1 as xsd:double, $lat2 as xsd:double, $lon2 as xsd:double)
    as xsd:double
{
    let $dlat  := ($lat2 - $lat1) * math:pi() div 180
    let $dlon  := ($lon2 - $lon1) * math:pi() div 180
    let $rlat1 := $lat1 * math:pi() div 180
    let $rlat2 := $lat2 * math:pi() div 180
    let $a     := math:sin($dlat div 2) * math:sin($dlat div 2) + math:sin($dlon div 2) * math:sin($dlon div 2) * math:cos($rlat1) * math:cos($rlat2)
    let $c     := 2 * math:atan2(math:sqrt($a), math:sqrt(1-$a))
    return xsd:double($c * 6371000.0)
};


(:
  in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element, and the number of the track for which the bounding box should be returned.
  out: Return values are 4 xsd:double for the bounding box coordinates, first lat/lon of lower left, then lat/lon of upper right.
:)
declare function gpxquery:bbox($gpx as element(gpx:gpx), $trk as xsd:integer)
    as xsd:double+
{
    let $trkpts := $gpx/gpx:trk[$trk]/gpx:trkseg/gpx:trkpt
    return (
        min($trkpts/@lat),
        min($trkpts/@lon),
        max($trkpts/@lat),
        max($trkpts/@lon)
    )
};

