-------------------------------------------------------------------------------------------------------------------
-- (Original: Motenten / Modified: Arislan)
-------------------------------------------------------------------------------------------------------------------

--[[    Custom Features:
        
        Magic Burst            Toggle Magic Burst Mode  [Alt-`]
        Capacity Pts. Mode    Capacity Points Mode Toggle [WinKey-C]
        Auto. Lockstyle        Automatically locks desired equipset on file load
--]]

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
    indi_timer = ''
    indi_duration = 180

    state.CP = M(false, "Capacity Points Mode")
    
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Seidr', 'Resistant')
    state.IdleMode:options('Normal', 'DT')

    state.WeaponLock = M(false, 'Weapon Lock')    
    state.MagicBurst = M(false, 'Magic Burst')

    -- Additional local binds
	include('organizer-lib')

    send_command('bind ^` input /ja "Full Circle" <me>')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind @c gs c toggle CP')
    send_command('bind @w gs c toggle WeaponLock')

    send_command('bind ^numpad7 input /ws "Black Halo" <t>')
    send_command('bind ^numpad8 input /ws "Hexa Strike" <t>')
    send_command('bind ^numpad9 input /ws "Realmrazer" <t>')
    send_command('bind ^numpad6 input /ws "Exudation" <t>')
    send_command('bind ^numpad1 input /ws "Flash Nova" <t>')
    
    select_default_macro_book()
    set_lockstyle()
end

function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^,')
    send_command('unbind !.')
    send_command('unbind @c')
    send_command('unbind @w')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad9')
    send_command('unbind ^numpad6')
    send_command('unbind ^numpad1')
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Precast Sets -----------------------------------------
    ------------------------------------------------------------------------------------------------
    
    -- Precast sets to enhance JAs
    sets.precast.JA.Bolster = {body="Bagua Tunic +1"}
    sets.precast.JA['Full Circle'] = {head="Azimuth Hood +1"}
    sets.precast.JA['Life Cycle'] = {body="Geo. Tunic +1", back="Nantosuelta's Cape"}
  
    -- Fast cast sets for spells
    
    sets.precast.FC = {
    --  /RDM --15
        main="Solstice", --5
        sub="Ammurapi Shield",
		range="Dunna", --3
		head=gear.Merlinic.Head_FC, --15
		body="Zendik Robe", --13
		hands=gear.Telchine.Hands_dur, --4
		legs="Geo. Pants +1", --11
		feet=gear.Merlinic.Feet_FC, --11
		neck="Voltsurge Torque", --4
		waist="Channeler's Stone", --2
		left_ear="Loquac. Earring", --2
		right_ear="Etiolation Earring", --1
		left_ring="Kishar Ring",--4
		right_ring="Prolix Ring", --5
		back="Lifestream Cape", --7
        } --total = 87 in gear....

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
        waist="Siegel Sash",
        })
        
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {
        hands="Bagua Mitaines +1",
		left_ear="Barkarole Earring",
        })

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        --main="Oranyan", --7
        --sub="Clerisy Strap +1", --3
		--left_ear="Mendi. Earring", --5
        --left_ring="Lebeche Ring", --(2)
        })

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {
		head=empty, 
		body="Twilight Cloak"
		})

     
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Jhakri Coronal +2",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +2",
        legs="Jhakri Slops +2",
        feet="Jhakri Pigaches +2",
        neck="Fotia Gorget",
		waist="Fotia Belt",
        left_ear="Moonshade Earring",
        right_ear="Telos Earring",
        left_ring="Rufescent Ring",
        right_ring="Epaminondas's Ring",
        --back="Relucent Cape",
        }

    
    ------------------------------------------------------------------------
    ----------------------------- Midcast Sets -----------------------------
    ------------------------------------------------------------------------
    
    -- Base fast recast for spells
    sets.midcast.FastRecast = {
        main="Solstice",
        sub="Ammurapi Shield",
        range="Dunna",
		head=gear.Merlinic.Head_FC, --15
		body="Zendik Robe", --13
		hands=gear.Telchine.Hands_dur, --4
		legs="Geo. Pants +1", --11
		feet=gear.Merlinic.Feet_FC, --11
		neck="Voltsurge Torque", --4
		waist="Channeler's Stone", --2
		left_ear="Loquac. Earring", --2
		right_ear="Etiolation Earring", --1
		left_ring="Kishar Ring",--4
		right_ring="Prolix Ring", --5
		back="Lifestream Cape", --7
        } -- Haste
    
   sets.midcast.Geomancy = {
        main="Solstice",
        sub="Genbu's Shield",
        range="Dunna",
        head="Azimuth Hood +1",
        body="Bagua Tunic +1",
        hands="Geo. Mitaines +1",
        legs="Azimuth Tights +1",
        feet="Azimuth Gaiters +1",
        neck="Bagua Charm",
        left_ear="Gifted Earring",
        right_ear="Gwati Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back="Lifestream Cape",
        waist="Kobo Obi",
        }
    
    sets.midcast.Geomancy.Indi = set_combine(sets.midcast.Geomancy, {
        legs="Bagua Pants +1",
        })

    sets.midcast.Cure = {
		main="Daybreak", --30
		sub="Genbu's Shield", --4
		head="Vanya Hood", --10
		body="Vanya Robe", 
		hands="Vanya Cuffs", 
		legs="Vanya Slops", 
		feet="Vanya Clogs", --5
		neck="Incanter's Torque", --4
		waist="Gishdubar Sash",
        left_ear="Malignance Earring",
        right_ear="Mendi. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Tempered Cape", --4
		--total 62
        }

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
        --neck="Nuna Gorget +1",
        --left_ring="Levia. Ring +1",
        --right_ring="Levia. Ring +1",
        })

    sets.midcast.Cursna = set_combine(sets.midcast.Cure, {
        main="Gada",
        sub="Genmei Shield",
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
        main="Gada",
        sub="Ammurapi Shield",
		head=gear.Telchine.Head_dur,
		body=gear.Telchine.Body_dur, 
		hands=gear.Telchine.Hands_dur, 
		legs=gear.Telchine.Legs_dur,
		feet=gear.Telchine.Feet_dur,
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Augment. Earring",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Perimede Cape",
        --back="Fi Follet Cape +1",
        }
        
    sets.midcast.EnhancingDuration = {
        main="Gada",
        sub="Genmei Shield",
        head=gear.Telchine.Head_dur,
        body=gear.Telchine.Body_dur,
        hands=gear.Telchine.Hands_dur,
        legs=gear.Telchine.Legs_dur,
        feet=gear.Telchine.Feet_dur,
		waist="Embla Sash",
        }

    sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {
        main="Bolelabunga",
        --sub="Genmei Shield",
        body=gear.Telchine.Body_dur,
        })
    
    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
        head="Amalric Coif +1",
        waist="Gishdubar Sash",
        --back="Grapevine Cape",
        })
            
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
        legs="Haven Hose",
        neck="Nodens Gorget",
        waist="Siegel Sash",
		left_ear="Earthcry Earring",
        })

    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {
        --main="Vadose Rod",
        head="Amalric Coif +1",
        waist="Emphatikos Rope",
        })

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {
        left_ring="Sheltered Ring",
        })
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect


    sets.midcast.MndEnfeebles = {
        main="Daybreak",
        sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head=gear.Merlinic.Head_MACC,
		body=gear.Merlinic.Body_MACC,
		hands="Mallquis Cuffs +2",
		legs=gear.Merlinic.Legs_MACC,
		feet="Jhakri Pigaches +2",
		neck="Bagua Charm",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Barkaro. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Lifestream Cape",
		--back="Aurist's Cape +1",
        } -- MND/Magic accuracy
    
    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
		body=gear.Merlinic.Body_MAB,
        --back="Nantosuelta's Cape",
        }) -- INT/Magic accuracy

    sets.midcast['Dark Magic'] = {
        main="Daybreak",
        sub="Genbu's Shield",
		ammo="Pemphredo Tathlum",
		gear.Merlinic.Head_MACC,
		gear.Merlinic.Body_ASPIR,
		hands=gear.Merlinic.Hands_MACC,
		legs=gear.Merlinic.Legs_MACC,  
		feet="Jhakri Pigaches +2",
		neck="Erra Pendant",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Barkaro. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
        back="Perimede Cape",
        }
    
    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head="Bagua Galero +1",
		legs=gear.Merlinic.Legs_ASPIR,
		feet=gear.Merlinic.Feet_Burst,
        left_ear="Hirudinea Earring",
        right_ring="Evanescence Ring",
        waist="Fucho-no-obi",  
        })
    
    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {
        --feet="Regal Pumps +1"
        })

    -- Elemental Magic sets
    
    sets.midcast['Elemental Magic'] = {
        main="Daybreak",
        sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head=gear.Merlinic.Head_MACC,
		body=gear.Merlinic.Body_MAB,
		hands=gear.Merlinic.Hands_MACC,
		legs=gear.Merlinic.Legs_MACC,
		feet="Jhakri Pigaches +2",
		neck="Sanctity Necklace",
		waist="Yamabuki-no-Obi",
		left_ear="Friomisi Earring",
		right_ear="Barkaro. Earring",
        left_ring="Shiva Ring",
        right_ring="Shiva Ring",
        back="Toro Cape",
        }

    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
