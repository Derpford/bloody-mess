class BloodyBlob : Fatso replaces Fatso
{
	mixin BloodyMonster;

	default
	{
		BloodyBlob.StaggerHealth 400,4;
		BloodyBlob.BonusDrops 2,6;
	}

	states
	{
		Stagger:
			FATT J 5;
			FATT K 8 A_Pain();
			FATT J 10;
			FATT K 12 A_Pain();
			FATT J 8;
			Goto See;
	}
}