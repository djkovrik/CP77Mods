public native struct gameRange {
	native let minValue : Float;
	native let maxValue : Float;
}

public native class gameMinimapSettings {
	native let globalVisionRadiusBounds : gameRange;
	native let visionRadiusVehicle : gameRange;
	native let visionRadiusCombat : gameRange;
	native let visionRadiusQuestArea : gameRange;
	native let visionRadiusSecurityArea : gameRange;
	native let visionRadiusInterior : gameRange;
	native let visionRadiusExterior : gameRange;
	native let speedBoundsSprint : gameRange;
	native let speedBoundsVehicle : gameRange;
	native let smoothingStrengthOnZoomIn : Float;
	native let smoothingStrengthOnZoomOut : Float;
	native let playerMarkerTransitionSpeedOnVehicleMount : Float;
	native let playerMarkerTransitionSpeedOnVehicleUnmount : Float;
	native let visionRadiusLocked : Bool;
	native let dynamicVisionRadiusEnabled : Bool;
	native let smoothingEnabled : Bool;
}

@addField(MinimapContainerController)
public native let settings: ref<gameMinimapSettings>;
