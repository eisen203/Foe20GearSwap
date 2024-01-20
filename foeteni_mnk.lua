
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

end



-- Setup vars that are user-independent.

function job_setup()
    state.Buff.Aftermath = buffactive.Aftermath or false
    --state.Buff.['Hundred Fists'] = buffactive['Hundred Fists'] or false
	state.Buff['Impetus'] = buffactive['Impetus'] or false
	state.Buff['Doom'] = buffactive['Doom'] or false
	state.Buff['Curse'] = buffactive['Curse'] or false


    include('Mote-TreasureHunter')



    -- For th_action_check():

    -- JA IDs for actions that always have TH: Provoke, Animated Flourish

    info.default_ja_ids = S{35, 204}

    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish

    info.default_u_ja_ids = S{201, 202, 203, 205, 207}



    lockstyleset = 1



end



-------------------------------------------------------------------------------------------------------------------

-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.

-------------------------------------------------------------------------------------------------------------------



function user_setup()

    state.OffenseMode:options('Normal', 'Counter', 'STP', 'Crit')

    state.WeaponskillMode:options('Normal', 'Counter', 'PDL')

    state.HybridMode:options('Normal', 'DT')

    state.IdleMode:options('Normal', 'DT')
	
	state.WeaponLock = M(false, 'Weapon Lock')

	state.WeaponSet = M{['description']='Weapon Set', 'Godhands', 'Spharai', 'Staff', 'Vere'}
	
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
    state.AutoWSList = M{['description']='Auto WS List', 'OFF', 'Omen', 'Howling', 'Victory', '3step1', '4step1', '4step2'}
	send_command('bind @x gs c cycle AutoWSList')

	include('organizer-lib')
    -- Additional local binds


    select_default_macro_book()

    set_lockstyle()

end



function user_unload()
    send_command('unbind @z')

    send_command('unbind @x')		

    send_command('unbind ^`')

    send_command('unbind @c')

    send_command('unbind ^numpad/')

    send_command('unbind ^numpad*')

    send_command('unbind ^numpad-')

    send_command('unbind ^numpad7')

    send_command('unbind ^numpad8')

    send_command('unbind ^numpad5')

    send_command('unbind ^numpad1')

    send_command('unbind ^numpad2')

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



    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Precast Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------
	sets.precast.JA['Focus'] = set_combine(sets.Enmity, {head="Anchor. Crown +1"})
	sets.precast.JA['Dodge'] = set_combine(sets.Enmity, {feet="Anch. Gaiters +3"})
	sets.precast.JA['Chakra'] = set_combine(sets.Enmity, {body="Anch. Cyclas +3", hands="Hes. Gloves +3"})
	sets.precast.JA['Boost'] = set_combine(sets.Enmity, {hands="Anch. Gloves +1", waist="Ask Sash"})
	sets.precast.JA['Chi Blast'] = set_combine(sets.Enmity, {
		head="Hes. Crown +3",
		--body=gear.Herculean.Body_TH,
		--hands=gear.Herculean.Hands_TH,
		--waist="Chaac Belt",
		})
	sets.precast.JA['Mantra'] = set_combine(sets.Enmity, {feet="Hes. Gaiters +3",})
	sets.precast.JA['Hundred Fists'] = set_combine(sets.Enmity, {legs="Hes. Hose +1",})
	sets.precast.JA['Formless Strikes'] = set_combine(sets.Enmity, {body="Hes. Cyclas +3",})
	sets.precast.JA['Footwork'] = set_combine(sets.Enmity, {feet="Bhikku Gaiters +3",})
	

    -- Fast cast sets for spells

    sets.precast.FC = {
		ammo="Sapience Orb",
        head=gear.Herculean.Head_FC, --12
        body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}}, --10
        hands="Leyline Gloves", --8
		neck="Voltsurge Torque", --4
		left_ear="Etiolation Earring", --1
		right_ear="Loquac. Earring", --2
		left_ring="Kishar Ring", --4
		right_ring="Prolix Ring", --5
        }
		
     sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
          --ammo="Impatiens",
          --body="Passion Jacket",
		  --ear2="Halasz Earring",
          neck="Magoraga Beads",
          --waist="Ninurta's Sash",
          })

    sets.Enmity = {
		ammo="Sapience Orb",
		--head="Halitus Helm",
		--body="Emet Harness +1",
		--hands="Kurys Gloves",
		--legs="Obatala Subligar",
		--neck="Unmoving Collar +1",
		--left_ear="Friomisi Earring",
		--right_ear="Cryptic Earring",
		--left_ring="Supershear Ring",
		--right_ring="Eihwaz Ring",
		back="Reiki Cloak",
          }

    sets.precast.JA['Provoke'] = sets.Enmity
    sets.precast.JA['Warcry'] = sets.Enmity


    ------------------------------------------------------------------------------------------------

    ------------------------------------- Weapon Skill Sets ----------------------------------------

    ------------------------------------------------------------------------------------------------


