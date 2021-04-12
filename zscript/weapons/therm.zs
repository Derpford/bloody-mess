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
				A_WeaponOffset(0,12,WOF_ADD);
				A_StartSound("weapon/thermf");
			}
			NLSG C 2 A_WeaponOffset(0,8,WOF_ADD);
			NLSG A 5;
			NLSG A 8 A_WeaponOffset(0,-10,WOF_ADD);
			NLSG A 5;
			NLSG A 6 A_WeaponOffset(0,-10,WOF_ADD);
			Goto Ready;
	}
	
}