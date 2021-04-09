class BloodyImp : DoomImp replaces DoomImp
{
	mixin BloodyMonster;

	default
	{
		BloodyImp.StaggerHealth 20;
		BloodyImp.BonusDrops 1,4;
	}
	states
	{
		Stagger:
			TROO H 4 { A_Pain(); angle += random(-30,30); }	
			TROO I 3;
			TROO DCBA 3 { thrust(-3,angle); }
			TROO A 2;
			Goto See;
	}
}