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

--              [ WIN+H ]           Toggle Charm Defense Mods

--              [ WIN+D ]           Toggle Death Defense Mods

--              [ WIN+K ]           Toggle Knockback Defense Mods

--              [ WIN+A ]           AttackMode: Capped/Uncapped WS Modifier

--              [ WIN+C ]           Toggle Capacity Points Mode

--

--  Abilities:  [ CTRL+` ]          Use current Rune

--              [ CTRL+- ]          Rune element cycle forward.

--              [ CTRL+= ]          Rune element cycle backward.

--              [ CTRL+` ]          Use current Rune

--

--              [ CTRL+Numpad/ ]    Berserk/Meditate/Souleater

--              [ CTRL+Numpad* ]    Warcry/Sekkanoki/Arcane Circle

--              [ CTRL+Numpad- ]    Aggressor/Third Eye/Weapon Bash

--

--  Spells:     [ WIN+, ]           Utsusemi: Ichi

--              [ WIN+. ]           Utsusemi: Ni

--

--  Weapons:    [ CTRL+G ]          Cycles between available greatswords

--              [ CTRL+W ]          Toggle Weapon Lock

--

--  WS:         [ CTRL+Numpad7 ]    Resolution

--              [ CTRL+Numpad8 ]    Upheaval

--              [ CTRL+Numpad9 ]    Dimidiation

--              [ CTRL+Numpad5 ]    Ground Strike

--              [ CTRL+Numpad6 ]    Full Break

--              [ CTRL+Numpad1 ]    Herculean Slash

--              [ CTRL+Numpad2 ]    Shockwave

--              [ CTRL+Numpad3 ]    Armor Break

--

--

--              (Global-Binds.lua contains additional non-job-related keybinds)





-------------------------------------------------------------------------------------------------------------------

--  Custom Commands (preface with /console to use these in macros)

-------------------------------------------------------------------------------------------------------------------





--  gs c rune                       Uses current rune

--  gs c cycle Runes                Cycles forward through rune elements

--  gs c cycleback Runes            Cycles backward through rune elements





-------------------------------------------------------------------------------------------------------------------

-- Setup functions for this job.  Generally should not be modified.

-------------------------------------------------------------------------------------------------------------------



-- Initialization function for this job file.

function get_sets()

    mote_include_version = 2



    -- Load and initialize the include file.

    include('Mote-Include.lua')

    res = require 'resources'

end



-- Setup vars that are user-independent.

function job_setup()



    -- /BLU Spell Maps

    blue_magic_maps = {}

    blue_magic_maps.Enmity = S{'Blank Gaze', 'Geist Wall', 'Jettatura', 'Soporific',

        'Poison Breath', 'Blitzstrahl', 'Sheep Song', 'Chaotic Eye', 'Stinking Gas'}

    blue_magic_maps.Cure = S{'Wild Carrot'}

    blue_magic_maps.Buffs = S{'Cocoon', 'Refueling'}



    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",

              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}



    rayke_duration = 50

    gambit_duration = 96



    lockstyleset = 79



end



-------------------------------------------------------------------------------------------------------------------

-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.

-------------------------------------------------------------------------------------------------------------------



