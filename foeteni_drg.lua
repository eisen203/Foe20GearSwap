-- Original: Motenten / Modified: Arislan

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ WIN+A ]           AttackMode: Capped/Uncapped WS Modifier
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)

-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
packets = require('packets')
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
    res = require 'resources'
end

-- Setup vars that are user-independent.
function job_setup()
	
	state.Buff['Aftermath'] = buffactive['Aftermath'] or false
	state.Buff['Hasso'] = buffactive['Hasso'] or false
	state.Buff['Seigan'] = buffactive['Seigan'] or false
    
	no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)"}
    wyv_breath_spells = S{'Dia', 'Poison', 'Blaze Spikes', 'Protect', 'Sprout Smack', 'Head Butt', 'Cocoon',
        'Barfira', 'Barblizzara', 'Baraera', 'Barstonra', 'Barthundra', 'Barwatera'}
    wyv_elem_breath = S{'Flame Breath', 'Frost Breath', 'Sand Breath', 'Hydro Breath', 'Gust Breath', 'Lightning Breath'}

    lockstyleset = 4
	
include('Mote-TreasureHunter')
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('Normal', 'Sword', 'SubtleBlow', 'Crit', 'STP')
	--, 'MidAcc', 'HighAcc', 'MaxAcc', 'STP')
    state.WeaponskillMode:options('Normal', 'cap')
    state.HybridMode:options('Normal', 'DT')
    state.IdleMode:options('Normal', 'DT')

    state.AttackMode = M{['description']='Attack', 'Capped', 'Uncapped'}
    -- state.CP = M(false, "Capacity Points Mode")
	state.WeaponLock = M(false, 'Weapon Lock')

    send_command('bind @a gs c cycle AttackMode')
    -- send_command('bind @c gs c toggle CP')
	
	wsnum = 0
	
	send_command('lua l gearinfo')
	
	Haste = 0
	DW_needed = 0  
	DW = false  
	moving = false  
	update_combat_form()  
	determine_haste_group()
	
	state.AutoWS = M{['description']='Auto WS','OFF','true'}
    send_command('bind @z gs c cycle AutoWS')
    state.AutoWSList = M{['description']='Auto WS List', 'OFF', 'Savage spam', 'Omen', 'Impulse spam', 'Camlann spam', '4stepLight', '4stepDark'}
	send_command('bind @x gs c cycle AutoWSList')
	
	state.WeaponSet = M{['description']='Weapon Set', 'Empy', 'Shining_One', 'Mythic', 'Quint', 'StaffPhys', 'Naegling'}

    send_command('bind @w gs c toggle WeaponLock')

    select_default_macro_book()
    set_lockstyle()

    state.Auto_Kite = M(false, 'Auto_Kite')
    moving = false
end

function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind !w')
    send_command('unbind @`')
    send_command('unbind @a')
    -- send_command('unbind @c')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad6')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad0')
    send_command('unbind ^numpad.')
    send_command('unbind ^numpad+')
    send_command('unbind ^numpadenter')
    send_command('unbind ^numlock')

    send_command('unbind #`')
    send_command('unbind #1')
    send_command('unbind #2')
    send_command('unbind #3')
    send_command('unbind #4')
    send_command('unbind #5')
    send_command('unbind #6')
    send_command('unbind #7')
    send_command('unbind #8')
    send_command('unbind #9')
    send_command('unbind #0')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

--TH gear
	sets.TreasureHunter = { 
		head=gear.Valorous.Head_TH,
		feet=gear.Valorous.Feet_TH ,
		waist="Chaac Belt",
		}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.JA['Spirit Surge'] = {body="Ptero. Mail +3"}
    sets.precast.JA['Call Wyvern'] = {body="Ptero. Mail +3"}
    sets.precast.JA['Ancient Circle'] = {legs="Vishap Brais +3"}

    sets.precast.JA['Spirit Link'] = {
        head="Vishap Armet +2",
        hands="Pel. Vambraces +3",
        feet="Ptero. Greaves +3",
        --ear1="Pratik Earring",
        }

    sets.precast.JA['Steady Wing'] = {
        legs="Vishap Brais +3",
        feet="Ptero. Greaves +3",
        neck="Chanoix's Gorget",
        ear1="Lancer's Earring",
        --ear2="Anastasi Earring",
        back="Updraft Mantle",
        }

