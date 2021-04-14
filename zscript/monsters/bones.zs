class BloodyBones : Revenant replaces Revenant
{
	mixin BloodyMonster;

	default
	{
		BloodyBones.StaggerHealth 225,4;
		BloodyBones.BonusDrops 2,2;
	}

	states
	{
		Stagger:
			SKEL L 5;
			SKEL M 4 A_StartSound("skeleton/sight");
			Goto Melee;
	}
}