function user_setup()

    state.OffenseMode:options('Normal', 'Hybrid')

    state.WeaponskillMode:options('Normal', 'DD')

    state.HybridMode:options('Normal', 'DD')

    state.CastingMode:options('Normal', 'Tank')

    state.IdleMode:options('Normal', 'DT', 'Enm')

    state.PhysicalDefenseMode:options('PDT', 'HP')

    state.MagicalDefenseMode:options('MDT')



    state.Knockback = M(false, 'Knockback')



    state.WeaponSet = M{['description']='Weapon Set', 'Epeolatry', 'Aettir', 'Lycurgos', 'Naegling'}

    state.AttackMode = M{['description']='Attack', 'Uncapped', 'Capped'}

    -- state.CP = M(false, "Capacity Points Mode")

    state.WeaponLock = M(false, 'Weapon Lock')



    state.Runes = M{['description']='Runes', 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda', 'Lux', 'Tenebrae'}



    -- Additional local binds

    --include('Global-Binds.lua') -- OK to remove this line

    --include('Global-GEO-Binds.lua') -- OK to remove this line



    send_command('lua l gearinfo')



    send_command('bind ^` input //gs c rune')

    send_command('bind !` input /ja "Vivacious Pulse" <me>')

    send_command('bind ^insert gs c cycleback Runes')

    send_command('bind ^delete gs c cycle Runes')

    send_command('bind @a gs c cycle AttackMode')

    -- send_command('bind @c gs c toggle CP')


    send_command('bind @w gs c toggle WeaponLock')



    send_command('bind @w gs c toggle WeaponLock')




    select_default_macro_book()

    set_lockstyle()



    state.Auto_Kite = M(false, 'Auto_Kite')

    moving = false

end



function user_unload()

    send_command('unbind ^`')

    send_command('unbind !`')

    send_command('unbind ^f11')

    send_command('unbind ^insert')

    send_command('unbind ^delete')

    send_command('unbind @a')

    -- send_command('unbind @c')

    send_command('unbind @d')

    send_command('unbind !q')

    send_command('unbind @w')

    send_command('unbind !o')

    send_command('unbind !p')

    send_command('unbind ^,')

    send_command('unbind @w')

    send_command('unbind ^numpad/')

    send_command('unbind ^numpad*')

    send_command('unbind ^numpad-')

    send_command('unbind ^numpad7')

    send_command('unbind ^numpad9')

    send_command('unbind ^numpad5')

    send_command('unbind ^numpad1')

    send_command('unbind @numpad*')



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



    send_command('lua u gearinfo')

end



-- Define sets and vars used by this job file.

function init_gear_sets()



    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Precast Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------



    -- Enmity sets

     sets.Enmity = {
        --[[ammo="Sapience Orb", --2
        head="Halitus Helm", --8
        body="Emet Harness +1", --10
        hands="Kurys Gloves", --9
        legs="Eri. Leg Guards +2", --7
        feet="Erilaz Greaves +2",--6 ]]
		ammo="Staunch Tathlum",
		head="Halitus Helm", --8
		body="Nyame Mail",
		hands="Nyame Gauntlets",
        legs={name="Eri. Leg Guards +3", priority = 12}, --100
		feet={name="Erilaz Greaves +3", priority = 9}, --48
        neck={name="Unmoving Collar +1", priority = 15}, --10
		waist={name="Kasiri Belt", priority = 13}, --3
		left_ear="Tuisto Earring", 
		right_ear="Odnowa Earring +1",
		left_ring="Defending Ring",
		--[[left_ear="Cryptic Earring", --4
		right_ear="Friomisi Earring", --2
		left_ring="Supershear Ring", --5]]
		right_ring={name="Eihwaz Ring", priority = 14},--5
		back={name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Evasion+10','Enmity+10','DEF+50',}, priority = 8}, --60    
          } --85/200 or 55/200



    sets.Enmity.HP = set_combine(sets.defense.HP, {
		ammo="Sapience Orb", --2
		head="Halitus Helm", --6
        hands="Kurys Gloves", --9
		neck="Unmoving Collar +1", --10
        })

     sets.precast.JA['Vallation'] = set_combine(sets.Enmity, {
		  body="Runeist Coat +3", 
		  })

     sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
     sets.precast.JA['Pflug'] = set_combine(sets.Enmity, {feet="Runeist Bottes +1"})
     sets.precast.JA['Battuta'] = set_combine(sets.Enmity, {head="Fu. Bandeau +3"})
     sets.precast.JA['Liement'] = set_combine(sets.Enmity, {body="Futhark Coat +3"})

     sets.precast.JA['Lunge'] = sets.Enmity

     sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']
     sets.precast.JA['Gambit'] = set_combine(sets.Enmity, {hands="Runeist Mitons +3"})
     sets.precast.JA['Rayke'] = set_combine(sets.Enmity, {feet="Futhark Boots +1"})
     sets.precast.JA['Elemental Sforzo'] = set_combine(sets.Enmity, {body="Futhark Coat +3"})
     sets.precast.JA['Swordplay'] = set_combine(sets.Enmity, {hands="Futhark Mitons +3"})

     sets.precast.JA['Vivacious Pulse'] = set_combine(sets.Enmity, {
		  head="Erilaz Galea +3",  
		  })

     sets.precast.JA['One For All'] = set_combine(sets.Enmity,{})
     sets.precast.JA['Provoke'] = sets.Enmity
	 sets.precast.JA['Warcry'] = sets.Enmity
	 
	 
    -- Fast cast sets for spells

     sets.precast.FC = {
          ammo="Sapience Orb",--2
		  head={name="Rune. Bandeau +3", priority = 13}, --14
		  body={name="Erilaz Surcoat +3", priority = 6}, --133
		  hands={name="Nyame Gauntlets", priority = 7}, 
          legs={name="Nyame Flanchard", priority = 11}, 
		  feet={name="Carmine Greaves +1", priority = 8},--8	
          neck="Voltsurge Torque",  --4
		  waist={name="Plat. Mog. Belt", priority = 15}, --10%
		  left_ear={name="Tuisto Earring", priority = 12},
		  right_ear={name="Odnowa Earring +1", priority = 10}, 
		  left_ring="Defending Ring", 
		  right_ring="Kishar Ring", --4
          back={name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}, priority =9}, --10
          } -- 52

     sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
          legs={name="Futhark Trousers +3", priority = 5},
          --waist="Siegel Sash",
          })

     sets.precast.FC.Cure = set_combine(sets.precast.FC, {
		  --ammo="Impatiens", 
		  --ear2="Mendi. Earring"
		  })

     sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
          --ammo="Impatiens",
          --body="Passion Jacket",
		  --ear2="Halasz Earring",
          --neck="Magoraga Beads",
          --waist="Ninurta's Sash",
          })



    ------------------------------------------------------------------------------------------------

    ------------------------------------- Weapon Skill Sets ----------------------------------------

    ------------------------------------------------------------------------------------------------

     sets.precast.WS = {
          ammo="Knobkierrie",
		  head={name="Nyame Helm", priority = 9}, --91
		  body={name="Nyame Mail", priority = 10}, --136
		  hands={name="Nyame Gauntlets", priority = 8}, --91
          legs={name="Nyame Flanchard", priority = 12}, --114
		  feet={name="Nyame Sollerets", priority = 7}, --68
          neck="Fotia Gorget",
		  waist={name="Plat. Mog. Belt", priority = 15}, --10%
		  left_ear={name="Tuisto Earring", priority = 13}, --150
		  right_ear={name="Odnowa Earring +1", priority = 11}, --110
		  left_ring={name="Gelatinous Ring +1", priority = 14},
		  right_ring="Regal Ring",
	      back=gear.RUNcape_WS2,	 
          }

     sets.precast.WS.DD = set_combine(sets.precast.WS, {
		  ammo="Knobkierrie",
		  left_ear="Moonshade Earring", 
		  right_ear="Sherida Earring",
		  left_ring="Epaminondas's Ring",
		  right_ring="Regal Ring",
          })



