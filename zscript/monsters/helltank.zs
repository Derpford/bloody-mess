class BloodyHelltank : Cyberdemon replaces Cyberdemon
{
	mixin BloodyMonster;

	default
	{
		BloodyHelltank.StaggerHealth 3000,-1;
		BloodyHelltank.BonusDrops 3,10;
	}

	States
	{
		Stagger:
			CYBR G AAAA 8 A_Pain();
			Goto Missile;
	}
}