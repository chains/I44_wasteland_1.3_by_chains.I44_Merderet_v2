//	@file Version: 1.0
//	@file Name: mission_Heavy.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 08/12/2012 03:25
//	@file Args:
#include "setup.sqf"
#include "mainMissionDefines.sqf";

if(!isServer) exitwith {};
private ["_result","_missionMarkerName","_missionType","_startTime","_returnData","_randomPos","_randomIndex","_vehicleClass","_base","_veh","_picture","_vehicleName","_hint","_currTime","_playerPresent","_unitsAlive"];

//Mission Initialization.
_result = 0;
_missionMarkerName = "Outpost_Marker";
_missionType = "Heavy Weapons";
#ifdef __A2NET__
_startTime = floor(netTime);
#else
_startTime = floor(time);
#endif

diag_log format["WASTELAND SERVER - Main Mission Started: %1",_missionType];

//Get Mission Location
_returnData = call createMissionLocation;
_randomPos = _returnData select 0;
_randomIndex = _returnData select 1;

diag_log format["WASTELAND SERVER - Main Mission Waiting to run: %1",_missionType];
[mainMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Main Mission Resumed: %1",_missionType];

[_missionMarkerName,_randomPos,_missionType] call createClientMarker;

_veh = ["HeavyWeapons", "HeavyWeapons2", "HeavyWeapons3"] call BIS_fnc_selectRandom;
_base = [_veh, 0, _randomPos] execVM "server\functions\createOutpost.sqf";

_vehicleName = "Heavy Weapons Depot";
_hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>A<t color='%3'> %2</t> has been spotted near the marker!</t>", _missionType, _vehicleName, mainMissionColor, subTextColor];
[nil,nil,rHINT,_hint] call RE;

CivGrpL = createGroup civilian;
[CivGrpL,_randomPos] spawn createLargeGroup;

diag_log format["WASTELAND SERVER - Main Mission Waiting to be Finished: %1",_missionType];
#ifdef __A2NET__
_startTime = floor(netTime);
#else
_startTime = floor(time);
#endif
waitUntil
{
    sleep 1; 
	_playerPresent = false;
	#ifdef __A2NET__
	_currTime = floor(netTime);
	#else
    _currTime = floor(time);
	#endif
    if(_currTime - _startTime >= mainMissionTimeout) then {_result = 1;};
    _unitsAlive = ({alive _x} count units CivGrpL);
    (_result == 1) OR (_unitsAlive < 1)
};

if(_result == 1) then
{
	_hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>Objective failed. Enemy airstrike inbound!</t>", _missionType, _vehicleName, failMissionColor, subTextColor];
	[nil,nil,rHINT,_hint] call RE;
    
    sleep 20;
    
	//Mission Failed. Firstly obliterate the site.
    _bomb = "Bo_GBU12_LGB" createVehicle [(_randomPos select 0),(_randomPos select 1), 50]; 
    sleep 1;
    _bomb = "Bo_GBU12_LGB" createVehicle [(_randomPos select 0) + 5,(_randomPos select 1) - 5, 50];
    sleep 1;
    _bomb = "Bo_GBU12_LGB" createVehicle [(_randomPos select 0),(_randomPos select 1) + 10, 50];
    
    sleep 10;
    
    _baseToDelete = nearestObjects [_randomPos, ["All"], 22];
    { deleteVehicle _x; } forEach _baseToDelete;
    
    {deleteVehicle _x;}forEach units CivGrpL;
    deleteGroup CivGrpL;
    
    diag_log format["WASTELAND SERVER - Main Mission Failed: %1",_missionType];
} else {
	//Mission Complete.
    deleteGroup CivGrpL;
    _hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>The heavy weapons have been captured.</t>", _missionType, _vehicleName, successMissionColor, subTextColor];
	[nil,nil,rHINT,_hint] call RE;
    diag_log format["WASTELAND SERVER - Main Mission Success: %1",_missionType];
};

//Reset Mission Spot.
MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;