-- general STR based ws
sets.precast.WS = {
    ammo="Coiste Bodhar",
    head="Mpaca's Cap",
	body="Nyame Mail",
	hands="Nyame Gauntlets",
	legs="Nyame Flanchard",
	--legs="Mpaca's Hose",
	feet="Ken. Sune-Ate +1",
	--feet="Nyame Sollerets",
    neck="Mnk. Nodowa +2",
    waist="Moonbow Belt +1",
    left_ear="Moonshade Earring",
    right_ear="Schere Earring", 
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
	--right_ring="Ephramad's Ring",
    back=gear.MNKcape_dblAtkSTR,
        } -- default set
	
sets.precast.WS.Counter = set_combine(sets.precast.WS, {
	ammo="Amar Cluster", --2
	body="Mpaca's Doublet", --10
	neck="Bathy Choker +1", --10
	right_ear="Bhikku Earring +1", --7
	back=gear.MNKcape_STP, --10
})	

sets.precast.WS.DT = set_combine(sets.precast.WS, {
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
})	

sets.precast.WS.PDL = set_combine(sets.precast.WS, {
    body="Ken. Samue +1",
    hands="Tatena. Gote +1",
    legs="Mpaca's Hose",
    feet="Ken. Sune-Ate +1",
})	
	
sets.precast.WS['Victory Smite'] = set_combine(sets.precast.WS, {
	ammo="Voluspa Tathlum",
	body="Mpaca's Doublet",
	hands="Ryuo Tekko +1",
	hands="Mpaca's Gloves",
	legs="Mpaca's Hose",
	feet="Mpaca's Boots",
	left_ear="Odr Earring",
})

sets.precast.WS['Victory Smite'].Counter = set_combine(sets.precast.WS['Victory Smite'], {
	ammo="Amar Cluster", --2
	body="Mpaca's Doublet", --10
	neck="Bathy Choker +1", --10
	right_ear="Bhikku Earring +1", --7
	back=gear.MNKcape_STP, --10
})
	
sets.precast.WS['Victory Smite'].DT = set_combine(sets.precast.WS['Victory Smite'], {
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
})

sets.precast.WS['Victory Smite'].PDL = set_combine(sets.precast.WS['Victory Smite'], {

})

sets.precast.WS['Ascetic\'s Fury'] = set_combine(sets.precast.WS['Victory Smite'], {})

sets.precast.WS['Ascetic\'s Fury'].Uncapped = set_combine(sets.precast.WS['Ascetic\'s Fury'], {})

sets.precast.WS['Dragon Kick'] = set_combine(sets.precast.WS, {
	neck="Mnk. Nodowa +2",
	feet="Anch. Gaiters +3",
	--feet="Bhikku Gaiters +3",
})

sets.precast.WS['Dragon Kick'].Counter = set_combine(sets.precast.WS['Dragon Kick'], {
	ammo="Amar Cluster", --2
	neck="Bathy Choker +1", --10
	right_ear="Bhikku Earring +1", --7
	back=gear.MNKcape_STP, --10
})

sets.precast.WS['Dragon Kick'].DT = set_combine(sets.precast.WS['Dragon Kick'], {
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
})

