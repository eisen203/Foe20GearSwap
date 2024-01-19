-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
 
--[[
        Custom commands:
 
        Shorthand versions for each strategem type that uses the version appropriate for
        the current Arts.
 
                                        Light Arts              Dark Arts
 
        gs c scholar light              Light Arts/Addendum
        gs c scholar dark                                       Dark Arts/Addendum
        gs c scholar cost               Penury                  Parsimony
        gs c scholar speed              Celerity                Alacrity
        gs c scholar aoe                Accession               Manifestation
        gs c scholar power              Rapture                 Ebullience
        gs c scholar duration           Perpetuance
        gs c scholar accuracy           Altruism                Focalization
        gs c scholar enmity             Tranquility             Equanimity
        gs c scholar skillchain                                 Immanence
        gs c scholar addendum           Addendum: White         Addendum: Black
--]]
 
 
 
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
 
    -- Load and initialize the include file.
    include('Mote-Include.lua')
				
end
 
-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    info.addendumNukes = S{"Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV",
        "Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V"}
    
	state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
    update_active_strategems()
    lockstyleset = 1
	
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
	
end
 
-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------
 
-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal', 'Refresh')
    state.CastingMode:options('Normal', 'MagicBurst', 'Occult')
    state.IdleMode:options('Normal', 'Refresh')
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.MPCoat = M(false, 'MP Coat')
 
    gear.default.weaponskill_waist = "Windbuffet Belt +1"  
    gear.default.obi_waist = "Sacro Cord"
    gear.default.obi_back = "Bookworm's Cape"
    gear.MPCoat = "Seidr Cotehardie"
 
	send_command('lua l partybuffs')
	-- Additional local binds

   -- include('Global-Binds.lua') -- OK to remove this line
   -- include('Global-GEO-Binds.lua') -- OK to remove this line	
	include('organizer-lib')
   
    select_default_macro_book()
    set_lockstyle()
end
 
-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind !-')
    send_command('unbind !=')
    send_command('unbind ^[')
    send_command('unbind ^]')
    send_command('unbind ![')
    send_command('unbind !]')
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
   
   sets.precast.JA['Tabula Rasa'] = {
        legs="Pedagogy Pants +1"
        }
   
    sets.precast.JA['Enlightenment'] = {
        body="Peda. Gown +3"
        }
		
    sets.precast.JA['Sublimation'] = {
        main="Musa",
        sub="Khonsu",
        --head="Acad. Mortar. +3",
		head="Nyame Helm",
        body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",    
		feet="Nyame Sollerets",
        neck="Unmoving Collar +1",
		left_ear="Tuisto Earring", --150
		right_ear="Odnowa Earring +1",--110
        ring1="Gelatinous Ring +1",
        ring2="Eihwaz Ring",
        back="Moonbeam Cape",
        waist="Plat. Mog. Belt",
        }
 
    -- Fast cast sets for spells Arts give 10% somehow is only like 3 tho???? and 15% from rdm sub soon to be 20 when ML30
   
    sets.precast.FC = {	
		main="Hvergelmir", --50%
		--sub="Clerisy Strap", --2%
		ammo="Sapience Orb",--2%
		head=gear.Merlinic.Head_FC,--15%
		body="Zendik Robe",--13%
		hands="Acad. Bracers +3", --9%
		legs="Pinga Pants +1",--13%
		feet=gear.Merlinic.Feet_FC,--11
		neck="Voltsurge Torque",--4
		waist="Embla Sash",--5
		left_ear="Malignance Earring", --4
		right_ear="Loquac. Earring",--2
		right_ring="Prolix Ring",--2
		left_ring="Kishar Ring",--4
		back=gear.SCHcape_FC,--10 
		--total=107% from gear (110% if in arts 125% from rdm sub) 
	}
	
	sets.precast.FC.Grimoire = {
		head="Peda. M.Board +3", --13 	
		feet="Acad. Loafers +3", --12
	} --81fc
 
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
        --waist="Siegel Sash",
        })
   