-- for when attack uncapped -----------------------------------------------------------

    sets.precast.WS.Uncapped = set_combine(sets.precast.WS, {

        })

    sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {
		  -- 1171 --
		  ammo="Voluspa Tathlum",
		  back=gear.RUNcape_WS1,	
		  })
		  
		  
     sets.precast.WS['Resolution'].DD = set_combine(sets.precast.WS.DD, {
		  ammo="Voluspa Tathlum",
		  back=gear.RUNcape_WS1,	
		  left_ring="Niqmaddu Ring",
		  })



    sets.precast.WS['Resolution'].Uncapped = set_combine(sets.precast.WS['Resolution'], {

        })


     sets.precast.WS['Dimidiation'] = set_combine(sets.precast.WS,{
	      neck="Fotia Gorget",
          })
          
     sets.precast.WS['Dimidiation'].DD = set_combine(sets.precast.WS.DD, {
	      neck="Fotia Gorget",
          })



    sets.precast.WS['Dimidiation'].Uncapped = set_combine(sets.precast.WS['Dimidiation'], {

        })


    sets.precast.WS['Shockwave'] = sets.idle.DT



    sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS, {

        })



    sets.precast.WS['Fell Cleave'].DD = set_combine(sets.precast.WS.DD, {


        })



    sets.precast.WS['Steel Cyclone'] = sets.precast.WS['Fell Cleave']

    sets.precast.WS['Steel Cyclone'].DD = sets.precast.WS['Fell Cleave'].DD



    sets.precast.WS['Upheaval'] = sets.precast.WS

    sets.precast.WS['Upheaval'].DD = sets.precast.WS.DD

    sets.precast.WS['Full Break'] = sets.engaged
	
	sets.precast.WS['Armor Break'] = {
		ammo="Yamarang",
		head="Agwu's Cap",
		body="Erilaz Surcoat +3",
		hands="Agwu's Gages",
		legs="Agwu's Slops",
		feet="Agwu's Pigaches",
		neck="Erra Pendant",
		waist="Eschan Stone",
		left_ear="Crep. Earring",
		right_ear="Erilaz Earring +1",
		left_ring="Metamorph Ring +1",
		right_ring="Stikini Ring +1",
		back=gear.RUNcape_WS2,	
	
	}
	
	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS.DD, {
		neck="Fotia Gorget",
		back=gear.RUNcape_WS2,
		left_ring="Epaminondas's Ring",
	})



    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Midcast Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------



    sets.midcast.FastRecast = sets.precast.FC


		--said to need 102 for full 100% effect
     sets.midcast.SpellInterrupt = {
          ammo="Staunch Tathlum", --10
  	      head="Erilaz Galea +3", --20
		  body={name="Nyame Mail", priority = 12}, 
          hands={ name="Regal Gauntlets", priority = 11}, --10
          legs="Carmine Cuisses +1", --20
          feet={ name="Taeon Boots", augments={'DEF+19','Spell interruption rate down -10%','HP+40',}},
          neck="Moonbeam Necklace", --10
		  waist="Audumbla Sash", --10
		  left_ear={name="Tuisto Earring", priority = 14},
		  right_ear={name="Odnowa Earring +1", priority = 13}, 
		  left_ring="Defending Ring",
		  right_ring={name="Gelatinous Ring +1", priority = 15},
		  back={name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Spell interruption rate down-10%',}, priority = 12}, --10
          } --100 + (1merits = +2) = 102

     sets.midcast.Cure = {
          }



     sets.midcast['Enhancing Magic'] = {
		 ammo="Staunch Tathlum",
		 head="Erilaz Galea +3",
		 body="Nyame Mail",
		 --hands="Runeist's Mitons +3",
		 hands="Nyame Gauntlets",
		 legs={name="Futhark Trousers +3", priority = 13},
		 feet="Nyame Sollerets",
		 neck="Incanter's Torque",
		 --waist="Olympus Sash",
		 waist={name="Plat. Mog. Belt", priority = 16}, --10%
		 left_ear="Tuisto Earring",
		 right_ear="Mimir Earring",
		 left_ring="Defending Ring",
		 right_ring={name="Gelatinous Ring +1", priority = 14},
		 back={name="Moonbeam Cape", priority = 15},
		 }

     sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'], {
          head="Erilaz Galea +3",
		  --hands={name="Regal Gauntlets", priority = 15},
          legs="Futhark Trousers +3",
          })

     sets.midcast['Phalanx'] = set_combine(sets.midcast['Enhancing Magic'], {
		  --main="Deacon Sword",
		  --sub="Chanter's Shield",
		  head="Fu. Bandeau +3",
		  --body=gear.Herculean.Body_PHLX,
		  --hands=gear.Herculean.Hands_PHLX,
		  --hands={name="Regal Gauntlets", priority = 15},
		  --legs=gear.Taeon.Legs_PHLX,
		  --feet=gear.Taeon.Feet_PHLX,
		  })

    sets.midcast['Aquaveil'] = sets.midcast.SpellInterrupt

     sets.midcast['Regen'] = set_combine(sets.midcast.EnhancingDuration, {
		  head="Rune. Bandeau +3",
		  neck="Sacro Gorget",
		  right_ear="Erilaz Earring +1",
		  waist="Sroda Belt",
		  })
		  
     sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
		  head="Erilaz Galea +3",
		  hands="Regal Gauntlets",
		  legs="Futhark Trousers +3",
		  waist="Gishdubar Sash"
		  })

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {waist="Siegel Sash"})

    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {
	
	})

    sets.midcast.Shell = sets.midcast.Protect



     sets.midcast['Divine Magic'] = {
          legs="Rune. Trousers +1",
          neck="Incanter's Torque",
          --waist="Bishop's Sash",
          }

    sets.midcast['Flash'] = sets.Enmity

    sets.midcast['Foil'] = sets.Enmity

    sets.midcast['Stun'] = sets.Enmity

    sets.midcast.Utsusemi = sets.idle

    sets.midcast['Blue Magic'] = sets.Enmity

    sets.midcast['Blue Magic'].Enmity = sets.Enmity

    sets.midcast['Blue Magic'].Cure = sets.Enmity

    sets.midcast['Blue Magic'].Buff = sets.Enmity
	
	sets.midcast['Cocoon'] = sets.idle -- used to be spell interrupted set and of these idle...
	
	sets.midcast['Geist Wall'] = sets.Enmity
	
	sets.midcast['Jettatura'] = sets.Enmity
	
	sets.midcast['Blank Gaze'] = sets.Enmity
	
	sets.midcast['Soporific'] = sets.Enmity
	
	sets.midcast['Sheep Song'] = sets.midcast.SpellInterrupt
	
	sets.midcast['Healing Breeze'] = sets.midcast.SpellInterrupt

    ------------------------------------------------------------------------------------------------

    ----------------------------------------- Idle Sets --------------------------------------------

    ------------------------------------------------------------------------------------------------