sets.precast.JA['Jump'] = {
    ammo="Coiste Bodhar",
    head="Hjarrandi Helm",
    body="Vishap Mail +3",
    hands="Vis. Fng. Gaunt. +3",
    legs="Ptero. Brais +3",
	feet="Ostro Greaves",
    neck="Vim Torque +1",
    waist="Ioskeha Belt +1",
    left_ear="Sherida Earring",
    right_ear="Brutal Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Chirich Ring +1",
	back=gear.DRGcape_DBLatk,
        }

sets.precast.JA['High Jump'] = set_combine(sets.precast.JA['Jump'], {
    legs="Ptero. Brais +3",
	})
    sets.precast.JA['Spirit Jump'] = set_combine(sets.precast.JA['Jump'], {
		legs="Pelt. Cuissots +3",
		feet="Pelt. Schyn. +3",
	})
    sets.precast.JA['Soul Jump'] = set_combine(sets.precast.JA['Jump'], {
		legs="Pelt. Cuissots +3",
	})
    sets.precast.JA['Super Jump'] = {}

sets.precast.JA['Angon'] = {
	ammo="Angon", 
	hands="Ptero. Fin. G. +3",
	right_ear="Dragoon's Earring",
	}

    -- Fast cast sets for spells
    sets.precast.FC = {
        ammo="Sapience Orb", --2
        head="Carmine Mask +1", --14
        body="Sacro Breastplate", --10
        hands="Leyline Gloves", --8
        --legs="", 
        feet="Carmine Greaves +1", --8
        neck="Voltsurge Torque", --5
        ear1="Loquacious Earring", --2
        ear2="Etiolation Earring", --1
        ring2="Prolix Ring", --6(4)
        }
		
		sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

	sets.precast.RA = {
		hands="Carmine Fin. Ga. +1", --8/11
		right_ring="Crepuscular Ring", --3/0
		} --66/70 snapshot / 16 rapid shot	

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

sets.precast.WS = {
	ammo="Knobkierrie",
    head="Peltast's Mezail +3",
	body="Nyame Mail",
	hands="Nyame Gauntlets",
	legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Dgn. Collar +2",
    waist="Sailfi Belt +1",
    left_ear="Thrud Earring", 
    right_ear="Moonshade Earring",
    left_ring="Epaminondas's Ring",
    right_ring="Ephramad's Ring",
	back=gear.DRGcape_WSD,
        }

sets.precast.WS.cap = set_combine(sets.precast.WS, {
	--head="Gleti's Mask",
    body="Pelt. Plackart +3",
	--hands="Gleti's Gauntlets",
	legs="Gleti's Breeches",
	--feet="Gleti's Boots",
	})
	
sets.precast.WS.acc = set_combine(sets.precast.WS, {
	})

    sets.precast.WS['Camlann\'s Torment'] = set_combine(sets.precast.WS, {
		head="Peltast's Mezail +3",
	    --body="Pelt. Plackart +3",
		--hands="Gleti's Gauntlets",
		--legs="Gleti's Breeches",
		--legs="Pelt. Cuissots +3",
		--waist="Fotia Belt",
        })

sets.precast.WS['Camlann\'s Torment'].cap = set_combine(sets.precast.WS['Camlann\'s Torment'], {
	head="Peltast's Mezail +3",
    body="Pelt. Plackart +3",
    --hands="Gleti's Gauntlets",
	legs="Gleti's Breeches",
    --legs="Pelt. Cuissots +3",
	--feet="Gleti's Boots",		
	})
	
sets.precast.WS['Camlann\'s Torment'].acc = set_combine(sets.precast.WS['Camlann\'s Torment'], {	
	})

sets.precast.WS['Drakesbane'] = set_combine(sets.precast.WS, {
		head="Blistering Sallet +1",
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Pelt. Cuissots +3",
		feet="Gleti's Boots",
        })

sets.precast.WS['Drakesbane'].cap = set_combine(sets.precast.WS['Drakesbane'], {
	--head="Gleti's Mask",
    body="Pelt. Plackart +3",
	--hands="Gleti's Gauntlets",
	--legs="Gleti's Breeches",
	--feet="Gleti's Boots",
        })