--[[        main=gear.Grioavolr_MB,
        sub="Enki Strap",
        hands="Ea Cuffs",
        feet="Jhakri Pigaches +2",
        neck="Erra Pendant",
        back="Aurist's Cape +1",
        waist="Yamabuki-no-Obi",  ]]
        })

    sets.midcast.GeoElem = set_combine(sets.midcast['Elemental Magic'], {
        main="Daybreak",
        sub="Culminus",
        --left_ring="Fenrir Ring +1",
        --right_ring="Fenrir Ring +1",
        })

    sets.midcast['Elemental Magic'].Seidr = set_combine(sets.midcast['Elemental Magic'], {
 --[[       sub="Enki Strap",
        body="Seidr Cotehardie",
        hands="Ea Cuffs",
        legs=gear.Merlinic_MAcc_legs,
        feet="Jhakri Pigaches +2",
        neck="Sanctity Necklace",   ]]
        })

    sets.midcast.GeoElem.Seidr = set_combine(sets.midcast['Elemental Magic'].Seidr, {
 --[[       main="Solstice",
        sub="Culminus",        
        body="Seidr Cotehardie",
        hands="Ea Cuffs",
        neck="Erra Pendant",
        left_ring="Fenrir Ring +1",
        right_ring="Fenrir Ring +1",    ]]
        })

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
        head=empty,
        body="Twilight Cloak",
        right_ring="Archon Ring",
        })

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC

    ------------------------------------------------------------------------------------------------
    ------------------------------------------ Idle Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
        main="Daybreak",
        sub="Genmei Shield",
        ranged="Dunna",
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
        back="Moonbeam Cape",
        }
    
    sets.resting = set_combine(sets.idle, {
        --main="Chatoyant Staff",
        --waist="Shinjutsu-no-Obi +1",
        })

    sets.idle.DT = set_combine(sets.idle, {
        sub="Genmei Shield", --10/0
        body="Mallquis Saio +2", --6/6
        feet="Azimuth Gaiters +1", --4/0
        neck="Loricate Torque +1", --6/6
        --left_ear="Genmei Earring", --2/0
        right_ear="Etiolation Earring", --0/3
        left_ring="Defending Ring", --7/(-1)
		--waist="Slipor Sash", --0/3
        })

    sets.idle.Weak = sets.idle.DT

    -- .Pet sets are for when- Luopan is present.
    sets.idle.Pet = set_combine(sets.idle, { 
        -- Pet: -DT (37.5% to cap) / Pet: Regen 
        main="Sucellus", --3/3
        sub="Genmei Shield", 
        range="Dunna", --5/0
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Bagua Charm",
		waist="Isa Belt", --3/1
        left_ear="Handler's Earring", --3*/0
        right_ear="Handler's Earring +1", --4*/0
        back="Nantosuelta's Cape", --0/10
        })

    sets.idle.DT.Pet = set_combine(sets.idle.Pet, {
		right_ear="Eabani Earring", 
        left_ring="Defending Ring", --7/(-1)
        right_ring="Shneddick Ring", --10/10
        })

    -- .Indi sets are for when an Indi-spell is active.