sets.precast.WS['Dragon Kick'].PDL = set_combine(sets.precast.WS['Dragon Kick'], {
    body="Ken. Samue +1",
    hands="Tatena. Gote +1",
    legs="Mpaca's Hose",
})


sets.precast.WS['Tornado Kick'] = set_combine(sets.precast.WS, {
	neck="Mnk. Nodowa +2",
	feet="Anch. Gaiters +3",
	--feet="Bhikku Gaiters +3",
})

sets.precast.WS['Tornado Kick'].Counter = set_combine(sets.precast.WS['Tornado Kick'], {
	ammo="Amar Cluster", --2
	neck="Bathy Choker +1", --10
	right_ear="Bhikku Earring +1", --7
	back=gear.MNKcape_STP, --10
})

sets.precast.WS['Tornado Kick'].DT = set_combine(sets.precast.WS['Tornado Kick'], {
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
})

sets.precast.WS['Tornado Kick'].PDL = set_combine(sets.precast.WS['Tornado Kick'], {
    body="Ken. Samue +1",
    hands="Tatena. Gote +1",
    legs="Mpaca's Hose",
})
-- ----------- VIT based WS --

sets.precast.WS['Howling Fist'] = set_combine(sets.precast.WS, {
    --back=gear.MNKcape_dblAtkVIT,
})

sets.precast.WS['Howling Fist'].Counter = set_combine(sets.precast.WS['Howling Fist'], {
	ammo="Amar Cluster", --2
	--body="Mpaca's Doublet", --10
	neck="Bathy Choker +1", --10
	right_ear="Bhikku Earring +1", --7
	back=gear.MNKcape_STP, --10
})

sets.precast.WS['Howling Fist'].DT = set_combine(sets.precast.WS['Howling Fist'], {
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
})

sets.precast.WS['Howling Fist'].PDL = set_combine(sets.precast.WS['Howling Fist'], {
    body="Ken. Samue +1",
    hands="Tatena. Gote +1",
    legs="Mpaca's Hose",
    feet="Ken. Sune-Ate +1",
})

sets.precast.WS['Raging Fist'] = set_combine(sets.precast.WS, {
	hands="Mpaca's Gloves",
})

sets.precast.WS['Raging Fist'].Counter = set_combine(sets.precast.WS['Raging Fist'], {
	ammo="Amar Cluster", --2
	body="Mpaca's Doublet", --10
	neck="Bathy Choker +1", --10
	right_ear="Bhikku Earring +1", --7
	back=gear.MNKcape_STP, --10
})

sets.precast.WS['Raging Fist'].DT = set_combine(sets.precast.WS['Raging Fist'], {
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
})

sets.precast.WS['Raging Fist'].PDL = set_combine(sets.precast.WS['Raging Fist'], {
    body="Ken. Samue +1",
    hands="Tatena. Gote +1",
    legs="Mpaca's Hose",
    feet="Ken. Sune-Ate +1",
})

sets.precast.WS['Final Heaven'] = set_combine(sets.precast.WS['Howling Fist'], {
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
	back=gear.MNKcape_WSDvit,
})

sets.precast.WS['Final Heaven'].Counter = set_combine(sets.precast.WS['Final Heaven'], {
	ammo="Amar Cluster", --2
	body="Mpaca's Doublet", --10
	neck="Bathy Choker +1", --10
	right_ear="Bhikku Earring +1", --7
	back=gear.MNKcape_STP, --10
})

sets.precast.WS['Final Heaven'].DT = set_combine(sets.precast.WS['Final Heaven'], {
})

sets.precast.WS['Final Heaven'].PDL = set_combine(sets.precast.WS['Final Heaven'], {
})

sets.precast.WS['Asuran Fists'] = {
    ammo="Knobkierrie",
    head="Bhikku Crown +3",
    body="Bhikku Cyclas +3",
    hands="Bhikku Gloves +3", 
    legs="Bhikku Hose +3",
    feet="Bhikku Gaiters +3",
    neck="Mnk. Nodowa +2",
    waist="Moonbow Belt +1",
    left_ear="Telos Earring",
    right_ear="Schere Earring",
    left_ring="Regal Ring",
    right_ring="Ephramad's Ring",
    back=gear.MNKcape_STP,
}

