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
			BOSS A 4;
			BOSS A 18 { vel.z = 10; A_StartSound("baron/sight"); }
			BOSS H 4 { A_StartSound("weapons/rocklx"); A_Explode(128,flags:XF_NOTMISSILE); }
			Goto See;
	}
}