sets.precast.WS['Drakesbane'].acc = set_combine(sets.precast.WS['Drakesbane'], {
	
        })

    sets.precast.WS['Geirskogul'] = set_combine(sets.precast.WS, {

        })

    sets.precast.WS['Geirskogul'].cap = set_combine(sets.precast.WS['Geirskogul'], {})
	
	
	sets.precast.WS['Geirskogul'].acc = set_combine(sets.precast.WS['Geirskogul'], {})

sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {
	head="Peltast's Mezail +3",
        })

sets.precast.WS['Impulse Drive'].cap = set_combine(sets.precast.WS['Impulse Drive'], {
	--head="Gleti's Mask",
    body="Pelt. Plackart +3",
	--hands="Gleti's Gauntlets",
	legs="Gleti's Breeches",
	--feet="Gleti's Boots",
        })
		
sets.precast.WS['Impulse Drive'].acc = set_combine(sets.precast.WS['Impulse Drive'], {
        })

sets.precast.WS['Impulse Drive'].HighTP = set_combine(sets.precast.WS['Impulse Drive'], {
        })

    sets.precast.WS['Sonic Thrust'] = sets.precast.WS['Camlann\'s Torment']
    sets.precast.WS['Sonic Thrust'].cap = sets.precast.WS['Camlann\'s Torment'].cap
	sets.precast.WS['Sonic Thrust'].acc = sets.precast.WS['Camlann\'s Torment'].acc

sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {
	ammo="Voluspa Tathlum",
	--head="Ptero. Armet +3",
	--head="Peltast's Mezail +3",
	--body="Pelt. Plackart +3",
	hands="Pel. Vambraces +3",
	--legs="Gleti's Breeches",
	--legs="Pelt. Cuissots +3",
	--feet="Pelt. Schyn. +3",
	--neck="Fotia Gorget",
	--waist="Fotia Belt",
	left_ring="Niqmaddu Ring",
	back=gear.DRGcape_DBLatk,
        })

sets.precast.WS['Stardiver'].cap = set_combine(sets.precast.WS['Stardiver'], {
	--head="Gleti's Mask",
    body="Pelt. Plackart +3",
	--hands="Gleti's Gauntlets",
	legs="Gleti's Breeches",
	--feet="Gleti's Boots",
	neck="Dgn. Collar +2",
        })
		
sets.precast.WS['Stardiver'].acc = set_combine(sets.precast.WS['Stardiver'], {
	head="Gleti's Mask",
        })

    sets.precast.WS['Raiden Thrust'] = set_combine(sets.precast.WS, {

        })

    sets.precast.WS['Thunder Thrust'] = sets.engaged

    sets.precast.WS['Leg Sweep'] = set_combine(sets.precast.WS, {

        })

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS['Impulse Drive'], {
        })
		
	sets.precast.WS['Savage Blade'].Cap = set_combine(sets.precast.WS['Savage Blade'], {
		    body="Pelt. Plackart +3",
			--hands="Gleti's Gauntlets",
			--legs="Gleti's Breeches",
		})
		
    sets.precast.WS['Savage Blade'].Acc = sets.precast.WS['Impulse Drive'].Acc
	
	sets.MaxTP1={
		right_ear="Pel. Earring +1",
	}
	
	sets.MaxTP2={
		right_ear="Pel. Earring +1",
	}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	sets.midcast.FastRecast = {
		--head="Vishap Armet +3",
		head="Drachen Armet",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Unmoving Collar +1",
		waist="Plat. Mog. Belt",
		left_ear="Eabani Earring", 
		right_ear="Cryptic Earring",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back="Moonbeam Cape",
	} 
	
    sets.midcast.HealingBreath = {
        head="Ptero. Armet +3",
        --legs="Vishap Brais +3",
		legs="Drachen Brais",
        feet="Ptero. Greaves +3",
        neck="Dgn. Collar +2",
        ear1="Lancer's Earring",
        --ear2="Anastasi Earring",
        back="Updraft Mantle",
        waist="Glassblower's Belt",
        }

    sets.midcast.ElementalBreath = {
        head="Ptero. Armet +3",
		hands="Vis. Fng. Gaunt. +3",
		feet="Ptero. Greaves +3",
        left_ear="Enmerkar Earring",
        right_ear="Dragoon's Earring",
        left_ring="C. Palug Ring",
        back="Updraft Mantle",
        waist="Glassblower's Belt",
        }

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

