/*
 * Author: commy2, Jonpas
 * Fixes position of an object. E.g. moves object above ground and adjusts to terrain slope. Requires local object.
 *
 * Arguments:
 * Object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * bob call ace_common_fnc_fixPosition
 *
 * Public: No
 */
#include "script_component.hpp"

// setVectorUp requires local object
if (!local _this) exitWith {};

// Objects with disabled simulation and objects with simulation type "house" don't have gravity/physics, so make sure they are not floating
private _hasGravity = simulationEnabled _this && {getText (configFile >> "CfgVehicles" >> typeOf _this >> "simulation") != "house"};

if (!_hasGravity) then {
    private _posAbove = (getPosATL _this) select 2;
    TRACE_2("house",_this,_posAbove);
    if (_posAbove > 0.1) then {
        private _newPosATL = (getPosATL _this) vectorDiff [0, 0, _posAbove];
        _this setPosATL _newPosATL;
    };
};

private _position = getPosATL _this;

// Don't place the object below the ground
if (_position select 2 < -0.1) then {
    _position set [2, -0.1];
    _this setPosATL _position;
};

// Adjust position to sloped terrain, if placed on ground
// Object without gravity/physics may have negative height when placed on slope, but those objects are definitely on the ground
if (!_hasGravity || {getPosATL _this select 2 == _position select 2}) then {
    _this setVectorUp surfaceNormal _position;
};
