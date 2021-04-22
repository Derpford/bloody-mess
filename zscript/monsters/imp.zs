class BloodyImp : DoomImp replaces DoomImp
{
	mixin BloodyMonster;

	default
	{
		BloodyImp.StaggerHealth 20,1;
		BloodyImp.BonusDrops 1,4;
	}
	states
	{
		Missile:
			TROO E 4 A_FaceTarget();
			TROO EEEE 2 Bright A_SpawnItemEX("FireFX",0,-8,36);
			TROO F 4 Bright;
			TROO G 6 Bright A_SpawnProjectile("ThermiteBall",flags:CMF_OFFSETPITCH|CMF_SAVEPITCH,pitch:-5);
			Goto See;
		Stagger:
			TROO H 4 { A_Pain(); angle += random(-30,30); }	
			TROO I 3;
			TROO DCBA 3 { thrust(-3,angle); }
			TROO A 2;
			Goto See;
	}
}

class FireFX : Actor
{
	default
	{
		+NOINTERACTION;
	}

	states
	{
		Spawn:
			BAL1 CDE 5 Bright { vel.x += random(-1,1); vel.y += random(-1,1); vel.z += 1; }
			Stop;
	}
}