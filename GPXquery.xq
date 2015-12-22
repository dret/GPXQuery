module namespace gpxquery = "https://github.com/dret/GPXQuery";

declare namespace xsd = "http://www.w3.org/2001/XMLSchema";
declare namespace math = "http://www.w3.org/2005/xpath-functions/math";

declare namespace gpx = "http://www.topografix.com/GPX/1/1";
declare namespace gpxtpx = "http://www.garmin.com/xmlschemas/TrackPointExtension/v1";

declare function gpxquery:trk-count($gpx as element(gpx:gpx))
    as xsd:integer
{
    count($gpx/gpx:trk)
};

declare function gpxquery:trk-names($gpx as element(gpx:gpx))
    as xsd:string*
{
    $gpx/gpx:trk/gpx:name/text()
};

declare function gpxquery:trk-segments($gpx as element(gpx:gpx))
    as xsd:integer*
{
    for $trk in 1 to count($gpx/gpx:trk)
        return count($gpx/gpx:trk[$trk]/gpx:trkseg)
};

declare function gpxquery:trk-points($gpx as element(gpx:gpx))
    as xsd:integer*
{
    for $trk in 1 to count($gpx/gpx:trk)
        return count($gpx/gpx:trk[$trk]/gpx:trkseg/gpx:trkpt)
};

declare function gpxquery:trk-start($gpx as element(gpx:gpx))
    as xsd:dateTime*
{
    for $trk in 1 to count($gpx/gpx:trk)
        return $gpx/gpx:trk[$trk]/gpx:trkseg[1]/gpx:trkpt[1]/gpx:time/text()
};

declare function gpxquery:trk-end($gpx as element(gpx:gpx))
    as xsd:dateTime*
{
    for $trk in 1 to count($gpx/gpx:trk)
        return $gpx/gpx:trk[$trk]/gpx:trkseg[last()]/gpx:trkpt[last()]/gpx:time/text()
};

declare function gpxquery:trk-ascent($gpx as element(gpx:gpx))
    as xsd:float*
{
    for $trk in 1 to count($gpx/gpx:trk)
        return sum(gpxquery:trk-ascent-recurse($gpx/gpx:trk[$trk]/gpx:trkseg/gpx:trkpt/gpx:ele/text()))
};

declare function gpxquery:trk-ascent-recurse($eles as xsd:float*)
    as xsd:float*
{
    if ( count($eles) le 1 )
      then 0
      else (
          if ( ($eles[2] - $eles[1]) gt 0.0 ) then $eles[2] - $eles[1] else 0.0 ,
          gpxquery:trk-ascent-recurse($eles[position() gt 1])
      )
};

declare function gpxquery:trk-descent($gpx as element(gpx:gpx))
    as xsd:float*
{
    for $trk in 1 to count($gpx/gpx:trk)
        return sum(gpxquery:trk-descent-recurse($gpx/gpx:trk[$trk]/gpx:trkseg/gpx:trkpt/gpx:ele/text()))
};

declare function gpxquery:trk-descent-recurse($eles as xsd:float*)
    as xsd:float*
{
    if ( count($eles) le 1 )
      then 0
      else (
          if ( ($eles[1] - $eles[2]) gt 0.0 ) then $eles[1] - $eles[2] else 0.0 ,
          gpxquery:trk-descent-recurse($eles[position() gt 1])
      )
};

declare function gpxquery:trk-distance($gpx as element(gpx:gpx))
    as xsd:float*
{
    for $trk in 1 to count($gpx/gpx:trk)
    let $trkpts := $gpx/gpx:trk[$trk]/gpx:trkseg/gpx:trkpt
    return sum(
        for $i in 1 to count($trkpts)-1
        return gpxquery:haversine($trkpts[$i]/@lat, $trkpts[$i]/@lon, $trkpts[$i+1]/@lat, $trkpts[$i+1]/@lon)
    )
};

declare function gpxquery:haversine($lat1 as xsd:float, $lon1 as xsd:float, $lat2 as xsd:float, $lon2 as xsd:float)
    as xsd:float
{
    (: This is the Haversine formula as described by http://stackoverflow.com/questions/365826/calculate-distance-between-2-gps-coordinates :)
    let $dlat  := ($lat2 - $lat1) * math:pi() div 180
    let $dlon  := ($lon2 - $lon1) * math:pi() div 180
    let $rlat1 := $lat1 * math:pi() div 180
    let $rlat2 := $lat2 * math:pi() div 180
    let $a     := math:sin($dlat div 2) * math:sin($dlat div 2) + math:sin($dlon div 2) * math:sin($dlon div 2) * math:cos($rlat1) * math:cos($rlat2)
    let $c     := 2 * math:atan2(math:sqrt($a), math:sqrt(1-$a))
    return xsd:float($c * 6371000.0)
};
