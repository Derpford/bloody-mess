class BloodyBaron : BaronOfHell replaces BaronOfHell
{
	mixin BloodyMonster;

	default
	{
		BloodyBaron.StaggerHealth 500,3;
		BloodyBaron.BonusDrops 3,6;
	}

	states
	{
		Stagger:
			BOSS H 2;
			BOSS H 2 A_Pain();
			BOSS A 6;
			BOSS H 4 { A_StartSound("baron/sight"); A_Explode(128); }
			Goto See;
	}
}