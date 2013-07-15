//	@file Version: 1.0
//	@file Name: createTownMarkers.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 28/11/2012 05:19
//	@file Args:

{
    _pos = getMarkerPos (_x select 0);
    _townname = _x select 2;
    _markerName = format["marker%1",_forEachIndex];
	_marker = createMarkerLocal [_markerName, _pos];
	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerSizeLocal [_x select 1, _x select 1];
	_marker setMarkerColorLocal "ColorBlack";
    _marker setMarkerBrushLocal "SolidBorder";
	_marker setMarkerAlphaLocal 0.3;

	_markerName2 = format["marker_shop_title_%1",_x];
    deleteMarkerLocal _markerName2;
    _marker2 = createMarkerLocal [_markerName2, _pos];
	_markerName2 setMarkerShapeLocal "ICON";
    _markerName2 setMarkerTypeLocal "Dot";
    _markerName2 setMarkerColorLocal "ColorBlack";
	_markerName2 setMarkerSizeLocal [1,1];
	_markerName2 setMarkerTextLocal _townname;   

}forEach cityList;