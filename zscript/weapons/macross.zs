class MacrossCannon : Weapon replaces RocketLauncher
{
	// A cannon designed to coordinate missile strikes on various targets.
	// Shots hover until the trigger is released.
	mixin Spinner;

	default
	{
		Weapon.SlotNumber 5;
		Weapon.AmmoType1 "RocketPile";
		Weapon.AmmoGive1 6;
		Weapon.AmmoUse1 0;
		Inventory.PickupMessage "Made off with the Macross Cannon! Find a massacre!";
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
			HSTM B 1 
			{
				if(CountInv("RocketPile")>0) { A_WeaponReady(); } else { A_WeaponReady(WRF_NOFIRE); }
			}
			Loop;
		Fire:
			HSTM C 3 
			{
				A_TakeInventory("RocketPile",1);
				A_SpawnItemEX("MacrossMissile",xofs:8,zofs:24,xvel:8,zvel:1,flags:SXF_SETMASTER);
				A_StartSound("weapon/macrof",1);
			}
			HSTM DEF 2;
			HSTM B 2;
			HSTM B 2 { if(CountInv("RocketPile")>0) {A_Refire();} else {A_Refire("Dry");}}
			Goto Release;
		Dry:
			HSTM B 1;
			HSTM B 0 A_Refire("Dry");
		Release:
			HSTM B 0 
			{
				// We need to spawn a thing at the target point.
				FLineTraceData point;
				LineTrace(invoker.owner.angle,2048,invoker.owner.pitch,TRF_THRUACTORS,32,data:point);
				tracer = Spawn("TargetDummy",point.HitLocation);
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

	int ageOffset;

	default
	{
		PROJECTILE;
		DamageFunction 16;
		Speed 60;
		+NOCLIP;
		+ALLOWTHRUBITS;
		ThruBits 1;
	}

	states
	{
		Spawn:
			HSBM A 0;
			HSBM A 1 
			{ 
				angle += 15;

				if(!ageOffset)
				{
					ageOffset = random(0,32);
				}

				if(GetAge() > 10)
				{
					if(Vec3To(master).Length() < 64)
					{
						Warp(master,48,0,36+sin(GetAge()+ageOffset)*12,angle:GetAge(),flags:WARPF_ABSOLUTEANGLE);
					}
					else
					{
						VelIntercept(master,10);
					}
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
				bNOCLIP = false;
				if(tracer) { VelIntercept(tracer); } else { bNOGRAVITY = false; }
			}
		FlyLoop:
			HSBM A 1;
			Loop;
		Death:
			MISL B 0 
			{
				if(bNOCLIP)
				{
					// We got here from the spawn loop.
					return ResolveState("Spawn");
				}
				else
				{
					return ResolveState(null);
				}
			}
			MISL B 4 Bright { A_Explode(40); A_StartSound("weapon/macrox"); }
			MISL CD 6 Bright;
			Stop;
	}
}