class BloodySpider : Arachnotron replaces Arachnotron
{
	mixin BloodyMonster;

	default
	{
		BloodySpider.StaggerHealth 300,4;
		BloodySpider.BonusDrops 2,2;
	}

	states
	{
		Stagger:
			BSPI IAIAIAIAI 4 A_Pain();
			Goto See;
	}
}