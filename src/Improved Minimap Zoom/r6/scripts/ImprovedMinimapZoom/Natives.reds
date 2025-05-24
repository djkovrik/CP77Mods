public native class gameMinimapSettings {
	native let globalVisionRadiusBounds : Range;
	native let visionRadiusVehicle : Range;
	native let visionRadiusCombat : Range;
	native let visionRadiusQuestArea : Range;
	native let visionRadiusSecurityArea : Range;
	native let visionRadiusInterior : Range;
	native let visionRadiusExterior : Range;
	native let speedBoundsSprint : Range;
	native let speedBoundsVehicle : Range;
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