sets.precast.WS['Asuran Fists'].Counter = set_combine(sets.precast.WS['Asuran Fists'], {
	ammo="Amar Cluster", --2
	body="Mpaca's Doublet", --10
	neck="Bathy Choker +1", --10
	right_ear="Bhikku Earring +1", --7
	back=gear.MNKcape_STP, --10
})

sets.precast.WS['Asuran Fists'].DT = set_combine(sets.precast.WS['Asuran Fists'], {
	ammo="Amar Cluster", --2
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
})

sets.precast.WS['Asuran Fists'].PDL = set_combine(sets.precast.WS['Asuran Fists'], {
    body="Ken. Samue +1",
    hands="Tatena. Gote +1",
    legs="Mpaca's Hose",
    feet="Ken. Sune-Ate +1",
})

-- -------DEX based WS -------

sets.precast.WS['Shijin Spiral'] = set_combine(sets.precast.WS, {
	ammo="Voluspa Tathlum",
	--head="Ken. Jinpachi +1",
	--body="Ken. Samue +1",
    back=gear.MNKcape_dblAtkACC,
})

sets.precast.WS['Shijin Spiral'].Counter = set_combine(sets.precast.WS['Shijin Spiral'], {
	ammo="Amar Cluster", --2
	body="Mpaca's Doublet", --10
	neck="Bathy Choker +1", --10
	right_ear="Bhikku Earring +1", --7
	back=gear.MNKcape_STP, --10
})

sets.precast.WS['Shijin Spiral'].DT = set_combine(sets.precast.WS['Shijin Spiral'], {
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
})

sets.precast.WS['Shijin Spiral'].PDL = set_combine(sets.precast.WS['Shijin Spiral'], {
    body="Ken. Samue +1",
    hands="Tatena. Gote +1",
    legs="Mpaca's Hose",
    feet="Ken. Sune-Ate +1",
})

sets.precast.WS['Shell Crusher'] = set_combine(sets.precast.WS, {
	ammo="PemphredoTathlum",
    head="Bhikku Crown +3",
    body="Bhikku Cyclas +3",
    hands="Bhikku Gloves +3",
    legs="Bhikku Hose +3",
    feet="Bhikku Gaiters +3",
	neck="Sanctity Necklace",
	waist="Eschan Stone",
	left_ear="Digni. Earring",
	right_ear="Bhikku Earring +1",
	left_ring="Metamor. Ring +1",
	right_ring="Stikini Ring +1",
    back=gear.MNKcape_WSmagic,
})

--Magical WS

sets.precast.WS.Magic = { 
    ammo="Ghastly Tathlum +1",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Sibyl Scarf",
    waist="Orpheus's Sash",
    left_ear="Moonshade Earring",
    right_ear="Friomisi Earring",
    left_ring="Defending Ring",
    right_ring="Crepuscular Ring",
    back=gear.MNKcape_WSmagic,
}

sets.precast.WS['Cataclysm'] = set_combine(sets.precast.WS.Magic, {
	head="Pixie Hairpin +1",
	left_ring="Archon Ring",
})

sets.precast.WS['Earth Crusher'] = set_combine(sets.precast.WS.Magic, {

})

    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Midcast Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------
    sets.Enmity = {
		ammo="Sapience Orb",
		head="Halitus Helm",
		body="Emet Harness +1",
		legs="Obatala Subligar",
		neck="Unmoving Collar +1",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Supershear Ring",
		right_ring="Eihwaz Ring",
		back="Reiki Cloak",
          }

    sets.precast.JA['Provoke'] = sets.Enmity
    sets.precast.JA['Warcry'] = sets.Enmity
    ------------------------------------------------------------------------------------------------

    ----------------------------------------- Idle Sets --------------------------------------------

    ------------------------------------------------------------------------------------------------



