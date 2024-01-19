-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
	mote_include_version = 2
	
	-- Load and initialize the include file.
	include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.Buff['ManaWall'] = buffactive['ManaWall'] or false
	state.Buff['Manafont'] = buffactive['Manafont'] or false
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}
			  
	element_table = L{'Earth','Wind','Ice','Fire','Water','Lightning'}
	--state.AOE = M(true, 'AOE')
    degrade_array = {
        ['Fire'] = {'Fire','Fire II','Fire III','Fire IV','Fire V','Fire VI'},
        ['Fireja'] = {'Firaga','Firaga II','Firaga III','Firaja'},
        ['Ice'] = {'Blizzard','Blizzard II','Blizzard III','Blizzard IV','Blizzard V','Blizzard VI'},
        ['Iceja'] = {'Blizzaga','Blizzaga II','Blizzaga III','Blizzaja'},
        ['Wind'] = {'Aero','Aero II','Aero III','Aero IV','Aero V','Aero VI'},
        ['Windja'] = {'Aeroga','Aeroga II','Aeroga III','Aeroja'},
        ['Earth'] = {'Stone','Stone II','Stone III','Stone IV','Stone V','Stone VI'},
        ['Earthja'] = {'Stonega','Stonega II','Stonega III','Stoneja'},
        ['Lightning'] = {'Thunder','Thunder II','Thunder III','Thunder IV','Thunder V','Thunder VI'},
        ['Lightningja'] = {'Thundaga','Thundaga II','Thundaga III','Thundaja'},
        ['Water'] = {'Water', 'Water II','Water III', 'Water IV','Water V','Water VI'},
        ['Waterja'] = {'Waterga','Waterga II','Waterga III','Waterja'},
        ['Aspirs'] = {'Aspir','Aspir II','Aspir III'},
		['Sleeps'] = {'Sleep', 'Sleep II'},
        ['Sleepgas'] = {'Sleepga','Sleepga II'}
    }
	
    lockstyleset = 1
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
--[[ **** Begin UPDATED **** ]]
	state.CastingMode:options('Normal', 'MagicBurst', 'Occult')
								--'MagicBurst', 'AF', 'DeathMode', 'TH', 'Occult')
	state.IdleMode:options('Normal', 'Refresh')
								--   , 'DeathMode')
