class BloodyKnight : HellKnight replaces HellKnight
{
	default
	{
		BloodyKnight.StaggerHealth 250;
		BloodyKnight.BonusDrops 2,4;
	}	

	states
	{
		Stagger:
			BOS2 H 3;
			BOS2 H 3 A_Pain();
			BOS2 A 6;
			BOS2 H 4 { A_StartSound("knight/sight"); A_Explode(128); }
			Goto See;
	}
}