-- the comments reperestn hp/???/???
     sets.idle = {
          ammo="Staunch Tathlum", --0
		  head={name="Nyame Helm", priority = 9}, --91
		  body={name="Runeist Coat +3", priority = 14}, --218	
		  hands={name="Nyame Gauntlets", priority = 10}, --91
		  legs={name="Nyame Flanchard", priority = 13}, --114
		  feet={name="Nyame Sollerets", priority = 8}, --68
		  neck="Loricate Torque +1", --0
		  waist={name="Plat. Mog. Belt", priority = 15}, --10%
		  left_ear={name="Tuisto Earring", priority = 13}, --150
		  right_ear={name="Odnowa Earring +1", priority = 11}, --110
		  left_ring="Defending Ring", --0
		  right_ring="Shneddick Ring", --0
		  back={name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Evasion+10','Enmity+10','DEF+50',}, priority = 8}, --60    
          }

     sets.idle.DT = {
          ammo="Staunch Tathlum", --0
		  head={name="Nyame Helm", priority = 10}, --91
		  body={name="Nyame Mail", priority = 11}, --136
		  hands={name="Nyame Gauntlets", priority = 9}, --91
          legs={name="Nyame Flanchard", priority = 13}, --114
		  feet={name="Nyame Sollerets", priority = 8}, --68
		  neck="Loricate Torque +1", --0
		  waist="Engraved Belt", --0
		  left_ear={name="Tuisto Earring", priority = 14}, --150
		  right_ear={name="Odnowa Earring +1", priority = 12}, --110
		  left_ring="Defending Ring", --0
		  right_ring="Shneddick Ring", --0
		  back={name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Evasion+10','Enmity+10','DEF+50',}, priority = 7}, --60  
          }

    sets.idle.Enm = {
          ammo="Staunch Tathlum", --2/2
		  head={name="Nyame Helm", priority = 10}, --91
		  body={name="Erilaz Surcoat +3", priority = 15}, --133
		  hands={name="Nyame Gauntlets", priority = 11}, --91
          legs={name="Eri. Leg Guards +3", priority = 12}, --100
		  feet={name="Erilaz Greaves +3", priority = 9}, --48
		  neck="Loricate Torque +1", --0
		  waist="Engraved Belt", --0
		  left_ear={name="Tuisto Earring", priority = 14}, --150
		  right_ear={name="Odnowa Earring +1", priority = 12}, --110
		  left_ring="Defending Ring", --0
		  right_ring="Shneddick Ring", --0
		  back={name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Evasion+10','Enmity+10','DEF+50',}, priority = 8}, --60  
        }

    sets.idle.Regen = {
          ammo="Staunch Tathlum", --2/2
		  head={name="Turms Cap", priority = 11}, --3/3 
		  body={name="Futhark Coat +3", priority = 16}, --7/0		  
          hands={name="Regal Gauntlets", priority = 15},
          legs={name="Nyame Flanchard", priority = 13}, --114
          feet={name="Turms Leggings", priority = 10},
		  neck="Loricate Torque +1", --0
		  waist="Engraved Belt", --0
		  left_ear={name="Tuisto Earring", priority = 14}, --150
		  right_ear={name="Odnowa Earring +1", priority = 12}, --110
		  left_ring="Defending Ring", --0
		  right_ring="Shneddick Ring", --0
		  back={name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Evasion+10','Enmity+10','DEF+50',}, priority = 8}, --60  
        }



    sets.idle.Town = set_combine(sets.idle, {
		head="Shaded Specs.",
		body="Goldsmith's Apron",
		neck="Goldsm. Torque",
		left_ring="Craftmaster's Ring",
        })

	sets.idle.Weak = sets.idle.DT

    sets.Kiting = {}





    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Defense Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------



     sets.defense.Knockback = {
		--back="Repulse Mantle"
		}



     sets.defense.PDT = sets.idle.DT 

     sets.defense.MDT = sets.idle.DT 


     sets.defense.HP = {
          ammo="Staunch Tathlum", --2/2
		  head="Fu. Bandeau +3", --3/3
		  body="Runeist Coat +3", 
          hands="Regal Gauntlets",
          legs="Eri. Leg Guards +2",
          feet="Turms Leggings", 
		  neck="Loricate Torque +1",
		  waist="Plat. Mog. Belt",
		  left_ear="Mimir Earring",
		  right_ear="Odnowa Earring +1",
		  left_ring="Defending Ring",
		  right_ring="Moonbeam Ring",
		  back=gear.RUNcape_TANK,  
          }



    sets.defense.Parry = {

        hands="Turms Mittens",

        legs="Eri. Leg Guards +2",

        feet="Turms Leggings",

        }



    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Engaged Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------


     sets.engaged = {          
          ammo="Yamarang", --0
		  head={name="Nyame Helm", priority = 10}, --91
		  body={name="Runeist Coat +3", priority = 15}, --218
		  hands={name="Nyame Gauntlets", priority = 11}, --91
          legs={name="Eri. Leg Guards +3", priority = 12}, --100
		  feet={name="Erilaz Greaves +3", priority = 9}, --48
		  neck="Loricate Torque +1", --0
		  waist="Plat. Mog. Belt",
		  left_ear={name="Tuisto Earring", priority = 14}, --150
		  right_ear={name="Odnowa Earring +1", priority = 12}, --110
		  left_ring="Defending Ring", --0
		  right_ring="Regal Ring", --0
		  back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}, priority = 8}, --60    
          }

    sets.engaged.Aftermath = set_combine(sets.engaged, {

        })





    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Hybrid Sets -------------------------------------------

    ------------------------------------------------------------------------------------------------



    sets.Hybrid = {
          ammo="Yamarang", --2/2
		  head="Nyame Helm",
		  body=gear.Herculean.Body_ACC,
		  hands="Adhemar Wristbands +1",
		  --legs=gear.Herculean.Legs_ACCstp, need to change this
		  feet=gear.Herculean.Feet_TRPLacc,
		  neck="Loricate Torque +1", 
		  waist="Ioskeha Belt +1",
		  left_ear="Telos Earring", 
		  right_ear="Sherida Earring",
		  left_ring="Defending Ring",
		  right_ring="Chirich Ring +1",
		  back=gear.RUNcape_STP,  
        }

	sets.engaged.DD = set_combine(sets.engaged, sets.Hybrid)


    sets.engaged.Aftermath.DD = set_combine(sets.engaged, sets.Hybrid)



    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Special Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------


     sets.buff.Doom = {
		ring1="Purity Ring", 
		--ring2="Saida Ring", 
		waist="Gishdubar Sash"
	 }

    sets.Embolden = set_combine(sets.midcast.EnhancingDuration, {back="Evasionist's Cape"})

    sets.Obi = {waist="Hachirin-no-Obi"}

    sets.Epeolatry = {main="Epeolatry", sub="Utu Grip"}
	
	sets.Epeolatry_EMN = {main="Epeolatry", sub="Alber Strap"}

    sets.Lionheart = {main="Lionheart", sub="Utu Grip"}

    sets.Aettir = {main="Aettir", sub="Utu Grip"}

    sets.Lycurgos = {main="Lycurgos", sub="Utu Grip"}
	
	sets.Naegling = {main="Naegling", sub=""}



end



-------------------------------------------------------------------------------------------------------------------

-- Job-specific hooks for standard casting events.

-------------------------------------------------------------------------------------------------------------------



function job_precast(spell, action, spellMap, eventArgs)

    equip(sets[state.WeaponSet.current])



    if buffactive['terror'] or buffactive['petrification'] or buffactive['stun'] or buffactive['sleep'] then

        add_to_chat(167, 'Stopped due to status.')

        eventArgs.cancel = true

        return

    end

    if state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.current == 'HP' then

        currentSpell = spell.english

        eventArgs.handled = true

        if spell.action_type == 'Magic' then

            equip(sets.precast.FC.HP)

        elseif spell.action_type == 'Ability' then

            equip(sets.Enmity.HP)

            equip(sets.precast.JA[currentSpell])

        end

    else

        if spell.action_type == 'Ability' then

            equip(sets.Enmity)

            equip(sets.precast.JA[spell])

        end

    end

    if spell.english == 'Lunge' then

        local abil_recasts = windower.ffxi.get_ability_recasts()

        if abil_recasts[spell.recast_id] > 0 then

            send_command('input /jobability "Swipe" <t>')

--            add_to_chat(122, '***Lunge Aborted: Timer on Cooldown -- Downgrading to Swipe.***')

            eventArgs.cancel = true

            return

        end

    end

    if spell.english == 'Valiance' then

        local abil_recasts = windower.ffxi.get_ability_recasts()

        if abil_recasts[spell.recast_id] > 0 then

            send_command('input /jobability "Vallation" <me>')

            eventArgs.cancel = true

            return

        elseif spell.english == 'Valiance' and buffactive['vallation'] then

            cast_delay(0.2)

            send_command('cancel Vallation') -- command requires 'cancel' add-on to work

        end

    end

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



function job_midcast(spell, action, spellMap, eventArgs)

	if state.CastingMode.value == 'Tank' then 
	
	eventArgs.handled = true
			
	if spell.action_type == 'Magic' then
            
			if spell.english == 'Flash' or spell.english == 'Foil' or spell.english == 'Stun'

                or blue_magic_maps.Enmity:contains(spell.english) then
	
		equip(sets.idle.DT)
		
			end 
		
		end 
	
	end 
		
    if state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.current == 'HP' and spell.english ~= "Phalanx" then

        eventArgs.handled = true

        if spell.action_type == 'Magic' then
            
			if spell.english == 'Flash' or spell.english == 'Foil' or spell.english == 'Stun'

                or blue_magic_maps.Enmity:contains(spell.english) then

                equip(sets.Enmity.HP)

            elseif spell.skill == 'Enhancing Magic' then

                equip(sets.midcast.EnhancingDuration)

            end

        end

    end

end



-- Run after the default midcast() is done.

-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.

function job_post_midcast(spell, action, spellMap, eventArgs)

    if spell.english == 'Lunge' or spell.english == 'Swipe' then

        if (spell.element == world.day_element or spell.element == world.weather_element) then

            equip(sets.Obi)

        end

    end

    if state.DefenseMode.value == 'None' then

        if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then

            equip(sets.midcast.EnhancingDuration)

            if spellMap == 'Refresh' then

                equip(sets.midcast.Refresh)

            end

        end

        if spell.english == 'Phalanx' and buffactive['Embolden'] then

            equip(sets.midcast.EnhancingDuration)

        end

    end

end



function job_aftercast(spell, action, spellMap, eventArgs)

    equip(sets[state.WeaponSet.current])



    if spell.name == 'Rayke' and not spell.interrupted then

        send_command('@timers c "Rayke ['..spell.target.name..']" '..rayke_duration..' down spells/00136.png')

        send_command('wait '..rayke_duration..';input /echo [Rayke just wore off!];')

    elseif spell.name == 'Gambit' and not spell.interrupted then

        send_command('@timers c "Gambit ['..spell.target.name..']" '..gambit_duration..' down spells/00136.png')

        send_command('wait '..gambit_duration..';input /echo [Gambit just wore off!];')

    end

end



-------------------------------------------------------------------------------------------------------------------

-- Job-specific hooks for non-casting events.

-------------------------------------------------------------------------------------------------------------------



-- Called when the player's status changes.

function job_state_change(field, new_value, old_value)

    classes.CustomDefenseGroups:clear()

    classes.CustomDefenseGroups:append(state.Charm.current)

    classes.CustomDefenseGroups:append(state.Knockback.current)

    classes.CustomDefenseGroups:append(state.Death.current)



    classes.CustomMeleeGroups:clear()

    classes.CustomMeleeGroups:append(state.Charm.current)

    classes.CustomMeleeGroups:append(state.Knockback.current)

    classes.CustomMeleeGroups:append(state.Death.current)

end



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



    if buff == "terror" then

        if gain then

            equip(sets.defense.PDT)

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



    if buff == 'Embolden' then

        if gain then

            equip(sets.Embolden)

            disable('head','legs','back')

        else

            enable('head','legs','back')

            status_change(player.status)

        end

    end



    if buff:startswith('Aftermath') then

        state.Buff.Aftermath = gain

        customize_melee_set()

        handle_equipping_gear(player.status)

    end



    if buff == 'Battuta' and not gain then

        status_change(player.status)

    end



end



-- Handle notifications of general user state change.

function job_state_change(stateField, newValue, oldValue)

    if state.WeaponLock.value == true then

        disable('main','sub')

    else

        enable('main','sub')

    end



    equip(sets[state.WeaponSet.current])



end



-------------------------------------------------------------------------------------------------------------------

-- User code that supplements standard library decisions.

-------------------------------------------------------------------------------------------------------------------



function job_handle_equipping_gear(playerStatus, eventArgs)

    check_gear()

    --check_moving()

end



function job_update(cmdParams, eventArgs)

    equip(sets[state.WeaponSet.current])

    handle_equipping_gear(player.status)

end



-- Modify the default idle set after it was constructed.

function customize_idle_set(idleSet)

    --[[if player.mpp < 51 then

        idleSet = set_combine(idleSet, sets.latent_refresh)

    end]]

    if state.Knockback.value == true then

        idleSet = set_combine(idleSet, sets.defense.Knockback)

    end

    --if state.CP.current == 'on' then

    --    equip(sets.CP)

    --    disable('back')

    --else

    --    enable('back')

    --end

    if state.Auto_Kite.value == true then

       idleSet = set_combine(idleSet, sets.Kiting)

    end



    return idleSet

end



-- Modify the default melee set after it was constructed.

function customize_melee_set(meleeSet)

    if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Epeolatry"

        and state.DefenseMode.value == 'None' then

        if state.HybridMode.value == "DT" then

            meleeSet = set_combine(meleeSet, sets.engaged.Aftermath.DT)

        else

            meleeSet = set_combine(meleeSet, sets.engaged.Aftermath)

        end

    end

    if state.Knockback.value == true then

        meleeSet = set_combine(meleeSet, sets.defense.Knockback)

    end



    return meleeSet

end



function customize_defense_set(defenseSet)

    if buffactive['Battuta'] then

        defenseSet = set_combine(defenseSet, sets.defense.Parry)

    end

    if state.Knockback.value == true then

        defenseSet = set_combine(defenseSet, sets.defense.Knockback)

    end



    return defenseSet

end



-- Function to display the current relevant user state when doing an update.

-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.

function display_current_job_state(eventArgs)

    local r_msg = state.Runes.current

    local r_color = ''

    if state.Runes.current == 'Ignis' then r_color = 167

    elseif state.Runes.current == 'Gelus' then r_color = 210

    elseif state.Runes.current == 'Flabra' then r_color = 204

    elseif state.Runes.current == 'Tellus' then r_color = 050

    elseif state.Runes.current == 'Sulpor' then r_color = 215

    elseif state.Runes.current == 'Unda' then r_color = 207

    elseif state.Runes.current == 'Lux' then r_color = 001

    elseif state.Runes.current == 'Tenebrae' then r_color = 160 end



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

    if state.Knockback.value == true then

        msg = msg .. ' Knockback Resist |'

    end

    if state.Kiting.value then

        msg = msg .. ' Kiting: On |'

    end



    add_to_chat(r_color, string.char(129,121).. '  ' ..string.upper(r_msg).. '  ' ..string.char(129,122)

        ..string.char(31,210).. ' Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002).. ' |'

        ..string.char(31,207).. ' WS' ..am_msg.. ': ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'

        ..string.char(31,060)

        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002).. ' |'

        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002).. ' |'

        ..string.char(31,002)..msg)



    eventArgs.handled = true

