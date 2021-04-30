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

class BlobShot : FatShot replaces FatShot
{
	// IT BURNS IT BURNS
	default
	{
		DamageFunction 0;
	}

	action void A_BlobBurn()
	{
				invoker.A_Explode(20,80,fulldamagedistance:40);
				invoker.A_SpawnItemEX("ThermiteFlame",xvel:1,zvel:4,angle:frandom(0,359));
	}

	states
	{
		Death:
			MISL B 8 Bright A_BlobBurn();
			MISL C 6 Bright;
			MISL B 8 Bright A_BlobBurn();
			MISL C 6 Bright;
			MISL B 8 Bright A_BlobBurn();
			MISL C 6 Bright;
			MISL D 4 Bright;
			Stop;
	}
}