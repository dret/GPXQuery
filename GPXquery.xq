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