sets.idle = {
    ammo="Staunch Tathlum",
    head="Gleti's Mask",
    body="Sacro Breastplate",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    neck="Sanctity Necklace",
    --waist="Plat. Mog. Belt",
	waist="Flume Belt",
    left_ear="Enmerkar Earring",
    right_ear="Infused Earring",
    left_ring="Defending Ring",
    right_ring="Shneddick Ring",
    back=gear.DRGcape_STP,
        }

    sets.idle.DT = set_combine(sets.idle, {
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
        })

    sets.idle.Pet = set_combine(sets.idle, {

        })

    sets.idle.DT.Pet = set_combine(sets.idle.Pet, {
		body="Ptero. Mail +3",
        })

    sets.idle.Town = set_combine(sets.idle.DT, {
		head="Shaded Specs.",
		body="Goldsmith's Apron",
		neck="Goldsm. Torque",
		left_ring="Craftmaster's Ring",
        })

    sets.idle.Weak = sets.idle.DT
    sets.Kiting = {
		--legs="Carmine Cuisses +1"
		}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

--haste 18, 48stp, 1275acc, dbl atk 
sets.engaged = {
    ammo="Coiste Bodhar",
	--head="Peltast's Mezail +3",
	head="Flam. Zucchetto +2",
    body="Hjarrandi Breast.",
	hands="Pel. Vambraces +3",
	legs="Gleti's Breeches",
	feet="Flam. Gambieras +2",
	neck="Vim Torque +1",
    waist="Ioskeha Belt +1",
    left_ear="Sherida Earring",
    right_ear="Dedition Earring",
    left_ring="Moonlight Ring",
    right_ring="Moonlight Ring",
    back=gear.DRGcape_STP,
        }

    sets.engaged.Sword = set_combine(sets.engaged, {
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		--legs="Nyame Flanchard",
        })
	
	--SubtleBlowI/II, auspice with +3 ft is 29, +2 ft is 27, +1 ft is 25
    sets.engaged.SubtleBlow = set_combine(sets.engaged, {
		body="Sacro Breastplatet", --15/0
		legs="Gleti's Breeches", --15/0
		left_ear="Sherida Earring", --0/5
		right_ear="Pel. Earring +1", --6/0
		left_ring="Niqmaddu Ring", --0/5
		right_ring="Chirich Ring +1", --10/0
        }) --31 I, 10 II, 41 total


    sets.engaged.STP = set_combine(sets.engaged, {
		head="Flam. Zucchetto +2",
		body="Hjarrandi Breast.",
		hands="Gleti's Gauntlets",
		legs="Ptero. Brais +3",
		feet="Flam. Gambieras +2",
        })
		
    sets.engaged.Crit = set_combine(sets.engaged, {
		--head="Blistering Sallet +1",
		head="Gleti's Mask",
		--body="Hjarrandi Breast.",
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		--legs="Pelt. Cuissots +3",
		feet="Gleti's Boots",
		neck="Dgn. Collar +2",
		waist="Speed Belt",
		right_ear="Pel. Earring +1",
		--left_ring="Begrudging Ring",
        })



    -- * DNC Native DW Trait: 30% DW
    -- * DNC Job Points DW Gift: 5% DW

    -- No Magic Haste (74% DW to cap)
