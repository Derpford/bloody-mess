class BloodyShotgunner : ShotgunGuy replaces ShotgunGuy
{
	mixin BloodyMonster;

	default
	{
		BloodyShotgunner.StaggerHealth 20,-1;
		BloodyShotgunner.BonusDrops 1,2;	
		DropItem "NailShotty";
	}

	states
	{
		Missile:
			SPOS E 15 A_FaceTarget();
			SPOS F 5
			{
				A_StartSound("weapons/shotgf");
				A_SpawnProjectile("NailShot",48,flags:CMF_OFFSETPITCH,pitch:-1);
				A_SpawnProjectile("NailShot",24,18,angle:-4,flags:CMF_OFFSETPITCH,pitch:1);
				A_SpawnProjectile("NailShot",24,-18,angle:4,flags:CMF_OFFSETPITCH,pitch:1);
			}
			SPOS E 10;
			Goto See;
		Stagger:
			SPOS G 5 { A_Pain(); }
			SPOS H 4;
			SPOS DCBA 2 { Thrust(-3,angle); }
			SPOS A 4 A_Pain();
			Goto See;
	}
}