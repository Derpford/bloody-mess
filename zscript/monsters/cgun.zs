class BloodyChaingunner : ChaingunGuy replaces ChaingunGuy
{
	mixin BloodyMonster;

	default
	{
		BloodyChaingunner.StaggerHealth 30,-1;
		BloodyChaingunner.BonusDrops 1,1;
	}

	states
	{
		Missile:
			CPOS E 0 A_FaceTarget();
			CPOS E 12 A_StartSound("weapon/repsu");
			CPOS F 4 { A_StartSound("Weapon/repf",1); A_SpawnProjectile("CoilTracerEnemy"); } 
			CPOS E 12 A_StartSound("Weapon/repsd");
			CPOS E 1 A_CPosRefire();
			Goto Missile;
		Stagger:
			CPOS G 3 Thrust(-4,angle);
			CPOS H 5 A_Pain();
			CPOS G 3;
			CPOS A 4;
			Goto See;
	}
}

class CoilTracerEnemy : CoilTracer
{
	// Because god DAMN the Coil Tracer shots are powerful.

	default
	{
		-RIPPER;
		DamageFunction 12;
	}
}