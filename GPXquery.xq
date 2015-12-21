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
