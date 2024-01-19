-------------------------------------------------------------------------------------------------------------------
-- (Original: Motenten / Modified: Arislan)
-------------------------------------------------------------------------------------------------------------------

--[[    Custom Features:
        Haste Detection        Detects current magic haste level and equips corresponding engaged set to
                            optimize delay reduction (automatic)
        Haste Mode            Toggles between Haste II and Haste I recieved, used by Haste Detection [WinKey-H]
        Capacity Pts. Mode    Capacity Points Mode Toggle [WinKey-C]
        Auto. Lockstyle        Automatically locks specified equipset on file load
--]]


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
packets = require('packets')
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')

end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff.Migawari = buffactive.migawari or false
    state.Buff.Doom = buffactive.doom or false
    state.Buff.Yonin = buffactive.Yonin or false
    state.Buff.Innin = buffactive.Innin or false
    state.Buff.Futae = buffactive.Futae or false
	

	include('Mote-TreasureHunter')
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('STP', 'Normal', 'LowAcc', 'MidAcc', 'HighAcc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'DT')
    state.PhysicalDefenseMode:options('PDT', 'Evasion')
    state.AttackMode = M{['description']='Attack', 'Capped', 'Uncapped'}
    state.CP = M(false, "Capacity Points Mode")
    state.TH = M(false, "Treasure Hunter Mode")
	state.WeaponLock = M(false, 'Weapon Lock')
	
	state.WeaponSet = M{['description']='Weapon Set', 'Aeonic', 'Naegling', 'Dagger', 'Nuke'}
	
	send_command('bind @a gs c cycle AttackMode')
	
	include('organizer-lib')
	organizer_items = {
	}
	send_command('lua l gearinfo')
	
	state.warned = M(false)
	
	state.Auto_Kite = M(false, 'Auto_Kite')
	options.ninja_tool_warning_limit = 10
	Haste = 0
	DW_needed = 0  
	DW = false  
	moving = false  
	update_combat_form()  
	determine_haste_group()

	state.AutoWS = M{['description']='Auto WS','OFF','true'}
    send_command('bind @z gs c cycle AutoWS')
    state.AutoWSList = M{['description']='Auto WS List', 'OFF', 'shun'}
	send_command('bind @x gs c cycle AutoWSList')
	
	send_command('bind @w gs c toggle WeaponLock')
	send_command('bind ^= input /gs c cycle treasuremode')
    --select_movement_feet()
    select_default_macro_book()
    set_lockstyle()
end

function user_unload()
	send_command('unbind @a')
 
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------

	  sets.Enmity = {
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Obatala Subligar",
		feet="Mochizuki Kyahan +3", 
		neck="Unmoving Collar +1",
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Supershear Ring",
		right_ring="Eihwaz Ring",
		back=gear.NINcape_EVA,
	  }
	  
    -- Precast sets to enhance JAs
    sets.precast.JA['Mijin Gakure'] = {legs="Mochi. Hakama +3"}
    sets.precast.JA['Futae'] = {hands="Hattori Tekko +1"}
    sets.precast.JA['Sange'] = {legs="Mochizuki Chainmail +3"}
      sets.precast.JA['Provoke'] = sets.Enmity
	--[[  sets.precast.JA['Warcry'] = sets.Enmity
	  sets.precast.JA['Berserk'] = sets.Enmity
	  sets.precast.JA['Aggressor'] = sets.Enmity
	  sets.precast.JA['Defender'] = sets.Enmity
	  ]]
	  
    sets.precast.Waltz = {
        --ammo="Yamarang",
		head="Mummu Bonnet +1",
        --body="Passion Jacket",
        --legs="Dashing Subligar",
        neck="Phalaina Locket",
        --ring1="Asklepian Ring",
        --ring2="Valseur's Ring",
        waist="Gishdubar Sash",
        }
        
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    
    sets.precast.FC = {
		--ammo="Sapience Orb",
        head=gear.Herculean.Head_FC, --12
        body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}}, --10
        hands="Leyline Gloves", --8
        legs="Gyve Trousers", --4
        --feet="Amm Greaves",
		neck="Voltsurge Torque", --4
		waist="Flume Belt",
		left_ear="Etiolation Earring", --1
		right_ear="Loquac. Earring", --2
		left_ring="Kishar Ring", --4
		right_ring="Prolix Ring", --5
		back=gear.NINcape_FC, --10
		--total = 59%
        }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        body="Mochizuki Chainmail +3",
		feet="Hattori Kyahan +1",
        neck="Magoraga Beads",
        --ring1="Lebeche Ring",
        })

    sets.precast.RA = {
        }
       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        --ammo="Seeth. Bomblet +1",
        head="Nyame Helm",
		body="Nyame Mail",
        hands="Nyame Gauntlets",
		legs="Nyame Flanchard", 
        feet="Nyame Sollerets",
        neck="Ninja Nodowa +1",
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Lugra Earring",
        left_ring="Epaminondas's Ring", 
		right_ring="Beithir Ring",
        back=gear.NINcape_WS1,
        } -- default set

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        })

    sets.precast.WS.Uncapped = set_combine(sets.precast.WS, {})


    sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS, {
		head="Mpaca's Cap",
		body="Mpaca's Doublet",
		hands="Mpaca's Gloves",
		legs="Mpaca's Hose",
		feet="Mpaca's Boots",
		left_ear="Odr Earring",
		back=gear.NINcape_WS2,
        })

    sets.precast.WS['Blade: Ten'] = set_combine(sets.precast.WS, {		
        })

    sets.precast.WS['Blade: Shun'] = set_combine(sets.precast.WS, {
		head="Mpaca's Cap",
		body="Mpaca's Doublet",
		hands="Mpaca's Gloves",
		legs="Mpaca's Hose",
		feet="Mpaca's Boots",
		right_ear="Mache Earring +1",
        left_ring="Ilabrat Ring", 
		right_ring="Regal Ring",
		back=gear.NINcape_STP,
        })

    sets.precast.WS['Blade: Kamu'] = set_combine(sets.precast.WS, {
        })

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        })
		
	sets.precast.HybridWS = set_combine (sets.precast.WS,{
        head="Mochi. Hatsuburi +3",
		--neck="Fotia Gorget",
		waist="Orpheus's Sash",
        --right_ear="Friomisi Earring", 
		back=gear.NINcape_WS1,
        })

    sets.precast.WS['Blade: Yu'] = set_combine (sets.precast.WS, {

        })
		
    sets.precast.WS['Blade: To'] = sets.precast.HybridWS

	sets.precast.WS['Blade: Teki'] = sets.precast.HybridWS
    
	sets.precast.WS['Blade: Chi'] = sets.precast.HybridWS

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
	
        }
        
    -- Specific spells
    sets.midcast.Utsusemi = set_combine(sets.midcast.SpellInterrupt, {
		hands="Mochizuki Tekko +3",
		feet="Hattori Kyahan +1",
		back=gear.NINcape_STP,
	})

    sets.midcast.ElementalNinjutsu = {
        --ammo="Pemphredo Tathlum",
        head="Mochi. Hatsuburi +3",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Mochi. Kyahan +3",
        neck="Sanctity Necklace",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear="Hecate's Earring",
		left_ring="Metamorph Ring +1",
		right_ring="Shiva Ring +1",
        back="Yokaze Mantle",
        }