--[[    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {
        head="Umuthi Hat",
    })
]]  
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {
		--right_ear="Barkarole Earring",
        })
   
    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        })
   
    sets.precast.FC.Curaga = sets.precast.FC.Cure
   
    sets.precast.FC.Impact = set_combine(sets.precast.FC['Elemental Magic'], {
        head=empty,
        body="Twilight Cloak"
    })
	
    sets.precast.FC['Dispelga'] = set_combine(sets.precast.FC, {
		main="Daybreak",
        })
 
    sets.precast.WS = {
		ammo="Ghastly Tathlum +1",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets", 
		legs="Nyame Flanchard",
		feet="Nyame Sollerets", 
		neck="Argute Stole +2",
		waist="Orpheus's Sash",
		left_ear="Regal Earring",
		right_ear="Moonshade Earring",
		left_ring="Freke Ring",
		right_ring="Epaminondas's Ring",
		back=gear.SCHcape_WSDint,
        }
	

	sets.precast.WS['Earth Crusher'] = set_combine(sets.precast.WS, {
		head="Agwu's Cap",
		--hands="Agwu's Gages",
		--feet="Agwu's Pigaches",
		neck="Quanpur Necklace",
	})
	
		sets.precast.WS['Rock Crusher'] = set_combine(sets.precast.WS['Earth Crusher'], {
		neck="Quanpur Necklace",
	})
	
	sets.precast.WS['Cataclysm'] = set_combine(sets.precast.WS, {
		head="Pixie Hairpin +1",
		body="Amalric Doublet +1", 
		legs="Amalric Slops +1",
		left_ring="Archon Ring",
	})
	
	sets.precast.WS['Vidohunir'] = set_combine(sets.precast.WS, {
		head="Pixie Hairpin +1",
		waist="Orpheus's Sash",
		left_ring="Archon Ring",
	})
	
 
    sets.precast.WS['Myrkr'] = {
		--ammo="Strobilus",
		head="Pixie Hairpin +1",
		body="Amalric Doublet +1",
        hands=gear.Telchine.Hands_dur,
        legs="Amalric Slops +1",
        feet="Arbatel Loafers +1",
        neck="Sanctity Necklace",
		left_ear="Etiolation Earring",
		right_ear="Moonshade Earring",
		left_ring="Mephitas's Ring +1",
		right_ring="Mephitas's Ring",
        back="Twilight Cape",
        waist="Luminary Sash",
        } -- Max MP
 
    sets.precast.WS['Omniscience'] = {
        } -- MND
   
    sets.precast.WS['Starburst'] = sets.precast.WS['Omniscience']
   
 
    ---- Precast Sets ----
   
    sets.midcast.FastRecast = {
		head=gear.Telchine.Head_dur,
	    body="Peda. Gown +3",
		hands=gear.Telchine.Hands_dur, 
		legs=gear.Telchine.Legs_dur,
		feet=gear.Telchine.Feet_dur,
        } -- Haste
   
    sets.midcast.Cure = {
		main="Daybreak", --30
		sub="Ammurapi Shield",
		ammo="Staunch Tathlum",
		head="Nyame Helm",
		body="Arbatel Gown +3",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Nodens Gorget", --5
		waist="Luminary Sash",
		left_ear="Halasz Earring",
		right_ear="Mendi. Earring", --5
		left_ring="Defending Ring",
		right_ring="Stikini Ring +1",
		back=gear.SCHcape_Cure, --10
        }
   
    sets.midcast.CureWithLightWeather = set_combine(sets.midcast.Cure, {
		main="Chatoyant Staff", --10
		sub="Khonsu",
		hands="Kaykaus Cuffs +1", --11
		feet="Kaykaus Boots", --10
		waist="Hachirin-no-Obi", 
        })
   
    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
        })
   
   
    sets.midcast.StatusRemoval = {
        }
   
    sets.midcast.Cursna = {
	    head="Vanya Hood",
        body="Vanya Robe",
        hands="Hieros Mittens",
        feet="Vanya Clogs",
        neck="Incanter's Torque",
        left_ear="Malignance Earring",
        right_ear="Digni. Earring",
        left_ring="Ephedra Ring",
        right_ring="Ephedra Ring",
        }
   
    sets.midcast['Enhancing Magic'] = {
		main="Musa",
		sub="Khonsu",
		ammo="Savant's Treatise",
		head=gear.Telchine.Head_dur,
		body="Peda. Gown +3",
		hands=gear.Telchine.Hands_dur,
		legs=gear.Telchine.Legs_dur,
		feet=gear.Telchine.Feet_dur,
		neck="Incanter's Torque",
		waist="Olympus Sash",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back=gear.SCHcape_FC, 
        }
		
	sets.midcast['Regen'] = set_combine(sets.midcast['Enhancing Magic'], {
		main="Musa",
		head="Arbatel Bonnet +3",
		body=gear.Telchine.Body_dur,
		hands=gear.Telchine.Hands_dur,
		legs=gear.Telchine.Legs_dur,
		feet=gear.Telchine.Feet_dur,
		back={ name="Bookworm's Cape", augments={'INT+1','MND+4','Helix eff. dur. +18','"Regen" potency+10',}}
        })
   
    sets.midcast['Stoneskin'] = set_combine(sets.midcast['Enhancing Magic'], {
		neck="Nodens Gorget",
		waist="Siegel Sash",
		left_ear="Earthcry Earring",
		legs="Haven Hose",
        })
 
    sets.midcast['Aquaveil'] = set_combine(sets.midcast['Enhancing Magic'], {
        head="Amalric Coif +1",
		hands="Regal Cuffs",
		legs=gear.Telchine.Legs_dur,
		feet=gear.Telchine.Feet_dur,
		waist="Emphatikos Rope",
        })
		
    sets.midcast['Refresh'] = set_combine(sets.midcast['Enhancing Magic'], {
        head="Amalric Coif +1",
		hands=gear.Telchine.Hands_dur, 
		legs=gear.Telchine.Legs_dur,
		feet=gear.Telchine.Feet_dur,
		waist="Gishdubar Sash",
        })
   
    sets.midcast.Storm = set_combine(sets.midcast['Enhancing Magic'], {
        })
		
    sets.midcast['Klimaform'] = set_combine(sets.midcast['Enhancing Magic'], {
        })
   
    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {
        })
 
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell
		
   
    -- Custom spell classes
