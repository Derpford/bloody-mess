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

class BoneBuster : RevenantTracer replaces RevenantTracer
{
	default
	{
		DamageFunction 40;
	}

	states
	{
		Spawn:
			FATB AB 3 Bright 
			{
				if(Vec3To(tracer).length() < 128) { bSEEKERMISSILE = false; }
				A_SeekerMissile(15,5);
			}
			Loop;
		Death:
			FBXP ABC 5 Bright;
			Stop;
	}
}