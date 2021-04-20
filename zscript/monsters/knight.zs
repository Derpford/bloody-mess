class BloodyKnight : HellKnight replaces HellKnight
{
	mixin BloodyMonster;

	default
	{
		BloodyKnight.StaggerHealth 250,3;
		BloodyKnight.BonusDrops 2,4;
	}	

	states
	{
		Stagger:
			BOS2 H 3; 
			BOS2 H 3 A_Pain();
			BOS2 A 4;
			BOS2 A 18 { vel.z = 10; A_StartSound("knight/sight"); }
			BOS2 H 4 { A_StartSound("weapons/rocklx"); A_Explode(128,flags:XF_NOTMISSILE); }
			Goto See;
	}
}