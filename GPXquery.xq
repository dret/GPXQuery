module namespace gpxquery = "https://github.com/dret/GPXQuery";

declare namespace xsd = "http://www.w3.org/2001/XMLSchema";
declare namespace math = "http://www.w3.org/2005/xpath-functions/math";

declare namespace local = "local:functions";

declare namespace gpx = "http://www.topografix.com/GPX/1/1";
declare namespace gpxtpx = "http://www.garmin.com/xmlschemas/TrackPointExtension/v1";

declare function gpxquery:trk-count($gpx as element(gpx:gpx))
    as xsd:integer
{
    count($gpx/gpx:trk)
};

declare function gpxquery:trk-name($gpx as element(gpx:gpx))
    as xsd:string*
{
    $gpx/gpx:trk/gpx:name/text()
};