sets.idle = {
    ammo="Staunch Tathlum",
	head="Nyame Helm",
	body="Nyame Mail",
	hands="Nyame Gauntlets",
	legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Bathy Choker +1",
    waist="Moonbow Belt +1",
    left_ear="Odnowa Earring +1",
    right_ear="Odnowa Earring",
    left_ring="Defending Ring",
    right_ring="Shneddick Ring",
	back=gear.MNKcape_dblAtkVIT,
}

sets.idle.DT = set_combine(sets.idle, {
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
		left_ring="Craftmaster's Ring",
	})



    sets.idle.Weak = sets.idle.DT





    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Defense Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------





    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Engaged Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------



sets.engaged = {
    ammo="Coiste Bodhar",
    head="Bhikku Crown +3",
	body="Mpaca's Doublet",
    hands="Tatena. Gote +1",
    legs="Bhikku Hose +3",
	feet="Tatena. Sune. +1",
    --feet="Anch. Gaiters +3",
    neck="Mnk. Nodowa +2",
    waist="Moonbow Belt +1",
    left_ear="Sherida Earring",
	--right_ear="Mache Earring +1",
	right_ear="Schere Earring", 
	left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
	back=gear.MNKcape_STP,
}

--27% from traits/merits/jobpoints, need 53 from gear (-14 from relic h2h)
sets.engaged.Counter = set_combine(sets.engaged, {
	ammo="Amar Cluster", --2
	body="Mpaca's Doublet", --10
	neck="Bathy Choker +1", --10
	right_ear="Bhikku Earring +1", --7
	back=gear.MNKcape_STP, --10
})

sets.engaged.STP = set_combine(sets.engaged, {
	head="Malignance Chapeau",
	--body="Tatena. Harama. +1", --8
	hands="Tatena. Gote +1", --6
	--legs="Tatena. Haidate +1", --6
	feet="Tatena. Sune. +1", --6
	})


sets.engaged.Crit = set_combine(sets.engaged, {
	head="Ken. Jinpachi +1",
    --body="Ken. Samue +1",
    hands="Adhemar Wrist. +1",
	feet="Ken. Sune-Ate +1",
})

    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Hybrid Sets -------------------------------------------

    ------------------------------------------------------------------------------------------------

sets.engaged.DT = {
    ammo="Coiste Bodhar",
	head="Bhikku Crown +3",
	body="Mpaca's Doublet", 
	hands="Nyame Gauntlets",
	legs="Bhikku Hose +3",
	feet="Nyame Sollerets",
    neck="Mnk. Nodowa +2",
    waist="Moonbow Belt +1", --6/6
	left_ear="Sherida Earring",
	right_ear="Schere Earring",
    --right_ear="Odnowa Earring +1", --3/3
	left_ring="Gere Ring",
    --left_ring="Defending Ring", --10/10
    right_ring="Niqmaddu Ring",
	back=gear.MNKcape_dblAtkACC,
	}
	
sets.engaged.Counter.DT = set_combine(sets.engaged.DT, {
	ammo="Amar Cluster", --2
	body="Mpaca's Doublet", --10
	neck="Bathy Choker +1", --10
	right_ear="Bhikku Earring +1", --7
	back=gear.MNKcape_STP, --10
})

sets.engaged.Crit.DT = set_combine(sets.engaged.DT, {
	hands="Mpaca's Gloves",
	feet="Mpaca's Boots",
	--left_ring="Defending Ring", --10/10
})

