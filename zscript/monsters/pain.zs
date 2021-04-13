class BloodyPain : PainElemental replaces PainElemental
{
	mixin BloodyMonster;

	default
	{
		BloodyPain.StaggerHealth 300;
		BloodyPain.BonusDrops 1,5;
	}

	states
	{
		Stagger:
			PAIN G 6;
			PAIN G 5 A_Pain();
			PAIN D 4;
			Goto Missile;
	}
}