--    sets.idle.Indi = set_combine(sets.idle, {legs="Bagua Pants +1"})
--    sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {legs="Bagua Pants +1"})
--    sets.idle.DT.Indi = set_combine(sets.idle.DT, {legs="Bagua Pants +1"})
--    sets.idle.DT.Pet.Indi = set_combine(sets.idle.DT.Pet, {legs="Bagua Pants +1"})

    sets.idle.Town = set_combine(sets.idle, {
		head="Shaded Specs.",
		body="Goldsmith's Apron",
		neck="Goldsm. Torque",
		left_ring="Craftmaster's Ring",
        })
        
    -- Defense sets

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {
        feet="Geo. Sandals +1"
        }

    sets.latent_refresh = {
        waist="Fucho-no-obi"
        }
    
    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {        
        head="Jhakri Coronal +2",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +2",
        legs="Jhakri Slops +2",
        feet="Jhakri Pigaches +2",
        neck="Loricate Torque +1",
		waist="Eschan Stone",
        left_ear="Brutal Earring",
        right_ear="Telos Earring",
        left_ring="Defending Ring",
        right_ring="Shneddick Ring",
        back="Moonbeam Cape",
        }


    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.magic_burst = {
        main="Grioavolr",
        sub="Enki Strap",
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
        back="Toro Cape", --5
        }

    sets.buff.Doom = {
	left_ring="Purity Ring", 
	--right_ring="Eshmun's Ring", 
	waist="Gishdubar Sash",
	}

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Elemental Magic' then 
        if state.MagicBurst.value then
            equip(sets.magic_burst)
            if spell.english == "Impact" then
                equip(sets.midcast.Impact)
            end
        end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    end
    if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
        equip(sets.midcast.EnhancingDuration)
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english:startswith('Indi') then
            if not classes.CustomIdleGroups:contains('Indi') then
                classes.CustomIdleGroups:append('Indi')
            end
            --send_command('@timers d "'..indi_timer..'"')
            --indi_timer = spell.english
            --send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
        elseif spell.skill == 'Elemental Magic' then
 --           state.MagicBurst:reset()
        end
        if spell.english == "Sleep II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        end 
    elseif not player.indi then
        classes.CustomIdleGroups:clear()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if player.indi and not classes.CustomIdleGroups:contains('Indi')then
        classes.CustomIdleGroups:append('Indi')
        handle_equipping_gear(player.status)
    elseif classes.CustomIdleGroups:contains('Indi') and not player.indi then
        classes.CustomIdleGroups:clear()
        handle_equipping_gear(player.status)
    end

    if buff == "doom" then
        if gain then           
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
            disable('left_ring','right_ring','waist')
        else
            enable('left_ring','right_ring','waist')
            handle_equipping_gear(player.status)
        end
    end

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Geomancy' then
            if spell.english:startswith('Indi') then
                return 'Indi'
            end
        elseif spell.skill == 'Elemental Magic' then
            if spellMap == 'GeoElem' then
                return 'GeoElem'
            end
        end
    end
end

function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end

    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    classes.CustomIdleGroups:clear()
    if player.indi then
        classes.CustomIdleGroups:append('Indi')
    end
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'nuke' then
        handle_nuking(cmdParams)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 10)
end

function set_lockstyle()
     send_command('wait 6; input /lockstyleset 17')
	 --send_command('wait 6; input /lockstyleset 79')
end