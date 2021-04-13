class BloodyChaingunner : ChaingunGuy replaces ChaingunGuy
{
	mixin BloodyMonster;

	default
	{
		BloodyChaingunner.StaggerHealth 30;
		BloodyChaingunner.BonusDrops 1,1;
	}

	states
	{
		Stagger:
			CPOS G 3 Thrust(-4,angle);
			CPOS H 5 A_Pain();
			CPOS G 3;
			CPOS A 4;
			Goto See;
	}
}