sets.engaged.STP.DT = set_combine(sets.engaged.DT, {
	--head="Malignance Chapeau",
	--body="Malignance Tabard", --9/9
	hands="Malignance Gloves", --5/5
	--legs="Malignance Tights", --7/7
	feet="Malignance Boots", --4/4
	back=gear.MNKcape_STP,
})


    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Special Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------



    sets.buff.Doom = {

        }


    sets.TreasureHunter = {
		body=gear.Herculean.Body_TH,
		hands=gear.Herculean.Hands_TH,
		waist="Chaac Belt",
	}

	sets.VS = {
		--ammo="Voluspa Tathlum",
		--head="Adhemar Bonnet +1",
		body="Bhikku Cyclas +3",
		--feet=gear.Herculean.Feet_CRITDMG,
	}

    sets.Impetus = {
		--head="Adhemar Bonnet +1",
		body="Bhikku Cyclas +3",
		--feet=gear.Herculean.Feet_CRITDMG,
	}
	
    sets.Boost = {
		waist="Ask Sash",
	}	

	sets.Spharai = {
		main = "Spharai",
	}	
	
	sets.Vere = {
		main = "Verethragna",
	}	
	
	sets.Godhands = {
		main="Godhands",
	}
	sets.Staff = {
		--main= "Malignance Pole",
		main="Xoanon",
		sub="Khonsu",
	}

	sets.maxTP = {
		left_ear="Sherida Earring",
		}


end



-------------------------------------------------------------------------------------------------------------------

-- Job-specific hooks for standard casting events.

-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Echo Drops" <me>')
		--[[
		elseif spell.type == "WeaponSkill" and spell.target.distance > 7 and player.status == 'Engaged' then -- Cancel WS If You Are Out Of Range --
		cancel_spell()
		add_to_chat(123, spell.name..' Canceled: [Out of Range]')
		return
		]]
    end
end

function job_precast(spell, action, spellMap, eventArgs)

	equip(sets[state.WeaponSet.current])

end

function job_post_precast(spell, action, spellMap, eventArgs)
	if buffactive['Impetus'] and spell.english == 'Victory Smite' then 
		equip(sets.VS)
		end
end

-- Job-specific hooks for standard casting events.
function job_midcast(spell, action, spellMap, eventArgs)
 
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
 
end

-------------------------------------------------------------------------------------------------------------------

-- Job-specific hooks for non-casting events.

-------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
---------------------------------------------------------------------

-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(status, eventArgs)
    update_combat_form()
    determine_haste_group()
end


-------------------------------------------------------------------------------------------------------------------

-- User code that supplements standard library decisions.

-------------------------------------------------------------------------------------------------------------------



-- Modify the default idle set after it was constructed.

function customize_idle_set(idleSet)

    return idleSet

end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	if state.Buff['Doom'] then
		meleeSet = set_combine(meleeSet, sets.Doom)
	end
    --[[if state.Buff['Hundred Fists'] then 
		meleeSet = set_combine(meleeSet, sets['Hundred Fists'])
    end]]
    --if state.Buff['Impetus'] and state.WeaponSet.value~='Spharai' then 
	if state.Buff['Impetus'] then 
		--add_to_chat(100,'> > > > Should swap to verethragna')
        --state.WeaponSet:set('Vere')
        meleeSet = set_combine(meleeSet, sets.Impetus)
    end
	return meleeSet
end


-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    end
    if buff == 'Boost' then
        if gain then
            equip(sets.Boost)
            disable('waist')
        else
            enable('waist')
        end
    end
    --[[if buff == "Impetus" then
        if gain then
        else
            --add_to_chat(100,'> > > > Should swap to godhands')
           state.WeaponSet:set('Godhands')
        end
    end]]
	if buff == "Doom" or buff == "Curse" then
		if gain then
			equip(sets.doom)
		else
			handle_equipping_gear(player.status)
		end
	end	
end

-------------------------------------------------------------------------------------------------------------------

-- User code that supplements self-commands.

-------------------------------------------------------------------------------------------------------------------


-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
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


-- Set eventArgs.handled to true if we don't want the automatic display to be run.
-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)

    if state.WeaponLock.value == true then

        disable('range', 'ammo')

    else

        enable('range', 'ammo')

    end

end

function update_melee_groups()

end



-- Select default macro book on initial load or subjob change.

function select_default_macro_book()

    -- Default macro set/book: (set, book)

    --if player.sub_job == 'SAM' then

        set_macro_page(6, 2)

    --else

        set_macro_page(6, 2)

    --end

end



function set_lockstyle()

    send_command('wait 8; input /lockstyleset 76')

end


