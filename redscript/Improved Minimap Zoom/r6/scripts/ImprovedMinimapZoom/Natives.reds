public native class gameMinimapSettings {
	public native let globalVisionRadiusBounds : Range;
	public native let visionRadiusVehicle : Range;
	public native let visionRadiusCombat : Range;
	public native let visionRadiusQuestArea : Range;
	public native let visionRadiusSecurityArea : Range;
	public native let visionRadiusInterior : Range;
	public native let visionRadiusExterior : Range;
	public native let speedBoundsSprint : Range;
	public native let speedBoundsVehicle : Range;
	public native let smoothingStrengthOnZoomIn : Float;
	public native let smoothingStrengthOnZoomOut : Float;
	public native let playerMarkerTransitionSpeedOnVehicleMount : Float;
	public native let playerMarkerTransitionSpeedOnVehicleUnmount : Float;
	public native let visionRadiusLocked : Bool;
	public native let dynamicVisionRadiusEnabled : Bool;
	public native let smoothingEnabled : Bool;
}

@if(!ModuleExists("Codeware"))
@addField(MinimapContainerController)
public native let settings: ref<gameMinimapSettings>;
