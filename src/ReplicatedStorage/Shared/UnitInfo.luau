--!strict

-- By Wa1er_God --

local RarityInfo = require(script.Parent.RarityInfo)

export type TotalUnitData = {
	[number]: UnitData,
}

export type UnitData = {
	Damage: { number },
	Coins: number?,
	FireRate: number,
	Range: number,
	Armor: string?,
	Cost: number,
	Special: string?,
}

export type UnitInfo = {
	Rarity: RarityInfo.Rarity,
	Description: string,
	Image: string?,

	UnitData: TotalUnitData,
	Vector3Offset: Vector3?,
	ViewportOffset: CFrame?,
	CollisionRadius: number,
	Abilities: { { MinimumLevel: number, Name: string, Icon: string, Length: number, Cooldown: number } },
}

local Data = {}

local UnitInfo: { [string]: UnitInfo } = {
	["BLANK"] = {
		Rarity = "BLANK",
		Description = "NIL",
		UnitData = {
			[0] = {
				Damage = { 5 },
				FireRate = 1,
				Range = 50,
				Cost = 100,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Alexander The Great"] = {
		Rarity = "Mythic",
		Description = "A fearless conqueror who united empires with unmatched strategy and ambition. His legacy shaped the ancient world—and your battlefield.",
		Image = "rbxassetid://123087615935684",

		UnitData = {
			[0] = {
				Damage = { 20 },
				FireRate = 2.5,
				Range = 15,
				Armor = "AlexanderArmor",
				Cost = 100,
			},
			[1] = {
				Damage = { 25 },
				FireRate = 2.5,
				Range = 17,
				Armor = "AlexanderArmor",
				Cost = 175,
			},
			[2] = {
				Damage = { 30 },
				FireRate = 2.3,
				Range = 17,
				Armor = "AlexanderArmor",
				Cost = 250,
			},
			[3] = {
				Damage = { 35 },
				FireRate = 2,
				Range = 18,
				Armor = "AlexanderArmor",
				Cost = 500,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Leonidas"] = {
		Rarity = "Godly",
		Description = "Spartan king who defied fate with 300 warriors. A wall of muscle, honor, and pure determination. Enemies fear his final stand.",
		Image = "rbxassetid://121547000533197",

		UnitData = {
			[0] = {
				Damage = { 100 },
				FireRate = 3,
				Range = 15,
				Armor = "LeonidasArmor",
				Cost = 250,
			},
			[1] = {
				Damage = { 100 },
				FireRate = 2.5,
				Range = 18,
				Armor = "LeonidasArmor",
				Cost = 400,
			},
			[2] = {
				Damage = { 125 },
				FireRate = 2.25,
				Range = 20,
				Armor = "LeonidasArmor",
				Cost = 750,
			},
			[3] = {
				Damage = { 150 },
				FireRate = 2,
				Range = 20,
				Armor = "LeonidasArmor",
				Cost = 1000,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Pericles"] = {
		Rarity = "Epic",
		Description = "Master of politics and warfare. A golden-tongued leader who boosts allies, inspires armies, and fortifies defenses with sharp intellect.",
		Image = "rbxassetid://106430561053468",

		UnitData = {
			[0] = {
				Damage = { 1.5 },
				FireRate = 0,
				Range = 12,
				Armor = "PericlesArmor",
				Cost = 100,
			},
			[1] = {
				Damage = { 1.5 },
				FireRate = 0,
				Range = 13,
				Armor = "PericlesArmor",
				Cost = 175,
			},
			[2] = {
				Damage = { 1.7 },
				FireRate = 0,
				Range = 15,
				Armor = "PericlesArmor",
				Cost = 250,
			},
			[3] = {
				Damage = { 2 },
				FireRate = 0,
				Range = 18,
				Armor = "PericlesArmor",
				Cost = 400,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Pyrrhus"] = {
		Rarity = "Common",
		Description = "A brilliant tactician whose costly victories coined the phrase “Pyrrhic victory.” He wins—but at what price?",
		Image = "rbxassetid://122873675701138",

		UnitData = {
			[0] = {
				Damage = { 8 },
				FireRate = 1,
				Range = 15,
				Armor = "PyrrhusArmor",
				Cost = 50,
			},
			[1] = {
				Damage = { 12 },
				FireRate = 1,
				Range = 15,
				Armor = "PyrrhusArmor",
				Cost = 125,
			},
			[2] = {
				Damage = { 12 },
				FireRate = 0.75,
				Range = 15,
				Armor = "PyrrhusArmor",
				Cost = 225,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Socrates"] = {
		Rarity = "Rare",
		Description = "A philosopher-warrior who questions everything—especially your enemies' life choices. Wields wisdom like a weapon, breaking minds before bodies.",
		Image = "rbxassetid://92733001424959",

		UnitData = {
			[0] = {
				Damage = { 0 },
				Coins = 50,
				FireRate = 0,
				Range = 5,
				Cost = 100,
			},
			[1] = {
				Damage = { 0 },
				Coins = 75,
				FireRate = 0,
				Range = 5,
				Cost = 150,
			},
			[2] = {
				Damage = { 0 },
				Coins = 125,
				FireRate = 0,
				Range = 5,
				Cost = 250,
			},
			[3] = {
				Damage = { 0 },
				Coins = 175,
				FireRate = 0,
				Range = 5,
				Cost = 400,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Themistocles"] = {
		Rarity = "Legendary",
		Description = "Naval genius of Athens. His cunning tactics crushed Persia at sea. Commands water-based units and outmaneuvers enemies with ease.",
		Image = "rbxassetid://101001750083065",

		UnitData = {
			[0] = {
				Damage = { 10 },
				FireRate = 1,
				Range = 20,
				Armor = "ThemistoclesArmor",
				Cost = 115,
			},
			[1] = {
				Damage = { 12 },
				FireRate = 1,
				Range = 20,
				Armor = "ThemistoclesArmor",
				Cost = 185,
			},
			[2] = {
				Damage = { 12 },
				FireRate = 0.8,
				Range = 20,
				Armor = "ThemistoclesArmor",
				Cost = 200,
			},
			[3] = {
				Damage = { 15 },
				FireRate = 0.75,
				Range = 25,
				Armor = "ThemistoclesArmor",
				Cost = 250,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Julius Caesar"] = {
		Rarity = "Legendary",
		Description = "The conqueror of Gaul. Strategic, ruthless, and charismatic. Leads elite troops with cold precision—cross him, and you’ll regret it.",
		Image = "rbxassetid://123255834687209",

		UnitData = {
			[0] = {
				Damage = { 6 },
				FireRate = 0.4,
				Range = 13,
				Armor = "JuliusCaesarArmor",
				Cost = 100,
			},
			[1] = {
				Damage = { 8 },
				FireRate = 0.4,
				Range = 13,
				Armor = "JuliusCaesarArmor",
				Cost = 250,
			},
			[2] = {
				Damage = { 8 },
				FireRate = 0.4,
				Range = 15,
				Armor = "JuliusCaesarArmor",
				Cost = 300,
			},
			[3] = {
				Damage = { 9 },
				FireRate = 0.4,
				Range = 15,
				Armor = "JuliusCaesarArmor",
				Cost = 500,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Pompey"] = {
		Rarity = "Common",
		Description = "The general who ruled the seas. Commands disciplined legions and swift naval support. His tactics are as sharp as his ambition.",
		Image = "rbxassetid://117170171575136",

		UnitData = {
			[0] = {
				Damage = { 10 },
				FireRate = 2,
				Range = 40,
				Armor = "PompeyArmor",
				Cost = 75,
			},
			[1] = {
				Damage = { 10 },
				FireRate = 1.75,
				Range = 40,
				Armor = "PompeyArmor",
				Cost = 150,
			},
			[2] = {
				Damage = { 12 },
				FireRate = 1.75,
				Range = 45,
				Armor = "PompeyArmor",
				Cost = 250,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Trajan"] = {
		Rarity = "Godly",
		Description = "Rome's greatest builder and conqueror. Expands your base, strengthens structures, and commands with both hammer and sword.",
		Image = "rbxassetid://129329108626021",
		UnitData = {
			[0] = {
				Damage = { 125 },
				FireRate = 10,
				Range = 40,
				Armor = "TrajanArmor",
				Cost = 500,
			},
			[1] = {
				Damage = { 150 },
				FireRate = 9,
				Range = 40,
				Armor = "TrajanArmor",
				Cost = 600,
			},
			[2] = {
				Damage = { 150 },
				FireRate = 7.5,
				Range = 45,
				Armor = "TrajanArmor",
				Cost = 750,
			},
			[3] = {
				Damage = { 200 },
				FireRate = 7,
				Range = 50,
				Armor = "TrajanArmor",
				Cost = 1000,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Spartacus"] = {
		Rarity = "Rare",
		Description = "The rebel gladiator. Breaks chains, bones, and expectations. Leads slave uprisings with unstoppable rage and raw strength.",
		Image = "rbxassetid://121520471894961",

		UnitData = {
			[0] = {
				Damage = { 12 },
				FireRate = 2,
				Range = 13,
				Armor = "SpartacusArmor",
				Cost = 150,
			},
			[1] = {
				Damage = { 12 },
				FireRate = 1.5,
				Range = 13,
				Armor = "SpartacusArmor",
				Cost = 150,
			},
			[2] = {
				Damage = { 15 },
				FireRate = 1.5,
				Range = 15,
				Armor = "SpartacusArmor",
				Cost = 250,
			},
			[3] = {
				Damage = { 18 },
				FireRate = 1.25,
				Range = 15,
				Armor = "SpartacusArmor",
				Cost = 350,
			},
		},
		CollisionRadius = 3,
		Abilities = {
			{
				MinimumLevel = 0,
				BackgroundColor = ColorSequence.new(Color3.new(0.803922, 0.133333, 0.133333)),
				Cooldown = 30,
				Icon = "",
				Length = 10,
				Name = "Rage",
			},
		},
	},
	["Cicero"] = {
		Rarity = "Epic",
		Description = "Master of rhetoric and reason. Weak in battle but buffs allies with persuasive speeches and cripples foes with sharp logic.",
		Image = "rbxassetid://73965035363559",

		UnitData = {
			[0] = {
				Damage = { 0 },
				Coins = 75,
				FireRate = 0,
				Range = 5,
				Cost = 100,
			},
			[1] = {
				Damage = { 0 },
				Coins = 125,
				FireRate = 0,
				Range = 5,
				Cost = 150,
			},
			[2] = {
				Damage = { 0 },
				Coins = 200,
				FireRate = 0,
				Range = 5,
				Cost = 250,
			},
			[3] = {
				Damage = { 0 },
				Coins = 300,
				FireRate = 0,
				Range = 5,
				Cost = 400,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Augustus"] = {
		Rarity = "Mythic",
		Description = "The first emperor. Stabilizer of empires and perfectionist of control. Boosts economy, morale, and order across your defenses.",
		Image = "rbxassetid://117008785997390",

		UnitData = {
			[0] = {
				Damage = { 25 },
				FireRate = 2.2,
				Range = 13,
				Armor = "AugustusArmor",
				Cost = 100,
			},
			[1] = {
				Damage = { 25 },
				FireRate = 2,
				Range = 13,
				Armor = "AugustusArmor",
				Cost = 200,
			},
			[2] = {
				Damage = { 30 },
				FireRate = 2,
				Range = 13,
				Armor = "AugustusArmor",
				Cost = 350,
			},
			[3] = {
				Damage = { 32 },
				FireRate = 1.75,
				Range = 15,
				Armor = "AugustusArmor",
				Cost = 500,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["William the Conqueror"] = {
		Rarity = "Mythic",
		Description = "Master of invasion. Crushes defenses with calculated aggression and powerful siege support. The battlefield bends to his rule.",
		Image = "rbxassetid://127237964660825",

		UnitData = {
			[0] = {
				Damage = { 20 },
				FireRate = 1.5,
				Range = 14,
				Armor = "WilliamArmor",
				Cost = 200,
			},
			[1] = {
				Damage = { 25 },
				FireRate = 1.5,
				Range = 14,
				Armor = "WilliamArmor",
				Cost = 300,
			},
			[2] = {
				Damage = { 25 },
				FireRate = 1.25,
				Range = 16,
				Armor = "WilliamArmor",
				Cost = 400,
			},
			[3] = {
				Damage = { 30 },
				FireRate = 1.25,
				Range = 18,
				Armor = "WilliamArmor",
				Cost = 500,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Robert the Bruce"] = {
		Rarity = "Common",
		Description = "Scottish king and freedom fighter. Fights with guerrilla tactics, rallying peasants and knights alike in a storm of resistance.",
		Image = "rbxassetid://118958489112206",

		UnitData = {
			[0] = {
				Damage = { 12 },
				FireRate = 1.4,
				Range = 15,
				Armor = "RobertArmor",
				Cost = 75,
			},
			[1] = {
				Damage = { 15 },
				FireRate = 1.4,
				Range = 15,
				Armor = "RobertArmor",
				Cost = 150,
			},
			[2] = {
				Damage = { 15 },
				FireRate = 1.2,
				Range = 15,
				Armor = "RobertArmor",
				Cost = 225,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Richard the Lionheart"] = {
		Rarity = "Godly",
		Description = "Crusader king with unmatched bravery. Leads knights into battle with roaring strength and undying loyalty to the cross.",
		Image = "rbxassetid://131934169872463",

		UnitData = {
			[0] = {
				Damage = { 90 },
				FireRate = 6,
				Range = 25,
				Armor = "RichardArmor",
				Cost = 1000,
			},
			[1] = {
				Damage = { 105 },
				FireRate = 5.75,
				Range = 25,
				Armor = "RichardArmor",
				Cost = 1250,
			},
			[2] = {
				Damage = { 120 },
				FireRate = 5,
				Range = 30,
				Armor = "RichardArmor",
				Cost = 1500,
			},
			[3] = {
				Damage = { 150 },
				FireRate = 4.5,
				Range = 35,
				Armor = "RichardArmor",
				Cost = 1750,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Charlemagne"] = {
		Rarity = "Epic",
		Description = "Father of Europe. Commands holy knights and scholars. Spreads law and steel across the battlefield with unstoppable unity.",
		Image = "rbxassetid://135616277878704",

		UnitData = {
			[0] = {
				Damage = { 20 },
				FireRate = 3,
				Range = 12,
				Armor = "CharlemagneArmor",
				Cost = 125,
			},
			[1] = {
				Damage = { 24 },
				FireRate = 2.75,
				Range = 12,
				Armor = "CharlemagneArmor",
				Cost = 200,
			},
			[2] = {
				Damage = { 26 },
				FireRate = 2.5,
				Range = 15,
				Armor = "CharlemagneArmor",
				Cost = 275,
			},
			[3] = {
				Damage = { 30 },
				FireRate = 2.5,
				Range = 15,
				Armor = "CharlemagneArmor",
				Cost = 350,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Joan of Arc"] = {
		Rarity = "Legendary",
		Description = "Divinely inspired warrior-maiden. Fights with faith-fueled fervor and inspires troops with holy conviction and fierce courage.",
		Image = "rbxassetid://108269486400086",

		UnitData = {
			[0] = {
				Damage = { 50 },
				FireRate = 4,
				Range = 15,
				Armor = "JoanArmor",
				Cost = 200,
			},
			[1] = {
				Damage = { 50 },
				FireRate = 3.75,
				Range = 16,
				Armor = "JoanArmor",
				Cost = 300,
			},
			[2] = {
				Damage = { 60 },
				FireRate = 3.5,
				Range = 18,
				Armor = "JoanArmor",
				Cost = 400,
			},
			[3] = {
				Damage = { 60 },
				FireRate = 3,
				Range = 18,
				Armor = "JoanArmor",
				Cost = 500,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Leif Erikson"] = {
		Rarity = "Rare",
		Description = "Viking explorer. Strikes from sea and snow. Hardy, wild, and fearless—his raids weaken enemies before the real battle begins.",
		Image = "rbxassetid://111147011911639",

		UnitData = {
			[0] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 20,
				Armor = "LeifArmor",
				Cost = 100,
			},
			[1] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 20,
				Armor = "LeifArmor",
				Cost = 200,
			},
			[2] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 24,
				Armor = "LeifArmor",
				Cost = 250,
			},
			[3] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 25,
				Armor = "LeifArmor",
				Cost = 350,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Ptolemy"] = {
		Rarity = "Common",
		Description = "Scholar, general, and ruler. Blends Hellenistic knowledge with Egyptian power. Summons star charts—and maybe meteor showers.",
		Image = "rbxassetid://84772192162069",

		UnitData = {
			[0] = {
				Damage = { 8 },
				FireRate = 2,
				Range = 50,
				Armor = "PtolemyArmor",
				Cost = 50,
			},
			[1] = {
				Damage = { 12 },
				FireRate = 2,
				Range = 50,
				Armor = "PtolemyArmor",
				Cost = 100,
			},
			[2] = {
				Damage = { 12 },
				FireRate = 1.5,
				Range = 50,
				Armor = "PtolemyArmor",
				Cost = 200,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Cleopatra"] = {
		Rarity = "Rare",
		Description = "Queen of charm and cunning. Commands loyalty and strikes with political precision. Beauty and brains make her battlefield royalty.",
		Image = "rbxassetid://137545520172915",

		UnitData = {
			[0] = {
				Damage = { 12 },
				FireRate = 2,
				Range = 50,
				Armor = "CleopatraArmor",
				Cost = 100,
			},
			[1] = {
				Damage = { 12 },
				FireRate = 1.75,
				Range = 50,
				Armor = "CleopatraArmor",
				Cost = 200,
			},
			[2] = {
				Damage = { 15 },
				FireRate = 1.75,
				Range = 50,
				Armor = "CleopatraArmor",
				Cost = 250,
			},
			[3] = {
				Damage = { 18 },
				FireRate = 1,
				Range = 40,
				Armor = "CleopatraArmor",
				Cost = 400,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Narmer"] = {
		Rarity = "Epic",
		Description = "The first pharaoh. United Upper and Lower Egypt through conquest and will. Ancient but deadly—commands unity and brute force.",
		Image = "rbxassetid://123302243147194",

		UnitData = {
			[0] = {
				Damage = { 15 },
				FireRate = 1.7,
				Range = 12,
				Armor = "NarmerArmor",
				Cost = 150,
			},
			[1] = {
				Damage = { 15 },
				FireRate = 1.5,
				Range = 12,
				Armor = "NarmerArmor",
				Cost = 250,
			},
			[2] = {
				Damage = { 18 },
				FireRate = 1.5,
				Range = 15,
				Armor = "NarmerArmor",
				Cost = 350,
			},
			[3] = {
				Damage = { 21 },
				FireRate = 1.5,
				Range = 15,
				Armor = "NarmerArmor",
				Cost = 500,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Akhenaten"] = {
		Rarity = "Legendary",
		Description = "The heretic king. Worshipper of one god, master of disruption. Alters enemy formations with divine chaos and radiant power.",
		Image = "rbxassetid://140319991588251",

		UnitData = {
			[0] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 25,
				Cost = 150,
			},
			[1] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 25,
				Cost = 250,
			},
			[2] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 25,
				Cost = 400,
			},
			[3] = {
				Damage = { 0 },
				FireRate = 0,
				Range = 30,
				Cost = 700,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Ramesses II"] = {
		Rarity = "Mythic",
		Description = "The living god of war. Leads with overwhelming might and divine authority. His name alone strikes fear into enemy lines.",
		Image = "rbxassetid://115676624628103",

		UnitData = {
			[0] = {
				Damage = { 10 },
				FireRate = 1.5,
				Range = 15,
				Armor = "RamessesArmor",
				Cost = 100,
			},
			[1] = {
				Damage = { 12 },
				FireRate = 1.5,
				Range = 15,
				Armor = "RamessesArmor",
				Cost = 225,
			},
			[2] = {
				Damage = { 15 },
				FireRate = 1.2,
				Range = 18,
				Armor = "RamessesArmor",
				Cost = 400,
			},
			[3] = {
				Damage = { 20 },
				FireRate = 1,
				Range = 18,
				Armor = "RamessesArmor",
				Cost = 750,
			},
			[4] = {
				Damage = { 50 },
				FireRate = 0.8,
				Range = 25,
				Armor = "RamessesArmor",
				Cost = 2000,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Tutankhamun"] = {
		Rarity = "Godly",
		Description = "The boy king, shrouded in mystery and gold. His ancient magic resurrects fallen allies and curses trespassers of his legacy.",
		Image = "rbxassetid://127377869922808",

		UnitData = {
			[0] = {
				Damage = { 1.2 },
				FireRate = 0,
				Range = 25,
				Cost = 400,
			},
			[1] = {
				Damage = { 1.4 },
				FireRate = 0,
				Range = 25,
				Cost = 600,
			},
			[2] = {
				Damage = { 1.6 },
				FireRate = 0,
				Range = 25,
				Cost = 800,
			},
			[3] = {
				Damage = { 1.8 },
				FireRate = 0,
				Range = 30,
				Cost = 2000,
			},
			[4] = {
				Damage = { 2 },
				FireRate = 0,
				Range = 30,
				Cost = 3000,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Cao Cao"] = {
		Rarity = "Mythic",
		Description = "Warlord and poet of the Three Kingdoms. Commands with ruthless efficiency and inspires troops with literary flair.",
		Image = "rbxassetid://73915227461302",

		UnitData = {
			[0] = {
				Damage = { 15 },
				FireRate = 1.5,
				Range = 15,
				Armor = "CaoCaoArmor",
				Cost = 150,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
	["Qin Shi Huang"] = {
		Rarity = "Godly",
		Description = "The first emperor of China. Unites warring states and commands legions of terracotta warriors to defend his empire.",
		Image = "rbxassetid://72049353436342",

		UnitData = {
			[0] = {
				Damage = { 20 },
				FireRate = 1.2,
				Range = 15,
				Cost = 200,
			},
		},
		CollisionRadius = 3,
		Abilities = {},
	},
}

export type SortType = "First" | "Last" | "Strongest" | "Weakest"
Data.SortTypes = { "First", "Last", "Strongest", "Weakest" }

function Data.GetNextSortType(SortType: SortType | string)
	local Index = table.find(Data.SortTypes, SortType)

	if Index then
		if Index >= #Data.SortTypes then
			return Data.SortTypes[1]
		else
			return Data.SortTypes[Index + 1]
		end
	else
		return Data.SortTypes[1]
	end
end

export type LevelInfo = {
	MainColor: ColorSequence,
	StrokeColor: ColorSequence,
}

local LevelInfo: { [number]: LevelInfo } = {
	[1] = {
		MainColor = ColorSequence.new(Color3.new(1, 1, 1)),
		StrokeColor = ColorSequence.new(Color3.new()),
	},
}

local function CalculateTotalCost(UpgradeData: TotalUnitData, GivenLevel: number)
	local TotalCost = 0

	for Level, Info in pairs(UpgradeData) do
		if Level <= GivenLevel then
			TotalCost += Info.Cost
		end
	end

	return TotalCost
end

local Stats = {}

export type StatProperty = "Damage" | "Range" | "FireRate" | "Coins" | "Special"
local StatProperties = { "Damage", "Range", "FireRate", "Coins", "Special" }

local Icons: { [StatProperty]: string } = {
	Damage = "rbxassetid://116153831042938",
	FireRate = "rbxassetid://117289508099114",
	Range = "rbxassetid://95171919754669",
	Coins = "rbxassetid://72304165589077",
	Special = "rbxassetid://134876951462162",
}

local Colors: { [StatProperty]: Color3 } = {
	Damage = Color3.new(0.772549, 0.109804, 0.109804),
	FireRate = Color3.new(0.113725, 0.247059, 0.784314),
	Range = Color3.new(0.749020, 0.843137, 0.133333),
	Coins = Color3.new(0.105882, 0.47451, 0.231373),
	Special = Color3.new(0.921569, 0.600000, 0.149020),
}

local Layout: { [StatProperty]: number } = {
	Damage = 1,
	FireRate = 2,
	Range = 3,
	Special = 4,
}

Stats.StatProperties = StatProperties
Stats.Icons = Icons
Stats.Colors = Colors
Stats.Layout = Layout

Data.Stats = Stats

Data.UnitInfo = UnitInfo
Data.LevelInfo = LevelInfo
Data.CalculateTotalCost = CalculateTotalCost

return Data
