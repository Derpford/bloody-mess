mixin class Spinner 
{
	// SpEeEeEen
	
	//double spinSpeed; // I can't actually set a default for properties in mixins...

	default
	{
		+WALLSPRITE;
	}

	override void Tick()
	{
		angle += 12.0;
	}
}