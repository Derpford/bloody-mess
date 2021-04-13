class BloodySoul : LostSoul replaces LostSoul
{
	mixin BloodyMonster;

	default
	{
		BloodySoul.StaggerHealth 80;
		BloodySoul.BonusDrops 0,0; // No soulspam 4 u!
	}

	states
	{
		Stagger:
			SKUL EEEEEEEE 8
			{
				A_Pain();
				angle += 360.0/4.0;
			}
			Goto See;
	}
}