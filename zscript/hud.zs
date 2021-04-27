class BloodyStatusBar : BaseStatusBar
{
	// Special thansk to Ace's HUD example.
	HUDFont mBigFont;
	HUDFont mSmallFont;
	HUDFont mConFont;

	override void NewGame()
	{
		Super.NewGame();
		// Init interpolators here
	}

	override void Init()
	{
		Super.Init();
		SetSize(0,320,240);

		Font fnt;
		// Setup fonts.
		fnt = "BIGFONT"; mBigFont = HUDFont.Create(fnt);
		fnt = "SMALLFNT"; mSmallFont = HUDFont.Create(fnt);
		fnt = "CONFONT"; mConFont = HUDFont.Create(fnt);
		
	}

	override void Draw(int state, double ticfrac)
	{
		Super.Draw(state, ticfrac);

		if (state == HUD_Fullscreen)
		{
			BeginHUD();
			DrawFullScreenStuff();
		}
	}

	void DrawFullScreenStuff()
	{
		//Now for the fun stuff.
		let plr = BloodyMessPlayer(CPlayer.mo);
		let wpn = CPlayer.ReadyWeapon;
		let armor = CPlayer.mo.FindInventory("BasicArmor");
		int armAmt = GetAmount("BasicArmor");

		int lbarflags = DI_SCREEN_CENTER_BOTTOM|DI_ITEM_RIGHT_BOTTOM;
		int rbarflags = DI_SCREEN_CENTER_BOTTOM|DI_ITEM_LEFT_BOTTOM;
		int cbarflags = DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER_BOTTOM;
		int txtflags = DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER;

		// Health drawing.
		if(plr.Health > 0) 
		{ 
			if(plr.Health > 100)
			{
				DrawBar("hovrbar","hbar",plr.Health-100,100,(-32,-4),0,0,lbarflags); 
			}
			else
			{
				DrawBar("hbar","HBEMPTY",plr.Health,100,(-32,-4),0,0,lbarflags); 
			}

			DrawString(mBigFont,FormatNumber(plr.Health,3),(-160,-32),txtflags,Font.CR_BRICK);
		}

		if(armAmt > 0)
		{
			if(armAmt > 100)
			{
				DrawBar("aovrbar","abar",armAmt-100,100,(-32,-4),0,0,lbarflags);
			}
			else
			{
				DrawBar("abar","abempty",armAmt,100,(-32,-4),0,0,lbarflags);
			}

			DrawString(mBigFont,FormatNumber(armAmt,3),(-108,-32),txtflags,Font.CR_LIGHTBLUE);
		}

		// Next, ammunition.

		Ammo primary = GetCurrentAmmo(); // Nothing has alt ammo in this mod.

		static const class<Ammo> AmmoTypes[] =
		{
			"Coil",
			"Nail",
			"RocketPile",
			"LightGem"
		};

		static const String AmmoBars[] =
		{
			"coilbar",
			"nailbar",
			"rcktbar",
			"gembar"
		};

		for (int i = 0; i < AmmoTypes.Size(); ++i)
		{
			int amt = GetAmount(AmmoTypes[i]);
			int max = GetMaxAmount(AmmoTypes[i]);
			DrawBar(AmmoBars[i],"ammobg",amt,max,(32*(i+1),-4),0,SHADER_REVERSE|SHADER_VERT,rbarflags);

			if(primary && AmmoTypes[i] == primary.GetClassName())
			{
				DrawString(mBigFont,FormatNumber(amt,3),(48+(32*i),-56),txtflags,Font.CR_GREEN);
			}
			else
			{
				DrawString(mSmallFont,FormatNumber(amt,3),(48+(32*i),-48),txtflags,Font.CR_GREEN);
			}
		}

		// Keys.
		String keySprites[6] =
		{
			"STKEYS2",
			"STKEYS0",
			"STKEYS1",
			"STKEYS5",
			"STKEYS3",
			"STKEYS4"
		};

		for(int i = 0; i < 6; i++)
		{
			if(CPlayer.mo.CheckKeys(i+1,false,true)) { DrawImage(keySprites[i],(-40+(16*i),-56),cbarflags,scale:(2,2)); }
		}


		// Finally, the BWD's charge meter.
		let bwd = CPlayer.mo.FindInventory("Bloodwave");
		if(bwd)
		{
			let bwdAmt = GetAmount("Bloodwave");
			DrawBar("REDBA0","bwmeter",bwdAmt,100,(0,-4),0,SHADER_REVERSE|SHADER_VERT,cbarflags); 
		}
		
	}
}