--    sets.midcast.ElementalNinjutsu.Resistant = set_combine(sets.midcast.Ninjutsu, {})

      sets.midcast.NinjutsuDebuff = {
		--ammo="Pemphredo Tathlum",
		head="Hachiya Hatsu. +2", 
		body="Malignance Tabard", 
		hands="Mochizuki Tekko +3",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Digni. Earring",
		right_ear="Crep. Earring",
		left_ring="Metamorph Ring +1",
		right_ring="Stikini Ring +1",
		back="Yokaze Mantle", 
	  }

	 sets.midcast.NinjutsuBuff = {
		body="Hattori Ningi +1",
		hands="Mochizuki Tekko +3",
	 }

--    sets.midcast.RA = {}

    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------
    
    -- Resting sets
--    sets.resting = {}
    
    -- Idle sets
    sets.idle = {
        ammo="Date Shuriken",
		head="Malignance Chapeau", --6/6
		body="Malignance Tabard", --9/9
		hands="Malignance Gloves", --5/5
		legs="Malignance Tights", --7/7
		feet="Malignance Boots", --4/4
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Etiolation Earring",
		right_ear="Infused Earring",
		left_ring="Defending Ring",
		right_ring="Shneddick Ring",
		back=gear.NINcape_FC,
        }

    sets.idle.DT = set_combine (sets.idle, {
        })

    sets.idle.Town = set_combine(sets.idle, {
		head="Shaded Specs.",
		body="Goldsmith's Apron",
		neck="Goldsm. Torque",
		left_ring="Craftmaster's Ring",
        })
    
    sets.idle.Weak = sets.idle.DT
    
    -- Defense sets
    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {--feet="Danzo sune-ate"
	}
    
    sets.DayMovement = {--feet="Danzo sune-ate"
	}
    sets.NightMovement = {feet="Hachi. Kyahan +1"
	}


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- * NIN Native DW Trait: 35% DW
    
    -- No Magic Haste (39% DW to cap)    
    sets.engaged = {
		ammo="Date Shuriken",
		--head="Malignance Chapeau",
		head="Ken. Jinpachi +1",
		body="Mochi. Chainmail +3", --9dw
		hands="Adhemar Wrist. +1",
		legs="Mochi. Hakama +3", --10dw
		feet="Tatena. Sune. +1",
		--feet="Ken. Sune-Ate +1", 
		neck="Ninja Nodowa +1",
		waist="Reiki Yotai", --7dw
		left_ear="Eabani Earring", --4dw
		right_ear="Suppanomimi", --5dw
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back=gear.NINcape_STP,
        } --35dw

    sets.engaged.LowAcc = set_combine(sets.engaged, {
	
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {

        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {

        })

    sets.engaged.STP = set_combine(sets.engaged, {
        })

    -- 15% Magic Haste (32% DW to cap)
    sets.engaged.LowHaste = set_combine(sets.engaged, {
		left_ear="Brutal Earring",
        }) --31dw

    sets.engaged.LowAcc.LowHaste = set_combine(sets.engaged.LowHaste, {

        })

    sets.engaged.MidAcc.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, {
	
        })

    sets.engaged.HighAcc.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, {
		
        })

    sets.engaged.STP.LowHaste = set_combine(sets.engaged.LowHaste, {
        })

    -- 30% Magic Haste (21% DW to cap)
    sets.engaged.MidHaste = {
		ammo="Date Shuriken",
		--head="Malignance Chapeau",
		head="Ken. Jinpachi +1",
		body="Mochi. Chainmail +3", --9dw
		hands="Adhemar Wrist. +1",
		--hands="Mpaca's Gloves",
		legs="Tatena. Haidate +1",
		feet="Tatena. Sune. +1",
		--feet="Ken. Sune-Ate +1", 
		neck="Ninja Nodowa +1",
		waist="Reiki Yotai", --7dw
		left_ear="Brutal Earring", 
		right_ear="Suppanomimi", --5dw
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back=gear.NINcape_STP,
        } --20dw

    sets.engaged.LowAcc.MidHaste = set_combine(sets.engaged.MidHaste, {

        })

    sets.engaged.MidAcc.MidHaste = set_combine(sets.engaged.LowAcc.MidHaste, {

        })

    sets.engaged.HighAcc.MidHaste = set_combine(sets.engaged.MidHaste.MidAcc, {

        })

    sets.engaged.STP.MidHaste = set_combine(sets.engaged.MidHaste, {
        })

    -- 35% Magic Haste (16% DW to cap)
    sets.engaged.HighHaste = {
		ammo="Date Shuriken",
		head="Ken. Jinpachi +1",
		body="Malignance Tabard",
		--hands="Adhemar Wrist. +1",
		hands="Mpaca's Gloves",
		legs="Tatena. Haidate +1",
		feet="Tatena. Sune. +1",
		--feet="Ken. Sune-Ate +1", 
		neck="Ninja Nodowa +1",
		waist="Reiki Yotai", --7
		left_ear="Brutal Earring",
		right_ear="Telos Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back=gear.NINcape_STP,	
        }

    sets.engaged.LowAcc.HighHaste = set_combine(sets.engaged.HighHaste, {

        })

    sets.engaged.MidAcc.HighHaste = set_combine(sets.engaged.LowAcc.HighHaste, {

        })

    sets.engaged.HighAcc.HighHaste = set_combine(sets.engaged.MidAcc.HighHaste, {

        })

    sets.engaged.STP.HighHaste = set_combine(sets.engaged.HighHaste, {
        })

    -- 47% Magic Haste (2% DW to cap)
    sets.engaged.MaxHaste = {
		ammo="Date Shuriken",
		head="Ken. Jinpachi +1",
		body="Mpaca's Doublet",
		hands="Adhemar Wrist. +1",
		legs="Tatena. Haidate +1",
		feet="Tatena. Sune. +1",
		--feet="Ken. Sune-Ate +1", 
		neck="Ninja Nodowa +1",
		waist="Sailfi Belt +1",
		left_ear="Brutal Earring",
		right_ear="Telos Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back=gear.NINcape_STP,
        } -- 0

    sets.engaged.LowAcc.MaxHaste = set_combine(sets.engaged.MaxHaste, {

        })

    sets.engaged.MidAcc.MaxHaste = set_combine(sets.engaged.LowAcc.MaxHaste, {

        })

    sets.engaged.HighAcc.MaxHaste = set_combine(sets.engaged.MidAcc.MaxHaste, {

        })

    sets.engaged.STP.MaxHaste = set_combine(sets.engaged.MaxHaste, {
        })

    sets.engaged.Hybrid = {
	--1252ACC
		ammo="Date Shuriken",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		left_ring="Defending Ring",
        }
    
    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)
    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)

    sets.engaged.DT.LowHaste = set_combine(sets.engaged.LowHaste, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT.LowHaste = set_combine(sets.engaged.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT.LowHaste = set_combine(sets.engaged.HighAcc.LowHaste, sets.engaged.Hybrid)    
    sets.engaged.STP.DT.LowHaste = set_combine(sets.engaged.STP.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DT.MidHaste = set_combine(sets.engaged.MidHaste, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT.MidHaste = set_combine(sets.engaged.LowAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT.MidHaste = set_combine(sets.engaged.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT.MidHaste = set_combine(sets.engaged.HighAcc.MidHaste, sets.engaged.Hybrid)    
    sets.engaged.STP.DT.MidHaste = set_combine(sets.engaged.STP.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DT.HighHaste = set_combine(sets.engaged.HighHaste, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT.HighHaste = set_combine(sets.engaged.LowAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT.HighHaste = set_combine(sets.engaged.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT.HighHaste = set_combine(sets.engaged.HighAcc.HighHaste, sets.engaged.Hybrid)    
    sets.engaged.STP.DT.HighHaste = set_combine(sets.engaged.HighHaste.STP, sets.engaged.Hybrid)

    sets.engaged.DT.MaxHaste = set_combine(sets.engaged.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT.MaxHaste = set_combine(sets.engaged.LowAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT.MaxHaste = set_combine(sets.engaged.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT.MaxHaste = set_combine(sets.engaged.HighAcc.MaxHaste, sets.engaged.Hybrid)    
    sets.engaged.STP.DT.MaxHaste = set_combine(sets.engaged.STP.MaxHaste, sets.engaged.Hybrid)

    --------------------------------------
    -- Custom buff sets
    --------------------------------------
	
	sets.TH = sets.TreasureHunter

    sets.buff.Migawari = {}
    sets.buff.Yonin = {}
    sets.buff.Innin = {}
    sets.buff.Sange = {ammo="Happo Shuriken"}
    sets.magic_burst = {
        ring2="Mujin Band", --(5)
        }
		
    sets.TreasureHunter = {
		body=gear.Herculean.Body_TH,
		hands=gear.Herculean.Hands_TH,
		waist="Chaac Belt",
	}
--    sets.Reive = {neck="Ygnas's Resolve +1"}

sets.Aeonic = {
	main = "Heishi Shorinken",
	sub = "Kunimitsu",
}

sets.Naegling = {
	main = "Naegling",
	sub = "Hitaki",
}

sets.Nuke = {
	main = "Ochu",
	sub = "Malevolence",
}

sets.Dagger = {
	main = "Malevolence",
	sub = "Kunimitsu",
}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    if spell.skill == "Ninjutsu" then
        do_ninja_tool_checks(spell, spellMap, eventArgs)
		--[[
		elseif spell.type == "WeaponSkill" and spell.target.distance > 5 and player.status == 'Engaged' then -- Cancel WS If You Are Out Of Range --
		cancel_spell()
		add_to_chat(123, spell.name..' Canceled: [Out of Range]')
		return	
		]]
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        --[[if lugra_ws:contains(spell.english) and (world.time >= (17*60) or world.time <= (7*60)) then
            equip(sets.Lugra)
        end]]
        if spell.english == 'Blade: Yu' and (world.weather_element == 'Water' or world.day_element == 'Water') then
            equip(sets.Obi)
        end
    end
end

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if default_spell_map == 'ElementalNinjutsu' then
        if state.MagicBurst.value then
            equip(sets.magic_burst)
        end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
        if state.Buff.Futae then
            equip(sets.precast.JA['Futae'])
            add_to_chat(120, 'Futae GO!')
        end
    end
    if spell.type == 'WeaponSkill' then
        if state.Buff.Futae then
            add_to_chat(120, 'Futae GO!')
        end
    end
    if state.Buff.Doom then
        equip(sets.buff.Doom)
    end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted and spell.english == "Migawari: Ichi" then
        state.Buff.Migawari = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
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

end

function job_state_change(stateField, newValue, oldValue)

    if state.WeaponLock.value == true then

        disable('main','sub','range','ammo')

    else

        enable('main','sub','range','ammo')

    end
	
    equip(sets[state.WeaponSet.current])

end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------


-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
    determine_haste_group()
    --check_moving()
end

function job_update(cmdParams, eventArgs)
	equip(sets[state.WeaponSet.current])
    handle_equipping_gear(player.status)
    th_update(cmdParams, eventArgs)
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

    if spell.type == 'WeaponSkill' and state.AttackMode.value == 'Uncapped' then
        wsmode = 'Uncapped'
    end

    return wsmode
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.Buff.Migawari then
       idleSet = set_combine(idleSet, sets.buff.Migawari)
    end
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
	if state.Auto_Kite.value == true then
        if world.time >= (17*60) or world.time <= (7*60) then
            idleSet = set_combine(idleSet, sets.NightMovement)
        else
            idleSet = set_combine(idleSet, sets.DayMovement)
        end
    end

    return idleSet
end


-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Migawari then
        meleeSet = set_combine(meleeSet, sets.buff.Migawari)
    end
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end
    if state.Buff.Sange then
        meleeSet = set_combine(meleeSet, sets.buff.Sange)
    end

    return meleeSet
end


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)

    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local ws_msg = state.WeaponskillMode.value

    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.TreasureMode.value == 'Tag' then
        msg = msg .. ' TH: Tag |'
    end
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
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

function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 2 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 2 and DW_needed <= 16 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 16 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 21 and DW_needed <= 34 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 34 then
            classes.CustomMeleeGroups:append('')
        end
    end
end


-- Determine whether we have sufficient tools for the spell being attempted.
function do_ninja_tool_checks(spell, spellMap, eventArgs)
    local ninja_tool_name
    local ninja_tool_min_count = 1

    -- Only checks for universal tools and shihei
    if spell.skill == "Ninjutsu" then
        if spellMap == 'Utsusemi' then
            ninja_tool_name = "Shihei"
        elseif spellMap == 'ElementalNinjutsu' then
            ninja_tool_name = "Inoshishinofuda"
        elseif spellMap == 'EnfeeblingNinjutsu' then
            ninja_tool_name = "Chonofuda"
        elseif spellMap == 'EnhancingNinjutsu' then
            ninja_tool_name = "Shikanofuda"
        else
            return
        end
    end

    local available_ninja_tools = player.inventory[ninja_tool_name] or player.wardrobe[ninja_tool_name]

    -- If no tools are available, end.
    if not available_ninja_tools then
        if spell.skill == "Ninjutsu" then
            return
        end
    end

    --Low ninja tools warning.
    if spell.skill == "Ninjutsu" and state.warned.value == false
        and available_ninja_tools.count > 1 and available_ninja_tools.count <= options.ninja_tool_warning_limit then
        local msg = '*****  LOW TOOLS WARNING: '..ninja_tool_name..' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end

        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_ninja_tools.count > options.ninja_tool_warning_limit and state.warned then
        state.warned:reset()
    end
end

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(2, 3)
    elseif player.sub_job == 'THF' then
        set_macro_page(3, 3)
    else
        set_macro_page(1, 3)
    end
end

function set_lockstyle()
	--send_command('wait 6; input /lockstyleset 17')
	send_command('wait 8; input /lockstyleset 56')
end