sets.midcast.MndEnfeebles = {
	main="Contemplator +1",
	sub="Khonsu",
	ammo="Pemphredo Tathlum",
    head="Arbatel Bonnet +3",
    body="Acad. Gown +3",
    hands="Regal Cuffs",
    legs="Arbatel Pants +3",
    feet="Arbatel Loafers +3",
    neck="Erra Pendant",
    waist="Obstin. Sash",
	left_ear="Malignance Earring", 
	right_ear="Arbatel Earring +1",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back=gear.SCHcape_INT,
	}
	
	sets.midcast.MndEnfeebles.Dual = set_combine(sets.midcast.MndEnfeebles, {
		main="Bunzi's Rod",
		sub="Daybreak",
	})        
   
    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
		legs="Arbatel Pants +3",
        })
		
	sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles.Dual, {
	})
	
	sets.midcast['Dispelga'] = set_combine(sets.midcast.IntEnfeebles, {
		main="Daybreak"
	})
 
    sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles
   
    sets.midcast['Dark Magic'] = {
	main="Marin Staff +1",
	sub="Khonsu",
	ammo="Pemphredo Tathlum",
    head="Arbatel Bonnet +3",
	body="Acad. Gown +3",
    hands="Acad. Bracers +3",
    legs="Arbatel Pants +3",
    feet="Arbatel Loafers +3",
    neck="Erra Pendant",
	left_ear="Malignance Earring", 
	right_ear="Arbatel Earring +1",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
	back=gear.SCHcape_INT,
    waist="Acuity Belt +1",
        }
   
    sets.midcast.Kaustra = {
		main="Bunzi's Rod",
		sub="Ammurapi Shield",
		ammo="Ghastly Tathlum +1",
		--head="Peda. M.Board +3",
		head="Arbatel Bonnet +3",
		body="Agwu's Robe",
		hands="Agwu's Gages",
		legs="Agwu's Slops",
		feet="Arbatel Loafers +3",
		neck="Argute Stole +2",
		left_ear="Malignance Earring", 
		right_ear="Regal Earring",
		left_ring="Metamorph Ring +1",
		right_ring="Freke Ring",
		back=gear.SCHcape_INT,
		waist="Acuity Belt +1",
        }
   
    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head="Pixie Hairpin +1",
		body=gear.Merlinic.Body_ASPIR,
		legs=gear.Merlinic.Legs_ASPIR,
		feet="Agwu's Pigaches",
        left_ear="Hirudinea Earring",
        right_ring="Evanescence Ring",
        waist="Fucho-no-obi",
        })
   
    sets.midcast.Aspir = sets.midcast.Drain
   
    sets.midcast.Stun = {
		ammo="Pemphredo Tathlum",
		head="Agwu's Cap",
		body="Agwu's Robe",
		hands="Agwu's Gages",
		legs="Agwu's Slops",
		feet="Agwu's Pigaches",
		neck="Erra Pendant",
		waist="Acuity Belt +1",
		left_ear="Malignance Earring", 
		right_ear="Arbatel Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back=gear.SCHcape_INT,
	}
   
    -- Elemental Magic
    sets.midcast['Elemental Magic'] = {
		main="Bunzi's Rod",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Peda. M.Board +3",
		body="Agwu's Robe",
		hands="Agwu's Gages",
		legs="Agwu's Slops",
		feet="Agwu's Pigaches",
		neck="Argute Stole +2",
		left_ear="Malignance Earring", 
		right_ear="Regal Earring",
		left_ring="Metamorph Ring +1",
		right_ring="Freke Ring",
		back=gear.SCHcape_INT,
		waist="Acuity Belt +1",
        } --50% without feet and akademos

	sets.midcast['Elemental Magic'].MagicBurst = set_combine(sets.midcast['Elemental Magic'], {

		})
 
    sets.midcast['Elemental Magic'].TH = set_combine(sets.midcast['Elemental Magic'], {
		hands=gear.Merlinic.Hands_TH,
		feet=gear.Merlinic.Feet_TH,
		waist="Chaac Belt",
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
		back=gear.SCHcape_STP,
		}
		
	sets.midcast.Earth = {
		ammo="Ghastly Tathlum +1",		
		--neck="Quanpur Necklace"
		}
   
    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
        head=empty,
        body="Twilight Cloak",
        right_ring="Archon Ring",
        })
   
    sets.midcast.Helix = set_combine(sets.midcast['Elemental Magic'], {
		ammo="Ghastly Tathlum +1",
		--hands="Arbatel Bracers +3",
		--legs="Arbatel Pants +3",
		waist="Skrymir Cord",
        })
		
		
    sets.midcast.Helix.MagicBurst = set_combine(sets.midcast.Helix, {
		
        })
 
    sets.midcast.DarkHelix = set_combine(sets.midcast.Helix, {
        --head="Pixie Hairpin +1",
        right_ring="Archon Ring",
        })
		
    sets.midcast.DarkHelix.MagicBurst = set_combine(sets.midcast.Helix.MagicBurst, {
        head="Pixie Hairpin +1",
        right_ring="Archon Ring",
        })
		
 
    sets.midcast.LightHelix = set_combine(sets.midcast.Helix, {
		main="Daybreak",
		sub="Ammurapi Shield",
        })
		
    sets.midcast.LightHelix.MagicBurst = set_combine(sets.midcast.Helix.MagicBurst, {
        })
		
	sets.midcast.Dual = {
		main="Bunzi's Rod",
		sub="Daybreak",
        }
   
    ------------------------------------------------------------------------------------------------
    ------------------------------------------ Idle Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------
   
    sets.idle = {
		--main="Musa",
		main="Mpaca's Staff",
		sub="Khonsu",
		ammo="Staunch Tathlum",
		head="Nyame Helm",
		body="Arbatel Gown +3",
		hands="Nyame Gauntlets",   
		legs="Nyame Flanchard", 
		feet="Nyame Sollerets",
		neck="Loricate Torque +1",
		waist="Fucho-no-Obi",
		left_ear="Etiolation Earring",
		right_ear="Eabani Earring",
		left_ring="Defending Ring",
		right_ring="Shneddick Ring",
		back=gear.SCHcape_Cure, 
        }
 
    sets.idle.Refresh = set_combine(sets.idle, {
		head="Befouled Crown",
		hands=gear.Merlinic.Hands_Ref,
		feet=gear.Merlinic.Feet_Ref,
		neck="Sibyl Scarf",
		legs=gear.Merlinic.Legs_Ref , 
	    left_ring="Stikini Ring +1",
		--right_ring="Stikini Ring +1",
        })
		
    sets.idle.Movement = set_combine(sets.idle, {
		right_ring="Shneddick Ring",
		--feet="Crier's Gaiters",
		})
    
	sets.idle.Town = set_combine(sets.idle, {
		head="Shaded Specs.",
		body="Goldsmith's Apron",
		neck="Goldsm. Torque",
		left_ring="Craftmaster's Ring",
	
        })
		
    sets.resting = set_combine(sets.idle, {
	--ammo="Clarus Stone",
    head="Befouled Crown",
    legs={ name="Lengo Pants", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Refresh"+1',}},
    --neck="Eidolon Pendant",
    waist="Fucho-no-Obi",
    --right_ear="Relaxing Earring",
    back=gear.SCHcape_FC, 
 
        })
   
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
   
    sets.defense.PDT = {
        }
   
    sets.defense.MDT = {
        }
   
    sets.Kiting = set_combine(sets.idle, {
        right_ring="Shneddick Ring",
		--feet="Crier's Gaiters",
        })
   
    sets.latent_refresh = {
        waist="Fucho-no-obi",
        }
   
    sets.Obi = {
		waist="Hachirin-no-Obi",
	}
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
   
    sets.engaged = {
		ammo="Amar Cluster",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Combatant's Torque",
		left_ear="Crep. Earring",
		right_ear="Telos Earring",
		left_ring="Cacoethic Ring +1",
		right_ring="Chirich Ring +1",
		back=gear.SCHcape_STP,
		waist="Cornelia's Belt",
        }
   
    sets.engaged.Refresh = sets.idle
   
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
   
    sets.magic_burst = { -- Staff 10
	ammo="Pemphredo Tathlum",
    head=gear.Merlinic.Head_Burst,
    body=gear.Merlinic.Body_MAB,
    hands="Amalric Gages +1",
    legs=gear.Merlinic.Legs_Burst,
    feet=gear.Merlinic.Feet_Burst,
    neck="Mizu. Kubikazari",
    left_ear="Regal Earring",
    right_ear="Barkaro. Earring",
    left_ring="Shiva Ring",
    right_ring="Mujin Band",
    waist=gear.ElementalObi,
	back=gear.SCHcape_INT,
        }
   
    sets.buff['Ebullience'] = {
		head="Arbatel Bonnet +3"
		}
    sets.buff['Rapture'] = {head="Arbatel Bonnet +3"}
    sets.buff['Perpetuance'] = {hands="Arbatel Bracers +3"}
   sets.buff['Immanence'] = set_combine(sets.precast.FC, {
		--hands="Arbatel Bracers +3",
	})
    --[[sets.buff['Immanence'] = set_combine(sets.midcast.Helix.MagicBurst, {
		hands="Arbatel Bracers +3",
	})
	]]
    sets.buff['Penury'] = {
		legs="Arbatel Pants +3"
		}
    sets.buff['Parsimony'] = {
		legs="Arbatel Pants +3"
		}
	sets.buff['Alacrity'] = {feet="Peda. Loafers +3"}
    sets.buff['Stormsurge'] = {feet="Peda. Loafers +3"}
    sets.buff['Klimaform'] = {
		feet="Arbatel Loafers +3"
		}
   
    sets.buff.FullSublimation = {
		--main="Musa",
		--sub="Khonsu",
        head="Acad. Mortar. +2",
        body="Peda. Gown +3", 
		waist="Embla Sash",
		ear1="Savant's Earring",
        }
end
 
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
function job_precast(spell, action, spellMap, eventArgs)

    if spell.name:startswith('Aspir') then
        refine_various_spells(spell, action, spellMap, eventArgs)
    end
    if spell.skill == 'Elemental Magic' and spell.english ~= 'Impact' then
		refine_various_spells(spell, action, spellMap, eventArgs)
	end

end

function job_post_precast(spell, action, spellMap, eventArgs)
    if (spell.type == "WhiteMagic" and (buffactive["Light Arts"] or buffactive["Addendum: White"])) or
        (spell.type == "BlackMagic" and (buffactive["Dark Arts"] or buffactive["Addendum: Black"])) then
        equip(sets.precast.FC.Grimoire)
    elseif spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

function job_midcast(spell, action, spellMap, eventArgs)

end
-- Run after the general midcast() is done.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Elemental Magic' then
        if spellMap == "Helix" then
            equip(sets.midcast['Elemental Magic'])
            if spell.english:startswith('Lumino') then
                equip(sets.midcast.LightHelix)
            elseif spell.english:startswith('Nocto') then
                equip(sets.midcast.DarkHelix)
            else
                equip(sets.midcast.Helix)
            end
        end
		--[[if buffactive['Klimaform'] and spell.element == world.weather_element then
			equip(sets.midcast.Klimaform)
		end]]
    --[[if spell.skill == 'Enfeebling Magic' then
        if spell.type == "WhiteMagic" and (buffactive["Light Arts"] or buffactive["Addendum: White"]) then
            equip(sets.LightArts)
        elseif spell.type == "BlackMagic" and (buffactive["Dark Arts"] or buffactive["Addendum: Black"]) then
            equip(sets.DarkArts)
        end
    end]]
    if spell.skill == 'Elemental Magic' and state.MagicBurst.value then
        equip(sets.magic_burst)
        if spell.english == "Impact" then
            equip(sets.midcast.Impact)
        end
    end
    if spell.skill == 'Elemental Magic' or spell.english == "Kaustra" then
        if (spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element])) and spellMap ~= 'Helix' then
            equip(sets.Obi)
        -- Target distance under 1.7 yalms.
        elseif spell.target.distance < (1.7 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Matching day and weather.
       elseif (spell.element == world.day_element and spell.element == world.weather_element) and spellMap ~= 'Helix' then
            equip(sets.Obi)
        -- Target distance under 8 yalms.
        elseif spell.target.distance < (8 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Match day or weather.
       elseif (spell.element == world.day_element or spell.element == world.weather_element) and spellMap ~= 'Helix' then
            equip(sets.Obi)
        end
    end
		if spell.element == "Earth" then 
			equip(sets.midcast.Earth)
		end
		
		
		if(spell.skill == 'Elemental Magic' or spell.skill == 'Enfeebling Magic') and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
			equip(sets.midcast.Dual)
		end

       --[[ if spellMap == "Storm" and state.StormSurge.value then
            equip (sets.midcast.Stormsurge)
        end ]]
    end
	if spell.action_type == 'Magic' then
        apply_grimoire_bonuses(spell, action, spellMap, eventArgs)
    end
	end


 
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.skill == 'Elemental Magic' then
            --state.MagicBurst:reset()
        end
    end
end
 
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------
 
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if buff == "Sublimation: Activated" then
        handle_equipping_gear(player.status)
    end
end
 
-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'None' then
            enable('main','sub','range')
        else
            disable('main','sub','range')
        end
    end
end
 
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
 
-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if world.weather_element == 'Light' then
                return 'CureWithLightWeather'
            end
        elseif spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
--[[        elseif spell.skill == 'Elemental Magic' then
            if info.low_nukes:contains(spell.english) then
                return 'LowTierNuke'
            elseif info.mid_nukes:contains(spell.english) then
                return 'MidTierNuke'
            elseif info.high_nukes:contains(spell.english) then
                return 'HighTierNuke'
            end --]]
        end
    end
end
 
function customize_idle_set(idleSet)
    if state.Buff['Sublimation: Activated'] then
        if state.IdleMode.value == 'Normal' then
            idleSet = set_combine(idleSet, sets.buff.FullSublimation)
        elseif state.IdleMode.value == 'PDT' then
            idleSet = set_combine(idleSet, sets.buff.PDTSublimation)
        end
    end
 
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
 
    return idleSet
end
 
-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    update_active_strategems()
    update_sublimation()
end
 
-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub', 'neck')
    else
        enable('main','sub', 'neck')
    end
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end
 
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
 
-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
	gearinfo(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'nuke' then
        handle_nuking(cmdParams)
        eventArgs.handled = true
    end
end
 
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
 
-- Reset the state vars tracking strategems.
function update_active_strategems()
    state.Buff['Ebullience'] = buffactive['Ebullience'] or false
    state.Buff['Rapture'] = buffactive['Rapture'] or false
    state.Buff['Perpetuance'] = buffactive['Perpetuance'] or false
    state.Buff['Immanence'] = buffactive['Immanence'] or false
    state.Buff['Penury'] = buffactive['Penury'] or false
    state.Buff['Parsimony'] = buffactive['Parsimony'] or false
    state.Buff['Celerity'] = buffactive['Celerity'] or false
    state.Buff['Alacrity'] = buffactive['Alacrity'] or false
 
    state.Buff['Klimaform'] = buffactive['Klimaform'] or false
end
 
function update_sublimation()
    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
end
 
-- Equip sets appropriate to the active buffs, relative to the spell being cast.
function apply_grimoire_bonuses(spell, action, spellMap)
    if state.Buff.Perpetuance and spell.type =='WhiteMagic' and spell.skill == 'Enhancing Magic' then
        equip(sets.buff['Perpetuance'])
    end
    if state.Buff.Rapture and (spellMap == 'Cure' or spellMap == 'Curaga') then
        equip(sets.buff['Rapture'])
    end
    if spell.skill == 'Elemental Magic' and spellMap ~= 'ElementalEnfeeble' then
        if state.Buff.Ebullience and spell.english ~= 'Impact' then
            equip(sets.buff['Ebullience'])
        end
        if state.Buff.Immanence then
            equip(sets.buff['Immanence'])
        end
        if state.Buff.Klimaform and spell.element == world.weather_element then
            equip(sets.buff['Klimaform'])
        end
    end
 
    if state.Buff.Penury then equip(sets.buff['Penury']) end
    if state.Buff.Parsimony then equip(sets.buff['Parsimony']) end
    if state.Buff.Celerity then equip(sets.buff['Celerity']) end
    if state.Buff.Alacrity then equip(sets.buff['Alacrity']) end
end
 
 
-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>
function handle_strategems(cmdParams)
    -- cmdParams[1] == 'scholar'
    -- cmdParams[2] == strategem to use
 
    if not cmdParams[2] then
        add_to_chat(123,'Error: No strategem command given.')
        return
    end
    local strategem = cmdParams[2]:lower()
 
    if strategem == 'light' then
        if buffactive['light arts'] then
            send_command('input /ja "Addendum: White" <me>')
        elseif buffactive['addendum: white'] then
            add_to_chat(122,'Error: Addendum: White is already active.')
        else
            send_command('input /ja "Light Arts" <me>')
        end
    elseif strategem == 'dark' then
        if buffactive['dark arts'] then
            send_command('input /ja "Addendum: Black" <me>')
        elseif buffactive['addendum: black'] then
            add_to_chat(122,'Error: Addendum: Black is already active.')
        else
            send_command('input /ja "Dark Arts" <me>')
        end
    elseif buffactive['light arts'] or buffactive['addendum: white'] then
        if strategem == 'cost' then
            send_command('input /ja Penury <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Celerity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Accession <me>')
        elseif strategem == 'power' then
            send_command('input /ja Rapture <me>')
        elseif strategem == 'duration' then
            send_command('input /ja Perpetuance <me>')
        elseif strategem == 'accuracy' then
            send_command('input /ja Altruism <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Tranquility <me>')
        elseif strategem == 'skillchain' then
            add_to_chat(122,'Error: Light Arts does not have a skillchain strategem.')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: White" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    elseif buffactive['dark arts']  or buffactive['addendum: black'] then
        if strategem == 'cost' then
            send_command('input /ja Parsimony <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Alacrity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Manifestation <me>')
        elseif strategem == 'power' then
            send_command('input /ja Ebullience <me>')
        elseif strategem == 'duration' then
            add_to_chat(122,'Error: Dark Arts does not have a duration strategem.')
        elseif strategem == 'accuracy' then
            send_command('input /ja Focalization <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Equanimity <me>')
        elseif strategem == 'skillchain' then
            send_command('input /ja Immanence <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: Black" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    else
        add_to_chat(123,'No arts has been activated yet.')
    end
end
 
 
-- Gets the current number of available strategems based on the recast remaining
-- and the level of the sch.
function get_current_strategem_count()
    -- returns recast in seconds.
    local allRecasts = windower.ffxi.get_ability_recasts()
    local stratsRecast = allRecasts[231]
 
    local maxStrategems = (player.main_job_level + 10) / 20
 
    local fullRechargeTime = 4*60
 
    local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)
 
    return currentCharges
end
 
function check_rings()
    rings = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}

    if rings:contains(player.equipment.left_ring) then
        disable("left_ring")
    else
        enable("left_ring")
    end

    if rings:contains(player.equipment.right_ring) then
        disable("right_ring")
    else
        enable("right_ring")
    end
end

function refine_various_spells(spell, action, spellMap, eventArgs)
    local aspirs = S{'Aspir','Aspir II','Aspir III'}
    local sleeps = S{'Sleep','Sleep II'}
    local sleepgas = S{'Sleepga','Sleepga II'}

    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' are on cooldown. Cancelling.'

    local spell_index

    if spell_recasts[spell.recast_id] > 0 then
        if spell.skill == 'Elemental Magic' and not spell.english:contains("helix")   then
            spell_index = table.find(degrade_array[spell.element],spell.name)
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
 
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(4, 15)
end

function set_lockstyle()
	send_command('wait 8; input /lockstyleset 18')
    --send_command('wait 6; input /lockstyleset 19')
end
