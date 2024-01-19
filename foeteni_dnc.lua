-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

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
--              [ WIN+F ]           Toggle Closed Position (Facing) Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+- ]          Primary step element cycle forward.
--              [ CTRL+= ]          Primary step element cycle backward.
--              [ ALT+- ]           Secondary step element cycle forward.
--              [ ALT+= ]           Secondary step element cycle backward.
--              [ CTRL+[ ]          Toggle step target type.
--              [ CTRL+] ]          Toggle use secondary step.
--              [ Numpad0 ]         Perform Current Step
--
--              [ CTRL+` ]          Saber Dance
--              [ ALT+` ]           Chocobo Jig II
--              [ ALT+[ ]           Contradance
--              [ CTRL+Numlock ]    Reverse Flourish
--              [ CTRL+Numpad/ ]    Berserk/Meditate
--              [ CTRL+Numpad* ]    Warcry/Sekkanoki
--              [ CTRL+Numpad- ]    Aggressor/Third Eye
--              [ CTRL+Numpad+ ]    Climactic Flourish
--              [ CTRL+NumpadEnter ]Building Flourish
--              [ CTRL+Numpad0 ]    Sneak Attack
--              [ CTRL+Numpad. ]    Trick Attack
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  WS:         [ CTRL+Numpad7 ]    Exenterator
--              [ CTRL+Numpad4 ]    Evisceration
--              [ CTRL+Numpad5 ]    Rudra's Storm
--              [ CTRL+Numpad6 ]    Pyrrhic Kleos
--              [ CTRL+Numpad1 ]    Aeolian Edge
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------

--  gs c step                       Uses the currently configured step on the target, with either <t> or
--                                  <stnpc> depending on setting.
--  gs c step t                     Uses the currently configured step on the target, but forces use of <t>.
--
--  gs c cycle mainstep             Cycles through the available steps to use as the primary step when using
--                                  one of the above commands.
--  gs c cycle altstep              Cycles through the available steps to use for alternating with the
--                                  configured main step.
--  gs c toggle usealtstep          Toggles whether or not to use an alternate step.
--  gs c toggle selectsteptarget    Toggles whether or not to use <stnpc> (as opposed to <t>) when using a step.


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
	include('Mote-TreasureHunter')
	
    state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false

    state.MainStep = M{['description']='Main Step', 'Box Step', 'Quickstep', 'Feather Step', 'Stutter Step'}
    state.AltStep = M{['description']='Alt Step', 'Quickstep', 'Feather Step', 'Stutter Step', 'Box Step'}
    state.UseAltStep = M(false, 'Use Alt Step')
    state.SelectStepTarget = M(false, 'Select Step Target')
    state.IgnoreTargetting = M(true, 'Ignore Targetting')

    state.ClosedPosition = M(false, 'Closed Position')

    state.CurrentStep = M{['description']='Current Step', 'Main', 'Alt'}
--  state.SkillchainPending = M(false, 'Skillchain Pending')

    state.CP = M(false, "Capacity Points Mode")

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}

    lockstyleset = 60
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Regain')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Proc')
    state.IdleMode:options('Normal', 'DT', 'Regain')
	
	state.WeaponSet = M{['description']='Weapon Set', 'Aeonic', 'Mpu', 'Proc', 'Gleti'}
	state.WeaponLock = M(false, 'Weapon Lock')
    -- Additional local binds
	send_command('bind @w gs c toggle WeaponLock')
    send_command('bind ^- gs c cycleback mainstep')
    send_command('bind ^= gs c cycle mainstep')
    send_command('bind !- gs c cycleback altstep')
    send_command('bind != gs c cycle altstep')
    send_command('bind ^] gs c toggle usealtstep')
    send_command('bind ![ input /ja "Contradance" <me>')
    send_command('bind ^` input /ja "Saber Dance" <me>')
    send_command('bind !` input /ja "Fan Dance" <me>')
    send_command('bind @` input /ja "Chocobo Jig II" <me>')
    send_command('bind @f gs c toggle ClosedPosition')
    send_command('bind ^numlock input /ja "Reverse Flourish" <me>')

    send_command('bind @c gs c toggle CP')


    select_default_macro_book()
    set_lockstyle()

    state.Auto_Kite = M(false, 'Auto_Kite')
    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind !-')
    send_command('unbind !=')
    send_command('unbind ^]')
    send_command('unbind ^[')
    send_command('unbind ^]')
    send_command('unbind ![')
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind @`')
    send_command('unbind ^,')
    send_command('unbind @f')
    send_command('unbind @c')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad+')
    send_command('unbind ^numpadenter')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad6')
    send_command('unbind ^numpad1')
    send_command('unbind numpad0')
    send_command('unbind ^numpad0')
    send_command('unbind ^numpad.')

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

	sets.TreasureHunter = { 
		body=gear.Herculean.Body_TH,
		hands=gear.Herculean.Hands_TH,
		waist="Chaac Belt",

		}
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
-- snapshot/rapidshot
sets.precast.RA = {
    head=gear.Taeon.Head_Snp, --10/0
    body=gear.Taeon.Body_PHLX, --5/0
    hands=gear.Taeon.Hands_PHLX, --5/0
    legs="Adhemar Kecks +1", --10/13
    feet="Meg. Jam. +2", --10/0
    waist="Yemaya Belt", --0/5
	right_ring="Crepuscular Ring", --3/0
	} --43/70 snapshot / 18 rapid shot	


    -- Enmity set
    sets.Enmity = {
        ammo="Sapience Orb", --2
        --[[head="Halitus Helm", --8
        body="Emet Harness +1", --10
        hands="Horos Bangles +3", --9
		legs="Obatala Subligar", --5
        feet="Ahosi Leggings", --7
		]]
		head="Nyame Helm",
		body="Macu. Casaque +3",
		hands="Macu. Bangles +3",
		legs="Nyame Flanchard",
		feet="Macu. Toe Sh. +3",
        neck="Unmoving Collar +1", --10
		waist="Kasiri Belt", --3
        left_ear="Cryptic Earring", --4
        right_ear="Friomisi Earring", --5
        left_ring="Supershear Ring", --5
        ring2="Eihwaz Ring", --5
        back=gear.DNCcape_Waltz, --10
        }

    sets.precast.JA['Provoke'] = sets.Enmity
    sets.precast.JA['No Foot Rise'] = {body="Horos Casaque +2"}
    sets.precast.JA['Trance'] = {head="Horos Tiara +3"}

    sets.precast.Waltz = {
		head="Nyame Helm",
        body="Maxixi Casaque +3", --17(7)
		hands="Macu. Bangles +3",
        legs="Nyame Flanchard",
        feet="Maxixi Toe Shoes +3", --12
        neck="Etoile Gorget +2", --10
        --waist="Aristo Belt",
        back=gear.DNCcape_Waltz, --10
        } -- Waltz Potency/CHR

    sets.precast.WaltzSelf = set_combine(sets.precast.Waltz, {
        --head="Mummu Bonnet +2", --(8)
        --ring1="Asklepian Ring", --(3)
        --ear1="Roundel Earring", --5
        }) -- Waltz effects received

    sets.precast.Waltz['Healing Waltz'] = {}
    sets.precast.Samba = {head="Maxixi Tiara +3", back=gear.DNCcape_Waltz}
    sets.precast.Jig = {legs="Horos Tights +3", feet="Maxixi Toe Shoes +3"}

    sets.precast.Step = {
        ammo="C. Palug Stone",
		head="Nyame Helm",
        --head="Maxixi Tiara +3",
		body="Macu. Casaque +3",
		hands="Macu. Bangles +3",
        legs="Nyame Flanchard",
		--feet="Macu. Toe Sh. +3",
        feet="Horos T. Shoes +3",
        neck="Etoile Gorget +2",
        left_ear="Odr Earring",
        right_ear="Macu. Earring +2",
		left_ring="Defending Ring",
        right_ring="Chirich Ring",
        waist="Olseni Belt",
        back=gear.DNCcape_Dblatk,
        }

    sets.precast.Step['Feather Step'] = set_combine(sets.precast.Step, {feet="Macu. Toe Sh. +3"})
    sets.precast.Flourish1 = {}
    sets.precast.Flourish1['Animated Flourish'] = sets.Enmity

    sets.precast.Flourish1['Violent Flourish'] = {
        ammo="Yamarang",
        head="Mummu Bonnet +2",
        body="Horos Casaque +2",
        hands="Mummu Wrists +2",
        legs="Mummu Kecks +2",
        feet="Mummu Gamash. +2",
        neck="Etoile Gorget +2",
        ear1="Digni. Earring",
        ear2="Enchntr. Earring +1",
        ring1="Metamor. Ring +1",
        ring2="Weather. Ring +1",
        waist="Eschan Stone",
        back=gear.DNC_TP_Cape,
        } -- Magic Accuracy

    sets.precast.Flourish1['Desperate Flourish'] = {
        ammo="C. Palug Stone",
        head="Maxixi Tiara +3",
        body="Maxixi Casaque +3",
        hands="Gazu Bracelet +1",
        legs=gear.Herc_WS_legs,
        feet="Maxixi Toe Shoes +3",
        neck="Etoile Gorget +2",
        ear1="Cessance Earring",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe4"},
        back=gear.DNC_TP_Cape,
        } -- Accuracy

    sets.precast.Flourish2 = {}
    sets.precast.Flourish2['Reverse Flourish'] = {hands="Macu. Bangles +3",    back="Toetapper Mantle"}
    sets.precast.Flourish3 = {}
    sets.precast.Flourish3['Striking Flourish'] = {body="Macu. Casaque +3"}
    sets.precast.Flourish3['Climactic Flourish'] = {head="Maculele Tiara +3",}

    sets.precast.FC = {
        ammo="Sapience Orb",
        head=gear.Herc_MAB_head, --7
        body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}}, --10
        hands="Leyline Gloves", --8
        legs="Rawhide Trousers", --5
        feet=gear.Herc_MAB_feet, --2
        neck="Orunmila's Torque", --5
        ear1="Loquacious Earring", --2
        ear2="Enchntr. Earring +1", --2
        ring2="Weather. Ring +1", --6(4)
        }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        ammo="Impatiens",
        body="Passion Jacket",
        ring1="Lebeche Ring",
        })


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        ammo="Coiste Bodhar",
        head="Maculele Tiara +3",
		body="Nyame Mail",
        hands="Nyame Gauntlets",
		legs="Nyame Flanchard", 
        feet="Nyame Sollerets",
        neck="Etoile Gorget +2",
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Macu. Earring +2",
        left_ring="Epaminondas's Ring", 
		right_ring="Ephramad's Ring",
        back=gear.DNCcape_WSdex,
        } -- default set
		
	sets.precast.WS.proc = {
        ammo="Yamarang",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
        neck="Etoile Gorget +2",
		waist="Reiki Yotai",
		left_ear="Crep. Earring",
		right_ear="Macu. Earring +2",
        left_ring="Chirich Ring +1", 
		right_ring="Chirich Ring +1",
        back=gear.DNCcape_Dblatk,
        } -- default set

	--was for sneak attack i commented it out in post_precast
    sets.precast.WS.Critical = {

		}

    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
        head="Adhemar Bonnet +1",
		hands="Gleti's Gauntlets",
        left_ear="Sherida Earring",
		left_ring="Ilabrat Ring",
        back=gear.DNCcape_Dblatk,
		})
		
	sets.precast.WS['Exenterator'].proc= sets.precast.WS.proc
		
    sets.precast.WS['Pyrrhic Kleos'] = set_combine(sets.precast.WS, {
		--neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
        left_ring="Gere Ring",
        back=gear.DNCcape_Dblatk,
        })
		
	sets.precast.WS['Pyrrhic Kleos'].proc = sets.precast.WS.proc
	
    sets.precast.WS['Ruthless Stroke'] = set_combine(sets.precast.WS, {
		neck="Fotia Gorget",
		waist="Fotia Belt",
        })
		
	sets.precast.WS['Ruthless Stroke'].proc = sets.precast.WS.proc

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        ammo="Charis Feather",
        --head="Adhemar Bonnet +1",
		head="Blistering Sallet +1",
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
		feet="Macu. Toe Sh. +3",
		--neck="Fotia Gorget",
		waist="Fotia Belt",
        left_ear="Odr Earring",
        left_ring="Begrudging Ring",
        back=gear.DNCcape_Dblatk,
        })
		
	sets.precast.WS['Evisceration'].proc = sets.precast.WS.proc

    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {
        ammo="Charis Feather",
        neck="Etoile Gorget +2",
		waist="Sailfi Belt +1",
        })
		
	sets.precast.WS["Rudra's Storm"].proc = sets.precast.WS.proc
		
    sets.precast.WS['Shark Bite'] = set_combine(sets.precast.WS, {
        ammo="Charis Feather",
        neck="Etoile Gorget +2",
		waist="Sailfi Belt +1",
        })
		
	sets.precast.WS['Shark Bite'].proc = sets.precast.WS.proc

    sets.precast.WS['Aeolian Edge'] = {
        ammo="Ghastly Tathlum +1",
		head="Nyame Helm",
		body="Nyame Mail",
        hands="Nyame Gauntlets",
		legs="Nyame Flanchard", 
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		left_ring="Epaminondas's Ring", 
        }
		
	sets.precast.WS['Aeolian Edge'].proc = sets.precast.WS.proc

    sets.precast.Skillchain = {
        hands="Macu. Bangles +3",
        }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Staunch Tathlum +1", --11
        body=gear.Taeon_Phalanx_body, --10
        hands="Rawhide Gloves", --15
        legs=gear.Taeon_Phalanx_legs, --10
        feet=gear.Taeon_Phalanx_feet, --10
        neck="Loricate Torque +1", --5
        ear1="Halasz Earring", --5
        ear2="Magnetic Earring", --8
        ring2="Evanescence Ring", --5
        }


    -- Ranged gear

sets.midcast.RA = {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
	feet="Malignance Boots",
    neck="Combatant's Torque",
    waist="Yemaya Belt",
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    left_ring="Defending Ring",
    right_ring="Crepuscular Ring",
    --back=gear.CORcape_rSTP,
	}

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    sets.idle = {
        ammo="Staunch Tathlum",
		head="Gleti's Mask",
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
        neck="Bathy Choker +1",
        waist="Engraved Belt",
        left_ear="Infused Earring",
        right_ear="Eabani Earring",
        left_ring="Defending Ring",
        right_ring="Shneddick Ring",
        back=gear.DNCcape_Waltz,
        }

    sets.idle.DT = set_combine(sets.idle, {
        ammo="Staunch Tathlum", --3/3
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
        })

    sets.idle.Town = set_combine(sets.idle, {
		head="Shaded Specs.",
		body="Goldsmith's Apron",
		neck="Goldsm. Torque",
        right_ear="Macu. Earring +2",
		left_ring="Craftmaster's Ring",
        })
		
	sets.idle.Regain = {
        ammo="Staunch Tathlum",
		head="Gleti's Mask",
		body="Gleti's Cuirass",
		hands="Regal Gloves",
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
        neck="Rep. Plat. Medal",
        waist="Engraved Belt",
        left_ear="Infused Earring",
        right_ear="Eabani Earring",
        left_ring="Defending Ring",
        right_ring="Roller's Ring",
        back=gear.DNCcape_Waltz,
	}

    sets.idle.Weak = sets.idle.DT

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
	
    sets.engaged = {
        ammo="Yamarang",
        head="Malignance Chapeau",
        body="Gleti's Cuirass",
        hands="Adhemar Wrist. +1",
        legs="Gleti's Breeches",
        feet="Macu. Toe Sh. +3",
        neck="Etoile Gorget +2",
		waist="Windbuffet Belt +1",
        left_ear="Sherida Earring",
        right_ear="Macu. Earring +2",
        left_ring="Gere Ring",
        right_ring="Epona's Ring",
        back=gear.DNCcape_Dblatk,
        }

	sets.engaged.Regain = {
		ammo="Yamarang",
		head="Gleti's Mask",
		body="Gleti's Cuirass",
		--hands="Gleti's Gauntlets",
		hands="Regal Gloves",
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
		neck="Rep. Plat. Medal",
		waist="Windbuffet Belt +1",
        left_ear="Sherida Earring",
        right_ear="Macu. Earring +2",
        left_ring="Gere Ring",
		right_ring="Roller's Ring",
		back=gear.DNCcape_Dblatk,
	}
    -- * DNC Native DW Trait: 30% DW
    -- * DNC Job Points DW Gift: 5% DW

    -- No Magic Haste (39% DW to cap, 37% w/ Haste Samba)
    sets.engaged.DW = {
        ammo="Yamarang",
        head="Malignance Chapeau",
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        hands="Adhemar Wrist. +1",
        legs="Gleti's Breeches",
        feet="Macu. Toe Sh. +3",
        neck="Etoile Gorget +2",
		waist="Reiki Yotai", --7
        left_ear="Suppanomimi", --5
        right_ear="Eabani Earring", --4
        left_ring="Gere Ring",
        right_ring="Epona's Ring",
        back=gear.DNCcape_Dblatk,
        } --22
		
	sets.engaged.DW.Regain = sets.engaged.Regain

    -- 15% Magic Haste (32% DW to cap, 29 w/ Haste Samba)
    sets.engaged.DW.LowHaste = {
        ammo="Yamarang",
        head="Malignance Chapeau",
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        hands="Adhemar Wrist. +1",
        legs="Gleti's Breeches",
        feet="Macu. Toe Sh. +3",
        neck="Etoile Gorget +2",
		waist="Reiki Yotai", --7
        left_ear="Suppanomimi", --5
        right_ear="Eabani Earring", --4
        left_ring="Gere Ring",
        right_ring="Epona's Ring",
        back=gear.DNCcape_Dblatk,
        } --22
		
	sets.engaged.DW.Regain.LowHaste = sets.engaged.Regain

    -- 30% Magic Haste (21% DW to cap, 15% w/ Haste Samba)
    sets.engaged.DW.MidHaste = {
        ammo="Yamarang",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Adhemar Wrist. +1",
        legs="Gleti's Breeches",
        feet="Macu. Toe Sh. +3",
        neck="Etoile Gorget +2",
		waist="Reiki Yotai", --7
        left_ear="Suppanomimi", --5
        right_ear="Eabani Earring", --4
        left_ring="Gere Ring",
        right_ring="Epona's Ring",
        back=gear.DNCcape_Dblatk,
        } --16
		
	sets.engaged.DW.Regain.MidHaste = sets.engaged.Regain
		
    -- 35% Magic Haste (just gonna act like cap)
    sets.engaged.DW.HighHaste = {
        ammo="Yamarang",
        head="Malignance Chapeau",
        body="Malignance Tabard",
		--body="Gleti's Cuirass",
        hands="Adhemar Wrist. +1",
        legs="Gleti's Breeches",
        feet="Macu. Toe Sh. +3",
        neck="Etoile Gorget +2",
		waist="Sailfi Belt +1", 
        left_ear="Sherida Earring", 
        right_ear="Macu. Earring +2",
        left_ring="Gere Ring",
        right_ring="Epona's Ring",
        back=gear.DNCcape_Dblatk,
        } --

	sets.engaged.DW.Regain.HighHaste = sets.engaged.Regain
	
    -- 45% Magic Haste (0 DW to cap) refer to set above HighHaste
    sets.engaged.DW.MaxHaste = sets.engaged.DW.HighHaste
	
	sets.engaged.DW.Regain.MaxHaste = sets.engaged.Regain



    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Gleti's Breeches",
        feet="Macu. Toe Sh. +3",
        ring1="Moonlight Ring", --5/5
        ring2="Moonlight Ring", --5/5]]
        }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff['Saber Dance'] = {legs="Horos Tights +3"}
    sets.buff['Fan Dance'] = {hands="Horos Bangles +3"}
    sets.buff['Climactic Flourish'] = {
		ammo="Charis Feather",
		head="Maculele Tiara +3",
	}
    sets.buff['Closed Position'] = {feet="Horos T. Shoes +3"}

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Eshmun's Ring", bag="wardrobe3"}, --20
        ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20
        waist="Gishdubar Sash", --10
        }

    sets.CP = {back="Mecisto. Mantle"}
    --sets.Reive = {neck="Ygnas's Resolve +1"}
	
	sets.MaxTPdex = {
		left_ear="Odr Earring",
	}
	
	--Weapon Sets ------------------
	
	sets.Aeonic = {
		main="Aeneas",
		sub="Gleti's Knife",
	}
	
	sets.Gleti = {
		main="Gleti's Knife",
		sub="Centovente",
	}
	
	sets.Proc = {
		main="Bone Knife",
		sub="Joyeuse",
	}
	
	sets.Mpu = {
		main="Mpu Gandring",
		sub="Centovente",
	}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    --auto_presto(spell)
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
       --[[ if state.Buff['Sneak Attack'] == true then
            equip(sets.precast.WS.Critical)
        end  ]]
        if state.Buff['Climactic Flourish'] then
            equip(sets.buff['Climactic Flourish'])
        end
		if player.equipment.sub == "Centovente" and player.tp > 1400 then
            equip(sets.MaxTPdex)
		elseif player.equipment.main == "Aeneas" and player.tp > 1900 then
			equip(sets.maxTP)
        end
    end
    if spell.type=='Waltz' and spell.english:startswith('Curing') and spell.target.type == 'SELF' then
        equip(sets.precast.WaltzSelf)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
    if buff == 'Saber Dance' or buff == 'Climactic Flourish' or buff == 'Fan Dance' then
        handle_equipping_gear(player.status)
    end

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

        disable('main','sub', 'range', 'ammo')
		--'main','sub','range', 'ammo', 'back', 'neck'

    else

        enable('main','sub','range', 'ammo', 'neck')

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

function customize_idle_set(idleSet)
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end

function customize_melee_set(meleeSet)
    --if state.Buff['Climactic Flourish'] then
    --    meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
    --end
    if state.ClosedPosition.value == true then
        meleeSet = set_combine(meleeSet, sets.buff['Closed Position'])
    end

    return meleeSet
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        if state.IgnoreTargetting.value == true then
            state.IgnoreTargetting:reset()
            eventArgs.handled = true
        end

        eventArgs.SelectNPCTargets = state.SelectStepTarget.value
    end
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

    local ws_msg = state.WeaponskillMode.value

    local s_msg = state.MainStep.current
    if state.UseAltStep.value == true then
        s_msg = s_msg .. '/'..state.AltStep.current
    end

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
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Step: '  ..string.char(31,001)..s_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 1 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 1 and DW_needed <= 11 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 11 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 21 and DW_needed <= 39 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 39 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'step' then
        if cmdParams[2] == 't' then
            state.IgnoreTargetting:set()
        end

        local doStep = ''
        if state.UseAltStep.value == true then
            doStep = state[state.CurrentStep.current..'Step'].current
            state.CurrentStep:cycle()
        else
            doStep = state.MainStep.current
        end

        send_command('@input /ja "'..doStep..'" <t>')
    end

    gearinfo(cmdParams, eventArgs)
end


-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        local allRecasts = windower.ffxi.get_ability_recasts()
        local prestoCooldown = allRecasts[236]
        --local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and not buffactive['Finishing Move 5']

        if player.main_job_level >= 77 and prestoCooldown < 1 then --and under3FMs then
            cast_delay(1.1)
            send_command('input /ja "Presto" <me>')
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
    if player.sub_job == 'WAR' then
        set_macro_page(1, 16)
    else
        set_macro_page(1, 16)
    end
end

function set_lockstyle()
    send_command('wait 8; input /lockstyleset ' .. lockstyleset)
end