--[[ **** End UPDATED **** ]]	
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.DeathMode = M(false, 'Death Mode')
    state.CP = M(false, "Capacity Points Mode")
	state.AutoBurst = M{['description']='Auto Burst','OFF','ON'}
    send_command('bind @z gs c cycle AutoBurst')
    state.AutoBurstList = M{['description']='Auto Burst', 'OFF', 'ON'}
	send_command('bind @x gs c cycle AutoBurstList')
	send_command('lua l gearinfo')
    lowTierNukes = S{'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder'}
   
    Ancient = S{'Quake II', 'Flood II', 'Tornado II', 'Flare II', 'Freeze II', 'Burst II'}
   
    state.WeaponSet = M{['description']='Weapon Set', 'Empy', 'Prime', 'Dagger', 'Aeonic'}
	
	state.AOE = M(false, "AOE")
	send_command('bind @h gs c cycle AOE')
	-- Additional local binds

   -- include('Global-Binds.lua') -- OK to remove this line
   -- include('Global-GEO-Binds.lua') -- OK to remove this line	
	include('organizer-lib')

	select_default_macro_book()
    set_lockstyle()
	state.Auto_Kite = M(false, 'Auto_Kite')
    moving = false
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind @`')
	send_command('unbind !o')
	send_command('unbind ^,')
	send_command('unbind !.')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	
	---- Precast Sets ----
	
	-- Precast sets to enhance JAs
	sets.precast.JA['Mana Wall'] = {
		feet="Wicce Sabots +3",
		--back=gear.BLMcape_STP,
		}

	sets.precast.JA.Manafont = {body="Src. Coat +2"}
	
	-- equip to maximize HP (for Tarus) and minimize MP loss before using convert
	sets.precast.JA.Convert = {}


	-- Fast cast sets for spells

	sets.precast.FC = {
	--	/RDM --15 /SCH --10
	ammo="Sapience Orb", --2
    head=gear.Merlinic.Head_FC, --15/56mp
    body="Zendik Robe",--13/61mp
    hands="Agwu's Gages", --6/73mp
    legs={name="Psycloth Lappas", priority=15}, --7/109mp
    feet=gear.Merlinic.Feet_FC, --11/20mp
    neck={name="Voltsurge Torque", priority=10}, --4/20mp
    waist="Embla Sash", --5
    left_ear="Malignance Earring", --4
    right_ear="Loquac. Earring", --2
    left_ring="Kishar Ring",--4
    right_ring={name="Prolix Ring", priority=9}, --5/20mp
    back={name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}, priority=14}, --10/80mp
		} --79

	sets.precast.FC.DeathMode = {
		ammo="Ghastly Tathlum +1",
		head="Pixie Hairpin +1",    
		body="Amalric Doublet +1",
		hands="Agwu Gages",
		legs="Amalric Slops +1",
		feet="Amalric Nails +1",
		neck="Src. Stole +2",
		left_ear="Regal Earring",
		right_ear="Barkaro. Earring",
		left_ring="Mephitas's Ring +1",
		right_ring="Freke Ring",--5
	    back={name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}, priority=14},
		waist="Hachirin-no-Obi", --5
		}

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
		waist="Siegel Sash",
		})

	sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {
		head="Wicce Petasos +3",
		})

	sets.precast.FC.Cure = set_combine(sets.precast.FC, {
		})

	sets.precast.FC.Curaga = sets.precast.FC.Cure
	
	sets.precast.FC.Impact = set_combine(sets.precast.FC['Elemental Magic'], {
		head=empty,
		body="Twilight Cloak",
		})

	--[[sets.precast.FC['Death'] = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",    
		body="Amalric Doublet +1",
		hands="Amalric Gages +1",
		legs="Amalric Slops +1",
		feet="Amalric Nails +1",
		neck="Src. Stole +2",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Mephitas's Ring +1",
		right_ring="Archon Ring",
		back=gear.BLMcape_MAB,
		waist=gear.ElementalObi,
		}
		]]

	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined

	sets.precast.WS = {
		ammo="Ghastly Tathlum +1",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets", 
		legs="Nyame Flanchard",
		feet="Nyame Sollerets", 
		neck="Src. Stole +2",
		waist="Acuity Belt +1",
		left_ear="Regal Earring",
		right_ear="Moonshade Earring",
		left_ring="Freke Ring",
		right_ring="Epaminondas's Ring",
		back=gear.BLMcape_mWS,
		}

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.

	sets.precast.WS['Earth Crusher'] = set_combine(sets.precast.WS, {
		waist="Orpheus's Sash",
		neck="Quanpur Necklace",
	})
	
		sets.precast.WS['Rock Crusher'] = set_combine(sets.precast.WS['Earth Crusher'], {
		waist="Orpheus's Sash",
		neck="Quanpur Necklace",
	})
	
	sets.precast.WS['Cataclysm'] = set_combine(sets.precast.WS, {
		head="Pixie Hairpin +1",
		waist="Orpheus's Sash",
		left_ring="Archon Ring",
	})
	
	sets.precast.WS['Vidohunir'] = set_combine(sets.precast.WS, {
		head="Pixie Hairpin +1",
		waist="Orpheus's Sash",
		left_ring="Archon Ring",
	})
	

	sets.precast.WS['Myrkr'] = {
	ammo="Strobilus",
    head="Amalric Coif +1",
    body="Amalric Doublet +1", 
    hands="Regal Cuffs",
    legs="Amalric Slops +1",
    feet="Amalric Nails +1",
    neck="Sanctity Necklace",
    waist="Luminary Sash",
    left_ear="Etiolation Earring",
    right_ear="Moonshade Earring", 
    left_ring="Mephitas's Ring +1",
    right_ring="Mephitas's Ring",
    back={ name="Bane Cape", augments={'Elem. magic skill +6','Dark magic skill +9','"Mag.Atk.Bns."+1','"Fast Cast"+4',}}
		} -- Max MP

	---- Midcast Sets ----

	sets.midcast.FastRecast = {} -- Haste

	sets.midcast.Cure = {
		head="Vanya Hood", --10
		--body="Vrikodara Jupon", -- 13
		hands=gear.Telchine.Hands_dur, --10 
		legs="Vanya Slops", 
		feet="Medium's Sabots", --11
		neck="Phalaina Locket", --4
		waist="Luminary Sash",
        left_ear="Malignance Earring",
        right_ear="Mendi. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Tempered Cape", --4
		}

	sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
		})

	sets.midcast.Cursna = set_combine(sets.midcast.Cure, {
        head="Vanya Hood",
        body="Vanya Robe",
        hands="Hieros Mittens",
        feet="Vanya Clogs",
        neck="Incanter's Torque",
        left_ear="Malignance Earring",
        right_ear="Digni. Earring",
        left_ring="Ephedra Ring",
        right_ring="Ephedra Ring",
		})

	sets.midcast['Enhancing Magic'] = {
    ammo="Pemphredo Tathlum",
    head=gear.Telchine.Head_dur,
    body=gear.Telchine.Body_dur, 
    hands=gear.Telchine.Hands_dur, 
    legs=gear.Telchine.Legs_dur,
    feet=gear.Telchine.Feet_dur,
    neck="Incanter's Torque",
    waist="Embla Sash",
	right_ear="Andoaa Earring",
	left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Perimede Cape",
		}
		
sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'], {
       })
	
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		neck="Nodens Gorget",
        legs="Haven Hose",
		left_ear="Earthcry Earring",
        waist="Siegel Sash",
		})

	sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {
		head="Amalric Coif +1",
		hands="Regal Cuffs",
		})
		
    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
        head="Amalric Coif +1",
		body=gear.Telchine.Body_dur,
        hands=gear.Telchine.Hands_dur,
		legs=gear.Telchine.Legs_dur,
		feet=gear.Telchine.Feet_dur,
		waist="Gishdubar Sash",
        })

	sets.midcast.Protectra = set_combine(sets.midcast['Enhancing Magic'], {
		ring1="Sheltered Ring",
		})

	sets.midcast.Shellra = sets.midcast.Protectra

	sets.midcast.MndEnfeebles = {
    ammo="Pemphredo Tathlum",
    head="Wicce Petasos +3",
    body="Spaekona's Coat +3",
    hands={name="Spae. Gloves +3", priority=13}, --106mp
    legs="Wicce Chausses +3",
    feet="Wicce Sabots +3",
    neck="Src. Stole +2",
    waist="Luminary Sash",
    left_ear="Regal Earring",
    right_ear="Wicce Earring +1",
    left_ring="Metamorph Ring +1",
    right_ring="Stikini Ring +1",
    back={name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}, priority=14},
		} -- MND/Magic accuracy

	sets.midcast.IntEnfeebles = {
    ammo="Pemphredo Tathlum",
    head="Wicce Petasos +3",
    body="Spaekona's Coat +3",
    hands={name="Spae. Gloves +3", priority=13}, --106mp
    legs="Wicce Chausses +3",
    feet="Wicce Sabots +3",
    neck="Src. Stole +2",
    waist="Acuity Belt +1",
    left_ear="Regal Earring",
    right_ear="Wicce Earring +1",
    left_ring="Metamorph Ring +1",
    right_ring="Stikini Ring +1",
    back={name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}, priority=14},
		} -- INT/Magic accuracy
		
	sets.midcast.ElementalEnfeeble = set_combine(sets.midcast.IntEnfeebles, {
		head="Wicce Petasos +3",
		body="Wicce Coat +3",
		hands={name="Spae. Gloves +3", priority=13}, --106mp
		legs="Arch. Tonban +3",
		feet="Arch. Sabots +3",
		waist="Acuity Belt +1",
	})

	sets.midcast['Dark Magic'] = {
    ammo="Pemphredo Tathlum",
    head="Wicce Petasos +3",
    body="Wicce Coat +3",
    hands="Arch. Gloves +3",
    legs="Spae. Tonban +3",
    feet="Wicce Sabots +3",
    neck="Erra Pendant",
    left_ear="Malignance Earring",
    right_ear="Wicce Earring +1",
    left_ring="Metamorph Ring +1",
    right_ring="Stikini Ring +1",
    back={name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}, priority=14},
    waist="Acuity Belt +1",
		}

	--sets.midcast.Drain = set_combine(sets.precast.FC.DeathMode, {
	sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        --head="Pixie Hairpin +1",
		body=gear.Merlinic.Body_ASPIR,
		feet="Agwu's Pigaches",
		left_ear="Hirudinea Earring",
        left_ring="Evanescence Ring",
        waist="Fucho-no-obi",
		})
	
	sets.midcast.Aspir = sets.midcast.Drain
	
	sets.midcast['Aspir III'] = sets.midcast.Drain

	sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {
		waist="Acuity Belt +1",
		})
		
	sets.midcast.BardSong = set_combine(sets.midcast['Enfeebling Magic'], {
		feet=gear.Telchine.Feet_dur,
		})


	-- Elemental Magic sets
	
sets.midcast['Elemental Magic'] = {
	ammo="Ghastly Tathlum +1",
	--ammo="Pemphredo Tathlum",
	--head="Agwu's Cap",
	head="Wicce Petasos +3",
	--head="Ea Hat +1",
	body={name="Wicce Coat +3", priority=15}, --132mp
    hands={name="Agwu's Gages", priority=13}, --73mp
	--hands={name="Wicce Gloves +3", priority=13}, --50mp
	--legs={name="Wicce Chausses +3", priority=14},  --119
	legs={name="Agwu's Slops", priority=14},  --59
	--feet={name="Wicce Sabots +3", priority=11}, --50
	feet={name="Agwu's Pigaches", priority=11}, --44mp
    neck="Src. Stole +2",
    left_ear="Malignance Earring",
    right_ear={name="Regal Earring", priority=10}, --20mp
    left_ring={name="Metamorph Ring +1", priority=12}, --60mp
    right_ring="Freke Ring",
    back=gear.BLMcape_MAB,
    waist="Acuity Belt +1",
		}

sets.midcast['Elemental Magic'].MagicBurst = {
	ammo="Pemphredo Tathlum",
	--head="Agwu's Cap",
	--head="Wicce Petasos +3",
	head="Ea Hat +1",
	body={name="Wicce Coat +3", priority=15}, --132mp
    hands={name="Agwu's Gages", priority=13}, --73mp
	--hands={name="Wicce Gloves +3", priority=13}, --50mp
	--legs={name="Wicce Chausses +3", priority=14},  --119
	legs={name="Agwu's Slops", priority=14},  --59
	--feet={name="Wicce Sabots +3", priority=11}, --50
	feet={name="Agwu's Pigaches", priority=11}, --44mp
    neck="Src. Stole +2",
    left_ear="Malignance Earring",
    right_ear={name="Regal Earring", priority=10}, --20mp
    left_ring={name="Metamorph Ring +1", priority=12}, --60mp
    right_ring="Freke Ring",
    back=gear.BLMcape_MAB,
    waist="Acuity Belt +1",
		}

	sets.midcast['Elemental Magic'].TH = set_combine(sets.midcast['Elemental Magic'], {
		hands=gear.Merlinic.Hands_TH,
		feet=gear.Merlinic.Feet_TH,
		waist="Chaac Belt",
		})
		
	sets.midcast['Elemental Magic'].AF = set_combine(sets.midcast['Elemental Magic'].MagicBurst, {
		body="Spaekona's Coat +3",
		--legs={name="Wicce Chausses +3", priority=14}, 
		})
		
	sets.midcast['Elemental Magic'].Occult = {
		ammo="Seraphic Ampulla",
		head="Mall. Chapeau +2",
		body=gear.Merlinic.Body_Occult,
		hands=gear.Merlinic.Hands_Occult,
		legs="Perdition Slops",
		feet=gear.Merlinic.Feet_Occult,
		neck="Combatant's Torque",
		waist="Oneiros Rope",
		left_ear="Dedition Earring",
		right_ear="Crep. Earring",
		left_ring="Petrov Ring",
		right_ring="Chirich Ring +1",
		back=gear.BLMcape_STP,
		}
	
	sets.midcast['Comet'] = set_combine(sets.midcast['Elemental Magic'], {
		ammo="Ghastly Tathlum +1",
		--head="Pixie Hairpin +1",
		legs={name="Wicce Chausses +3", priority=14},
		right_ring="Archon Ring",
		})

	sets.midcast['Comet'].MagicBurst = set_combine(sets.midcast['Comet'], {
		--head="Agwu's Cap",
		--head="Wicce Petasos +3",
		head="Ea Hat +1",
		})
		
	sets.midcast['Comet'].AF = set_combine(sets.midcast['Comet'], {
		body="Spaekona's Coat +3",
		--legs="Ea Slops +1",
		})
		
	sets.midcast['Comet'].Occult = set_combine(sets.midcast['Elemental Magic'].Occult, {

		})

	sets.midcast['Impact'] = set_combine(sets.midcast['Elemental Magic'], {
		ammo="Pemphredo Tathlum",
		head=empty,
		body="Twilight Cloak",
		hands={name="Spae. Gloves +3", priority=13}, --106mp
		legs={name="Wicce Chausses +3", priority=14},  --119
		feet={name="Wicce Sabots +3", priority=11}, --50
		right_ear="Wicce Earring +1",
		right_ring="Stikini Ring +1", -- in right ring because of metamorph ring
		})
		
	sets.midcast['Impact'].Occult = set_combine(sets.midcast['Elemental Magic'].Occult, {
		head=empty,
		body="Twilight Cloak",
		})
		
	sets.midcast['Impact'].MagicBurst = sets.midcast['Impact'] 

	sets.midcast.DeathMode = sets.precast.DeathMode
	
	sets.midcast['Death'] = set_combine(sets.midcast['Elemental Magic'], {
		ammo="Ghastly Tathlum +1",
		head="Pixie Hairpin +1",
		waist="Cornelia's Belt",
		--waist="Sacro Cord",
		--legs={name="Wicce Chausses +3", priority=14},
		left_ring="Archon Ring",
		back={name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}, priority=14},
		--[[ammo="Ghastly Tathlum +1",
		head="Pixie Hairpin +1",
		body="Amalric Doublet +1",
		hands={name="Agwu's Gages", priority=13}, --73mp
		legs="Amalric Slops +1",
		feet="Amalric Nails +1",
		neck="Src. Stole +2",
		left_ear="Malignance Earring",
		right_ear={name="Regal Earring", priority=10}, --20mp
		left_ring="Archon Ring",
		right_ring="Freke Ring",
		back=gear.BLMcape_MAB,
		waist="Sacro Cord", ]]
	})
	
	sets.midcast['Death'].MagicBurst = sets.midcast['Death']
	
	sets.midcast['Death'].AF = sets.midcast['Death']
	
	sets.midcast['Death'].Occult = set_combine(sets.midcast['Elemental Magic'].Occult, {

		})
	

	-- Minimal damage gear for procs
	sets.midcast['Elemental Magic'].Proc = {
		--main="Chatoyant Staff"
		}
		
	sets.midcast.Earth = {
		ammo="Ghastly Tathlum +1",
		--head="Agwu's Cap",
		--neck="Quanpur Necklace",
		}
		
	sets.midcast.Ancient = {
		head="Arch. Petasos +3"
	}
		
	sets.midcast.ja = {
	legs={name="Wicce Chausses +3", priority=14},	--119
	}

	-- Sets to return to when not performing an action.
	
	
	sets.resting = {
	
		}

	-- Idle sets
	
sets.idle = {
	ammo="Staunch Tathlum",
    head="Nyame Helm",
    body="Wicce Coat +3",
    hands="Nyame Gauntlets",
	legs="Nyame Flanchard",    
	feet="Nyame Sollerets",
    neck="Loricate Torque +1",
    waist="Fucho-no-Obi",
    left_ear="Etiolation Earring",
    right_ear="Eabani Earring",
    left_ring="Defending Ring",
    right_ring="Shneddick Ring",
    back={name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}, priority=14},
	}


    sets.idle.Refresh = set_combine(sets.idle, {
		ammo="Strobilus",
		head="Befouled Crown",
		hands=gear.Merlinic.Hands_Ref,
		legs=gear.Merlinic.Legs_Ref , 
		feet=gear.Merlinic.Feet_Ref,
		neck="Sibyl Scarf",
	    left_ring="Stikini Ring +1",
		--right_ring="Stikini Ring +1",
        })

	sets.idle.DT = set_combine(sets.idle, {
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Loricate Torque +1",
		waist="Fucho-no-Obi",
		left_ear="Etiolation Earring",
		right_ear="Ethereal Earring",
		left_ring="Defending Ring",
		right_ring="Shneddick Ring",
	    back={name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}, priority=14},
	})
	
    sets.idle.ManaWall = set_combine(sets.idle.PDT, {
        feet="Wicce Sabots +3",
        back=gear.BLMcape_MAB,
        })

	sets.idle.DeathMode = {
		ammo="Strobilus",
		head="Amalric Coif +1", 
		body=" Amalric Doublet +1",
		hands="Regal Cuffs",
		legs="Amalric Slops +1", 
		feet="Amalric Nails +1",
		neck="Sanctity Necklace", 
		left_ear="Loquacious Earring", 
		right_ear="Barkaro. Earring",
		left_ring="Defending Ring",
		right_ring="Mephitas's Ring +1",
	    back={name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}, priority=14},
		waist="Fucho-no-Obi",
		}

	sets.idle.Weak = sets.idle.PDT
	
	sets.idle.Town = state.idleSet, {
		head="Shaded Specs.",
		body="Goldsmith's Apron",
		neck="Goldsm. Torque",
		left_ring="Craftmaster's Ring",
		}
		
	-- Defense sets

	sets.defense.PDT = {
		}

	sets.defense.MDT = {
		}

	sets.Kiting = {
		right_ring="Shneddick Ring",
		}
	sets.latent_refresh = {
		waist="Fucho-no-obi"
		}

	-- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
	
	sets.buff['Mana Wall'] = {
		legs={name="Wicce Chausses +3", priority=14},
		feet="Wicce Sabots +3",
		--back=gear.BLMcape_MAB,
		}


	sets.magic_burst = { 
	ammo="Pemphredo Tathlum",
    head=gear.Merlinic.Head_Burst,
    body=gear.Merlinic.Body_MAB,
    hands="Ea Cuffs",
    legs=gear.Merlinic.Legs_Burst,
    feet=gear.Merlinic.Feet_Burst,
    neck="Mizu. Kubikazari",
    left_ear="Friomisi Earring",
    right_ear="Barkaro. Earring",
    left_ring="Shiva Ring",
    right_ring="Mujin Band",
    back=gear.BLMcape_MAB,
    waist="Sacro Cord",
		} 

	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	
	-- Normal melee group

sets.engaged = {		
	ammo="Amar Cluster",
	head="Nyame Helm",
	body="Nyame Mail",
	hands="Gazu Bracelets +1",
	legs="Nyame Flanchard",
	feet="Nyame Sollerets",
	neck="Combatant's Torque",
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    left_ring="Defending Ring",
    right_ring="Chirich Ring +1",
    back=gear.BLMcape_STP,
    waist="Cornelia's Belt",
		}
		
    sets.DarkAffinity = {head="Pixie Hairpin +1",left_ring="Archon Ring",}
    sets.Obi = {waist="Hachirin-no-Obi"}
	sets.AFBody = {body="Spaekona's Coat +3"}
	
	sets.TreasureHunter = {
		hands=gear.Merlinic.Hands_TH,
		feet=gear.Merlinic.Feet_TH,
		waist="Chaac Belt",
		}
		
	sets.Malig = {
		main="Malignance Pole",
		sub="Khonsu",
	}
	
	sets.Aeonic = {
		--main="Marin Staff +1",
		main="Khatvanga",
		sub="Khonsu",
	}	
	
	sets.Mpaca = {
		main="Mpaca's Staff",
		sub="Enki Strap",
		--sub="Khonsu",
	}
	
	sets.Marin = {
		main="Marin Staff +1",
		sub="Enki Strap",
		--sub="Khonsu",
	}
	
	sets.Prime = {
		main="Opashoro",
		sub="Enki Strap",
		--sub="Khonsu",
	}
	
	sets.Empy = {
		main="Hvergelmir",
		--sub="Enki Strap",
		sub="Khonsu",
	}
	
	sets.Bunzi = {
		main="Bunzi's Rod",
		sub="Ammurapi Shield",
	}
	
	sets.Dagger = {
		main="Malevolence",
		sub="Bunzi's Rod",
	}
	
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' and state.DeathMode.value then
        eventArgs.handled = true
        equip(sets.precast.FC.DeathMode)
        if spell.english == "Impact" then
            equip(sets.precast.FC.Impact.DeathMode)
        end
    end
    if spell.name:startswith('Aspir') then
        refine_various_spells(spell, action, spellMap, eventArgs)
    end
    if spell.skill == 'Elemental Magic' and spell.english ~= 'Impact' then
		refine_various_spells(spell, action, spellMap, eventArgs)
	end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
    if buffactive['Mana Wall'] then
        equip(sets.buff['Mana Wall'])
    end 
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' and state.DeathMode.value then
        eventArgs.handled = true
        if spell.skill == 'Elemental Magic' then
            equip(sets.midcast['Elemental Magic'].DeathMode)
        else
            if state.CastingMode.value == "Resistant" then
                equip(sets.midcast.Death.Resistant)
            else
                equip(sets.midcast.Death)
            end
        end
    end

end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) and not state.DeathMode.value then
        equip(sets.midcast.EnhancingDuration)
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        end
    end
    if spell.skill == 'Dark Magic' and spell.english ~= 'Death' then
			if (spell.element == world.day_element or spell.element == world.weather_element) then
				equip(sets.Obi)
			end	
    end
    --[[if spell.skill == 'Elemental Magic' and spell.english == "Comet" then
        equip(sets.DarkAffinity)
    end]]
    if spell.skill == 'Elemental Magic' then
        if state.MagicBurst.value and spell.english ~= 'Death' then
            --if state.CastingMode.value == "Resistant" then
                --equip(sets.magic_burst.Resistant)
            --else
                equip(sets.magic_burst)
            --end
            if spell.english == "Impact" then
                equip(sets.midcast.Impact)
            end
        end
		if spell.element == "Earth" then 
			equip(sets.midcast.Earth)
		end
		if buffactive['Mana Wall'] then
			equip(sets.buff['Mana Wall'])
		end
		--the $ after the ja is to make it so that it searchs for shit ending in ja
		if spell.english:match("ja$") then
            equip(sets.midcast.ja)
        end
		if Ancient:contains(spell.english) then 
			equip(sets.midcast.Ancient)
		end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
		if spell.skill == 'Elemental Magic' and spell.english ~= 'Impact' and (player.mp - spell.mp_cost) < 436 and not buffactive['Manafont'] then
			equip(sets.AFBody)
		end
    end 
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Sleep II" or spell.english == "Sleepga II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        elseif spell.english == "Break" or spell.english == "Breakga" then
            send_command('@timers c "Break ['..spell.target.name..']" 30 down spells/00255.png')
        end
    end
	if player.mpp < 25 then 
		send_command('input /t foeteni <<<<~~~~LOW MP~~~~~>>>>>>>  <<<<~~~~LOW MP~~~~~>>>>>>> <<<<~~~~LOW MP~~~~~>>>>>>>')  
	end	
end



-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- Unlock armor when Mana Wall buff is lost.
    if buff== "Mana Wall" then
        if gain then
            --send_command('gs enable all')
            equip(sets.buff['Mana Wall'])
            --send_command('gs disable all')
        else
            --send_command('gs enable all')
            handle_equipping_gear(player.status)
        end
    end

    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
            disable('ring1','ring2','waist')
        else
            enable('ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub', 'neck')
    else
        enable('main','sub', 'neck')
    end
end

-- latent DT set auto equip on HP% change
    windower.register_event('hpp change', function(new, old)
        if new<=25 then
            equip(sets.latent_dt)
        end
    end)


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    check_moving()
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
	equip(sets[state.WeaponSet.current])
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == "Enfeebling Magic" then
            if spell.type == "WhiteMagic" then
                return "MndEnfeebles"
            else
                return "IntEnfeebles"
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.DeathMode.value then
        idleSet = sets.idle.DeathMode
    end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if player.hpp <= 25 then
        idleSet = set_combine(idleSet, sets.latent_dt)
    end
    -- if state.CP.current == 'on' then
    --     equip(sets.CP)
    --     disable('back')
    -- else
    --     enable('back')
    -- end
    if buffactive['Mana Wall'] then
        idleSet = set_combine(idleSet, sets.buff['Mana Wall'])
    end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if buffactive['Mana Wall'] then
        meleeSet = set_combine(meleeSet, sets.buff['Mana Wall'])
    end

    return meleeSet
end

function customize_defense_set(defenseSet)
    if buffactive['Mana Wall'] then
        defenseSet = set_combine(defenseSet, sets.buff['Mana Wall'])
    end

    return defenseSet
end


-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)

    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    if state.DeathMode.value then
        msg = msg .. ' Death: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(060, '| Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end


function refine_various_spells(spell, action, spellMap, eventArgs)
    local aspirs = S{'Aspir','Aspir II','Aspir III'}
    local sleeps = S{'Sleep','Sleep II'}
    local sleepgas = S{'Sleepga','Sleepga II'}
	local ElementalEnfeebles = S{'Burn', 'Choke', 'Shock', 'Rasp', 'Drown', 'Frost'}

    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' are on cooldown. Cancelling.'

    local spell_index

    if spell_recasts[spell.recast_id] > 0 then
        if spell.skill == 'Elemental Magic' and not spell.english:match("ja$") and not spell.english:contains("ga") and not ElementalEnfeebles:contains(spell.english) then
            spell_index = table.find(degrade_array[spell.element],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array[spell.element][spell_index - 1] 
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
		elseif spell.skill == 'Elemental Magic' and (spell.english:match("ja$") or spell.english:contains("ga")) and not ElementalEnfeebles:contains(spell.english) then 
			if state.AOE.value then
				spell_index = table.find(degrade_array[spell.element:append("ja")],spell.name)
				if spell_index > 1 then
					newSpell = degrade_array[spell.element:append("ja")][spell_index - 1] 
					send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
					eventArgs.cancel = true
				end
			end
				spell_index = 7
				if spell_index > 1 then
					newSpell = degrade_array[spell.element][spell_index - 1] 
					send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
					eventArgs.cancel = true
				end
			
			
        elseif spell.name:startswith('Aspir') then
            spell_index = table.find(degrade_array['Aspirs'],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array['Aspirs'][spell_index - 1]
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
		--[[elseif spell.english:match('Sleep II') then 
            spell_index = table.find(degrade_array['Sleeps'],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array['Sleeps'][spell_index - 1]
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
		elseif spell.english:match('Sleepga II') then 
            spell_index = table.find(degrade_array['Sleepgas'],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array['Sleepgas'][spell_index - 1]
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end]]
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end

function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end

function check_gear()
    if no_swap_gear:contains(player.equipment.left_ring) then
        disable("ring1")
    else
        enable("ring1")
    end
    if no_swap_gear:contains(player.equipment.right_ring) then
        disable("ring2")
    else
        enable("ring2")
    end
end

windower.register_event('zone change',
    function()
        if no_swap_gear:contains(player.equipment.left_ring) then
            enable("ring1")
            equip(sets.idle)
        end
        if no_swap_gear:contains(player.equipment.right_ring) then
            enable("ring2")
            equip(sets.idle)
        end
    end
)


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	set_macro_page(9, 20)
end

function set_lockstyle()
    send_command('wait 8; input /lockstyleset 100')
end