sets.engaged.DW = {
    ammo="Coiste Bodhar",
    head="Hjarrandi Helm",
    body="Hjarrandi Breast.",
    hands="Pel. Vambraces +3",
    legs="Ptero. Brais +3",
    feet="Flam. Gambieras +2",
    neck="Dgn. Collar +2",
    waist="Ioskeha Belt +1",
    left_ear="Sherida Earring",
    right_ear="Dedition Earring",
    left_ring="Moonlight Ring",
    right_ring="Moonlight Ring",
    back=gear.DRGcape_STP,
        }

    sets.engaged.DW.Sword = set_combine(sets.engaged.DW, {
		head="Flam. Zucchetto",
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Nyame Flanchard",
        })

    sets.engaged.DW.SubtleBlow = set_combine(sets.engaged.DW.Sword, {

        })
		
    sets.engaged.DW.STP = set_combine(sets.engaged.DW.Sword, {

        })
		
    sets.engaged.DW.Crit = set_combine(sets.engaged.DW.Sword, {

        })



    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = set_combine(sets.engaged.DW, {

        })

    sets.engaged.DW.Sword.LowHaste = set_combine(sets.engaged.DW.LowHaste, {

        })

    sets.engaged.DW.SubtleBlow.LowHaste = set_combine(sets.engaged.DW.Sword.LowHaste, {

        })
		
    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.Sword.LowHaste, {

        })
		
    sets.engaged.DW.Crit.LowHaste = set_combine(sets.engaged.DW.Sword.LowHaste, {

        })


    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = set_combine(sets.engaged.DW.LowHaste, {

        })

    sets.engaged.DW.Sword.MidHaste = set_combine(sets.engaged.DW.MidHaste, {

        })

    sets.engaged.DW.SubtleBlow.MidHaste = set_combine(sets.engaged.DW.Sword.MidHaste, {

        })
		
    sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.Sword.MidHaste, {

        })
		
    sets.engaged.DW.Crit.MidHaste = set_combine(sets.engaged.DW.Sword.MidHaste, {

        })


    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = set_combine(sets.engaged.DW.MidHaste, {

        })

    sets.engaged.DW.Sword.HighHaste = set_combine(sets.engaged.DW.HighHaste, {

        })

    sets.engaged.DW.SubtleBlow.HighHaste = set_combine(sets.engaged.DW.Sword.HighHaste, {

        })
		
    sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.HighHaste, {

        })
		
    sets.engaged.DW.Crit.HighHaste = set_combine(sets.engaged.DW.HighHaste, {

        })

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = set_combine(sets.engaged.DW.HighHaste, {

        })

    sets.engaged.DW.Sword.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {

        })

    sets.engaged.DW.SubtleBlow.MaxHaste = set_combine(sets.engaged.DW.Sword.MaxHaste, {

        })
		
    sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {

        })
		
    sets.engaged.DW.Crit.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {

        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

sets.engaged.Hybrid = {
	ammo="Coiste Bodhar",
    head="Peltast's Mezail +3",
    --head="Nyame Helm",
	--head="Hjarrandi Helm",
    body="Nyame Mail",
	--body="Gleti's Cuirass",
	hands="Pel. Vambraces +3",
    --hands="Gleti's Gauntlets",
	legs="Pelt. Cuissots +3",
    --legs="Gleti's Breeches",
    feet="Nyame Sollerets",
    neck="Dgn. Collar +2",
    waist="Ioskeha Belt +1",
    left_ear="Sherida Earring",
    right_ear="Pel. Earring +1",
    left_ring="Moonlight Ring",
    right_ring="Moonlight Ring",
    back=gear.DRGcape_STP,
        }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Sword.DT = set_combine(sets.engaged.Sword, sets.engaged.Hybrid)
    sets.engaged.SubtleBlow.DT = set_combine(sets.engaged.SubtleBlow, sets.engaged.Hybrid)
	sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)
	sets.engaged.Crit.DT = set_combine(sets.engaged.Crit, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Eshmun's Ring", bag="wardrobe3"}, --20
        ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20
        waist="Gishdubar Sash", --10
        }

	sets.Shining_One = {
		main="Shining One",
		sub="Utu Grip",
	}
	
	sets.Empy = {
		main="Rhongomiant",
		sub="Utu Grip",
	}
	
	sets.Mythic = {
		main="Ryunohige",
		sub="Utu Grip",
	}
	

	sets.Quint = {
		main="Quint Spear",
		sub="Utu Grip",
	}
	
	sets.StaffPhys = {
		main="Malignance Pole",
		sub="Utu Grip",
	}
	
	sets.Naegling = {
		main="Naegling",
		--sub="Demers. Degen +1",	
		sub="Ternion Dagger +1",	
	}
	
    -- sets.CP = {back="Mecisto. Mantle"}
    --sets.Reive = {neck="Ygnas's Resolve +1"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    -- Wyvern Commands
    if spell.name == 'Dismiss' and pet.hpp < 100 then
        eventArgs.cancel = true
        add_to_chat(50, 'Cancelling Dismiss! ' ..pet.name.. ' is below full HP! [ ' ..pet.hpp.. '% ]')
    elseif wyv_breath_spells:contains(spell.english) or (spell.skill == 'Ninjutsu' and player.hpp < 33) then
        equip(sets.precast.HealingBreath)
	--[[
	elseif spell.type == "WeaponSkill" and spell.target.distance > 20 and player.status == 'Engaged' then -- Cancel WS If You Are Out Of Range --
		cancel_spell()
		add_to_chat(123, spell.name..' Canceled: [Out of Range]')
		return
		]]
    end
    -- Jump Overrides
    --if pet.isvalid and player.main_job_level >= 77 and spell.name == "Jump" then
    --    eventArgs.cancel = true
    --    send_command('@input /ja "Spirit Jump" <t>')
    --end

    --if pet.isvalid and player.main_job_level >= 85 and spell.name == "High Jump" then
    --    eventArgs.cancel = true
    --    send_command('@input /ja "Soul Jump" <t>')
    --end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        if player.tp > 2750 then
           equip(sets.MaxTP1)
		   end
    end
end

function job_pet_midcast(spell, action, spellMap, eventArgs)
    if spell.name:startswith('Healing Breath') or spell.name == 'Restoring Breath' then
        equip(sets.midcast.HealingBreath)
    elseif wyv_elem_breath:contains(spell.english) then
        equip(sets.midcast.ElementalBreath)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff,gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
--    if buffactive['Reive Mark'] then
--        if gain then
--            equip(sets.Reive)
--            disable('neck')
--        else
--            enable('neck')
--        end
--    end

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

    if buff == 'Hasso' and not gain then
        add_to_chat(167, 'Hasso just expired!')
    end

end

function job_state_change(stateField, newValue, oldValue)

    if state.WeaponLock.value == true then

        disable('range','ammo', 'neck')

    else

        enable('range','ammo', 'neck')

    end
	
    equip(sets[state.WeaponSet.current])

end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    check_moving()
end

function job_update(cmdParams, eventArgs)
	equip(sets[state.WeaponSet.current])
	handle_equipping_gear(player.status)  
end

function update_combat_form()  
	if DW == true then  
		state.CombatForm:set('DW')  
	elseif DW == false then  
		state.CombatForm:reset()  
	end  
end

function get_custom_wsmode(spell, action, spellMap)
    local wsmode
    if state.OffenseMode.value == 'MidAcc' or state.OffenseMode.value == 'HighAcc' then
        wsmode = 'Acc'
    end

    return wsmode
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    -- if state.CP.current == 'on' then
    --     equip(sets.CP)
    --     disable('back')
    -- else
    --     enable('back')
    -- end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	--[[if player.sub_job == 'SAM' and (not state.Buff['Hasso'] and not state.Buff['Seigan']) then 
		send_command('@input /ja Hasso')
	end]]
	return meleeSet
end

-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local am_msg = '(' ..string.sub(state.AttackMode.value,1,1).. ')'

    local ws_msg = state.WeaponskillMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS' ..am_msg.. ': ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
function job_self_command(cmdParams, eventArgs)
   
   gearinfo(cmdParams, eventArgs)

end

function determine_haste_group()

    classes.CustomMeleeGroups:clear()

    if DW == true then

        if DW_needed <= 14 then

            classes.CustomMeleeGroups:append('MaxHaste')

        elseif DW_needed > 15 and DW_needed <= 26 then

            classes.CustomMeleeGroups:append('HighHaste')

        elseif DW_needed > 26 and DW_needed <= 32 then

            classes.CustomMeleeGroups:append('MidHaste')

        elseif DW_needed > 32 and DW_needed <= 43 then


            classes.CustomMeleeGroups:append('LowHaste')

        elseif DW_needed > 43 then

            classes.CustomMeleeGroups:append('')

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

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book: (set, book)
    --if player.sub_job == 'SAM' then
        set_macro_page(1, 4)
    --else
        --set_macro_page(2, 8)
    --end
end

function set_lockstyle()
    send_command('wait 8; input /lockstyleset 59 ' .. lockstyleset)
end
