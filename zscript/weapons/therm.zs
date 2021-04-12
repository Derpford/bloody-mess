class ThermiteGrinder : Weapon replaces SuperShotgun
{
	// A device that grinds iron scrap into thermite, lobbing molten firebombs.
	// Like a GL, but like, on fire.

	mixin Spinner;

	default
	{
		Weapon.SlotNumber 2;
	}

	states
	{
		Spawn:
			NLSG D -1;
			Stop;
		Select:
			NLSG A 1 A_Raise(18);
			Loop;
		Deselect:
			NLSG A 1 A_Lower(18);
			Loop;
		Ready:
			NLSG A 1 A_WeaponReady();
			Loop;
		Fire:
			NLSG B 2
			{
				// Shot goes here.
				A_StartSound("weapons/thermf");
			}
			NLSG C 3;
			NLSG A 5;
			Goto Ready;
	}
	
}