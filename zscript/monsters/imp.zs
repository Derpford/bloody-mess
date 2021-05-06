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
			// Maximum range is 25**2 * sin(90)
			TROO E 4 { A_FaceTarget(); A_StartSound("imp/attack"); } 
			TROO EEEE 2 Bright A_SpawnItemEX("FireFX",0,8,36);
			TROO F 4 Bright;
			TROO G 6 Bright 
			{
				// Stupid simple pitch adjustment.
				double dX = Vec2To(target).Length();
				if(dX<(25**2 * sin(90)))
				{
					double pit = clamp(asin(dX/25.0**2.0)/2,0,45);
					A_SpawnProjectile("ThermiteImpBall",flags:CMF_ABSOLUTEPITCH|CMF_SAVEPITCH,pitch:-pit);
					return(ResolveState(null));
				}
				else
				{
					return(ResolveState("Pain")); // Can't throw that far!
				}
			}
			Goto See;
		Stagger:
			TROO H 4 { A_Pain(); angle += random(-30,30); }	
			TROO I 3;
			TROO DCBA 3 { thrust(-3,angle); }
			TROO A 2;
			Goto See;
	}
}

class ThermiteImpBall : ThermiteBall
{
	// Because the Imp is sImply too deadly with the stock Thermite Ball.
	default
	{
		DamageFunction 0;
	}

	states
	{
		Death:
			MISL B 8 Bright
			{
				bNOGRAVITY = true;
				A_StartSound("weapon/macrox");
				A_Explode(20,40,flags:0,fulldamagedistance:20);
				for (int i = 0; i < 360; i += 90)
				{
					A_SpawnItemEX("ThermiteFlame",xofs:8,xvel:1,angle:i);
				}
			}
			MISL C 6 Bright;
			MISL D 4 Bright;
			Stop;
	}
}

class FireFX : Actor
{
	default
	{
		+NOINTERACTION;
		Scale 0.5;
	}

	states
	{
		Spawn:
			BAL1 CDE 5 Bright { vel.x += random(-1,1); vel.y += random(-1,1); vel.z += 1; }
			Stop;
	}
}