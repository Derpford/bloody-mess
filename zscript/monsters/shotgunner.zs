class BloodyShotgunner : ShotgunGuy replaces ShotgunGuy
{
	mixin BloodyMonster;

	default
	{
		BloodyShotgunner.StaggerHealth 20,-1;
		BloodyShotgunner.BonusDrops 1,2;	
	}

	states
	{
		Stagger:
			SPOS G 5 { A_Pain(); }
			SPOS H 4;
			SPOS DCBA 2 { Thrust(-3,angle); }
			SPOS A 4 A_Pain();
			Goto See;
	}
}