end



-------------------------------------------------------------------------------------------------------------------

-- General hooks for other events.

-------------------------------------------------------------------------------------------------------------------

function job_get_spell_map(spell, default_spell_map)

    if spell.skill == 'Blue Magic' then

        for category,spell_list in pairs(blue_magic_maps) do

            if spell_list:contains(spell.english) then

                return category

            end

        end

    end

end



-------------------------------------------------------------------------------------------------------------------

-- User code that supplements self-commands.

-------------------------------------------------------------------------------------------------------------------



function get_custom_wsmode(spell, action, spellMap)

    if spell.type == 'WeaponSkill' then

        if state.AttackMode.value == 'Uncapped' and state.DefenseMode.value == 'None' and state.HybridMode.value == 'Normal' then

            return "Uncapped"

        elseif state.DefenseMode.value ~= 'None' or state.HybridMode.value == 'DT' then

            return "Safe"

        end

    end

end



-------------------------------------------------------------------------------------------------------------------

-- Utility functions specific to this job.

-------------------------------------------------------------------------------------------------------------------



function job_self_command(cmdParams, eventArgs)

    gearinfo(cmdParams, eventArgs)

    if cmdParams[1]:lower() == 'rune' then

        send_command('@input /ja '..state.Runes.value..' <me>')

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

    if player.sub_job == 'BLU' then

        set_macro_page(1, 11)

    elseif player.sub_job == 'DRK' then

        set_macro_page(1, 11)

    elseif player.sub_job == 'WHM' then

        set_macro_page(1, 11)

    else

        set_macro_page(1, 11)

    end

end



function set_lockstyle()

    send_command('wait 8; input /lockstyleset ' .. lockstyleset)

end