class BloodyWurm : Demon replaces Demon
{
	mixin BloodyMonster;

	default
	{
		BloodyWurm.StaggerHealth 100;
		BloodyWurm.BonusDrops 3,2;
	}

	states
	{
		Stagger:
			SARG H 4 A_Pain();
			SARG A 12;
			SARG H 4 A_Pain();
			SARG A 12;
			SARG H 4 A_Pain();
			SARG A 12;
			Goto See;

	}
}