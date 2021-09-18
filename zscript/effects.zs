mixin class Spinner 
{
	// SpEeEeEen
	
	//double spinSpeed; // I can't actually set a default for properties in mixins...

	default
	{
		+WALLSPRITE;
		+BRIGHT;
	}

	override void Tick()
	{
		angle += 12.0;
		Super.Tick();
	}
}

mixin class ShowAmount
{
	// Adds the item's amount to its pickup message.

	override String PickupMessage()
	{
		if(self is "ArmorBonus") 
		{ 
			let arm = ArmorBonus(self);
			return Super.PickupMessage().." ("..arm.saveamount..")"; 
		}
		else
		{
			return Super.PickupMessage().." ("..amount..")";
		}	
	}

}