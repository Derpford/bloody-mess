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
			SKUL E 2 A_Pain();
			SKUL EEEEEEEEEEEE 4
			{
				angle += 360.0/6.0;
			}
			Goto See;
	}
}