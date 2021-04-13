class MacrossCannon : Weapon replaces RocketLauncher
{
	// A cannon designed to coordinate missile strikes on various targets.
	// Shots hover until the trigger is released.
	mixin Spinner;

	default
	{
		Weapon.SlotNumber 4;

	}

	states
	{
		Spawn:
			HSTM A -1;
			Stop;
		Select:
			HSTM B 1 A_Raise(18);
			Loop;
		Deselect:
			HSTM B 1 A_Lower(18);
			Loop;
		Ready:
			HSTM B 1 A_WeaponReady();
			Loop;
		Fire:
			HSTM C 3 
			{
				A_SpawnItemEX("MacrossMissile",xofs:8,zofs:32,xvel:8,zvel:4,flags:SXF_SETMASTER);
				A_StartSound("weapon/macrof",1);
			}
			HSTM DEF 2;
			HSTM B 2;
			HSTM B 2 A_Refire();
		Release:
			HSTM B 0 
			{
				// We need to spawn a thing at the target point.
				FLineTraceData point;
				LineTrace(invoker.owner.angle,2048,invoker.owner.pitch,TRF_THRUACTORS,32,data:point);
				tracer = Spawn("TargetDummy",point.HitLocation);
				console.printf(tracer.." spawned.");
			}
			HSTM B 4 A_GiveToChildren("SignalItem",1);
			Goto Ready;
	}
}

class SignalItem : Inventory
{
	//Exists to be given to things that need a signal.
}

class TargetDummy : Actor
{
	// Exists to be a position that something points at.
	states
	{
		Spawn:
			TNT1 A 35;
			Stop;
	}
}

class MacrossMissile: FastProjectile
{
	// A remote-controlled minimissile.

	default
	{
		PROJECTILE;
		DamageFunction 16;
		Speed 60;

	}

	states
	{
		Spawn:
			HSBM A 0;
			HSBM A 1 
			{ 
				angle += 15;
				vel.x *= 0.85;
				vel.y *= 0.85;
				if(vel.z < 0)
				{
					vel.z *= 0.85;
				}
				else
				{
					vel.z -= 1;
				}
				if(CountInv("SignalItem")>0)
				{
					// Set angle here.
					tracer = master.tracer;
					return ResolveState("fly");
				}
				else
				{
					return ResolveState(null);
				}
			}
			Loop;
		Fly:
			HSBM A 1
			{
				bNOGRAVITY = true;
				if(tracer) { VelIntercept(tracer); }
			}
		FlyLoop:
			HSBM A 1;
			Loop;
		Death:
			MISL B 4 Bright { A_Explode(40); A_StartSound("weapon/macrox"); }
			MISL CD 6 Bright;
			Stop;
	}
}