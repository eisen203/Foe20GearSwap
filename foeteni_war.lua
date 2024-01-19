--Great Sword Light
	--Ground Strike (Q) > Ground Strike (Q) > Scourge (R) > Resolution (MM)
	--Ground Strike (Q) > Ground Strike (Q) > Scourge (R) > Ground Strike (Q)
	--Resolution (MM) > Ground Strike (Q) > Scourge (R) > Resolution (MM) > Scourge (R)
    --Resolution (MM) > Ground Strike (Q) > Scourge (R) > Ground Strike (Q) > Scourge (R)
	--Power Slash > Resolution (MM) > Scourge (R) > Resolution (MM) > Scourge (R)
	--Power Slash > Resolution (MM) > Scourge (R) > Ground Strike (Q) > Scourge (R)
	--Ground Strike (Q) > Ground Strike (Q) > Scourge (R) > Resolution (MM) > Scourge (R)
	--Freezebite > Shockwave > Ground Strike (Q) > Scourge (R) > Resolution (MM) > Scourge (R)

--Great Axe Light
	--Raging Rush > Sturmwind > Upheaval (MM)
    --Raging Rush > Raging Rush > Raging Rush > Upheaval (MM)
    --Raging Rush > Raging Rush > Sturmwind > Upheaval (MM)
    --Sturmwind > Raging Rush > Raging Rush > Upheaval (MM)
    --Sturmwind > Raging Rush > Sturmwind > Upheaval (MM)
	
-- Great Axe Dark
	--Fell Cleave > Keen Edge > Full Break
	--Weapon Break > Fell Cleave > Keen Edge > Full Break
	--Armor Break > Fell Cleave > Keen Edge > Full Break
	--Sturmwind > Shield Break > Fell Cleave > Keen Edge > Full Break

-- Initialization function for this job file.
packets = require('packets')
function get_sets()
    mote_include_version = 2
    include('Mote-Include.lua')
end
 
-- //gs debugmode
-- //gs showswaps
 
 
function job_setup()
	state.Buff['Mighty Strikes'] = buffactive['Mighty Strikes'] or false
	state.Buff['Doom'] = buffactive['Doom'] or false
	state.Buff['Curse'] = buffactive['Curse'] or false
	state.Buff['Hasso'] = buffactive['Hasso'] or false
	state.Buff['Seigan'] = buffactive['Seigan'] or false
	state.Buff['Berserk'] = buffactive['Berserk'] or false
	state.Buff['Aggressor'] = buffactive['Aggressor'] or false
	state.Buff['Defender'] = buffactive['Defender'] or false
	state.Buff['Restraint'] = buffactive['Restraint'] or false

	state.CP = M(false, "Capacity Points Mode")
	include('Mote-TreasureHunter')
end
 
function user_setup()
    -- Options: Override default values
    state.OffenseMode:options('Normal', 'Crit', 'Subtle')
    state.WeaponskillMode:options('Normal', 'AtkCap', 'DT')
    state.HybridMode:options('Normal', 'DT')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal','PDT')
    state.PhysicalDefenseMode:options('PDT', 'MDT')
	state.WeaponLock = M(false, 'Weapon Lock')
	state.WeaponSet = M{['description']='Weapon Set', 'Aeonic', 'Axe', 'Naegling', 'Club', 'Polearm', 'Ragnarok', 'Staff', 'Malevolence'}
	include('organizer-lib')
	
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
    state.AutoWSList = M{['description']='Auto WS List', 'OFF', 'Savage', '3step1', '4step1', 'OmenMagical', 'OmenPhysical', 'Omen6Step'}
	send_command('bind @x gs c cycle AutoWSList')
	
    select_default_macro_book()
	set_lockstyle()

end
 
 
    -- Define sets and vars used by this job file.
function init_gear_sets()
--TH sets
	sets.TreasureHunter = { 
		head=gear.Valorous.Head_TH,
		feet=gear.Valorous.Feet_TH ,
		waist="Chaac Belt",
		}
		
	sets.enmity = {
		ammo="Sapience Orb",
		--head="Halitus Helm",
		--body="Emet Harness +1",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Unmoving Collar +1",
		waist="Kasiri Belt",
		--left_ear="Friomisi Earring",
		right_ear="Cryptic Earring",
		--left_ring="Eihwaz Ring",
		--right_ring="Supershear Ring",
		--back="Reiki Cloak",
	}	
		
-- Precast sets
    sets.precast.JA['Berserk'] = set_combine(sets.enmity, {
		feet="Agoge Calligae +3",body="Pumm. Lorica +3",back="Cichol's Mantle"
		})
    sets.precast.JA['Warcry'] = set_combine(sets.enmity,{
		head="Agoge Mask +3"
		})
    sets.precast.JA['Aggressor'] = set_combine(sets.enmity, {
		body="Agoge Lorica +3",head="Pummeler's Mask +3"
		})
    sets.precast.JA['Blood Rage'] = set_combine(sets.enmity, {
		body="Boii Lorica +3"
		})
    sets.precast.JA['Retaliation'] = set_combine(sets.enmity, {
		feet="Boii Calligae +3",hands="Pummeler's Mufflers +1"
		})
    sets.precast.JA['Restraint'] = set_combine(sets.enmity, {
		hands="Boii Mufflers +3",
		})
    sets.precast.JA['Mighty Strikes'] = set_combine(sets.enmity, {
		ands="Agoge Mufflers +1",
		})
		
    sets.precast.JA["Warrior's Charge"] = set_combine(sets.enmity, {
		legs="Agoge Cuisses +1",
		})
	
	sets.precast.JA['Tomahawk'] = set_combine(sets.enmity, {
		ammo="Thr. Tomahawk", 
		feet="Agoge Calligae +3",
		})
    
	sets.precast.JA['Provoke'] = set_combine(sets.enmity, {

    })
 
--sets.CP = {back="Mecisto. Mantle"}

-- Fast cast sets for spells
sets.precast.FC = {
    ammo="Sapience Orb",
    head="Sulevia's Mask +2",
    body="Sacro Breastplate", 
    hands="Leyline Gloves", 
    legs="Eschite Cuisses", 
	feet="Nyame Sollerets",
    neck="Voltsurge Torque",
    waist="Flume Belt",
    left_ear="Loquac. Earring",
    right_ear="Etiolation Earring",
    left_ring="Defending Ring",
    right_ring="Prolix Ring",
    back=gear.WARcape_WS1,
		}
     
sets.precast.JA['Jump'] = {
    ammo="Coiste Bodhar",
    head="Hjarrandi Helm",
    body="Hjarrandi Breast.",
    --hands="Sakpata's Gauntlets",
	hands="Crusher Gauntlets",
    legs=gear.Odyssean.Legs_STP, 
	feet="Ostro Greaves",
    neck="Vim Torque +1",
    waist="Ioskeha Belt +1",
	left_ear="Telos Earring",
	right_ear="Dedition Earring", 
    left_ring="Petrov Ring",
    right_ring="Chirich Ring +1",
	back=gear.WARcape_STP,
        }

sets.precast.JA['High Jump'] = set_combine(sets.precast.JA['Jump'], {
	})


    -- Midcast Sets
sets.midcast.FastRecast = {

		}
         
    -- Resting sets
    sets.resting = {

		}
 
-- Idle sets
sets.idle = {
    ammo="Staunch Tathlum",
	head="Nyame Helm",
	body="Sacro Breastplate",
	hands="Nyame Gauntlets",
	legs="Nyame Flanchard",
	feet="Nyame Sollerets",
    neck="Sanctity Necklace",
    waist="Audumbla Sash",
    left_ear="Odnowa Earring +1", 
	right_ear="Infused Earring",
    left_ring="Defending Ring",
    right_ring="Shneddick Ring",
    back=gear.WARcape_WS3,
    }
 
sets.idle.PDT = set_combine(sets.idle, {

	})
 
sets.idle.Town = set_combine(sets.idle, {
		head="Shaded Specs.",
		body="Goldsmith's Apron",
		neck="Goldsm. Torque",
		left_ring="Craftmaster's Ring",

	})
 
sets.idle.Weak = set_combine(sets.idle, {

	})
         
    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Engaged Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------


--double attack 33 as is... need 67
sets.engaged = {
    ammo="Coiste Bodhar", --3
    head="Hjarrandi Helm", --6
    body="Boii Lorica +3", 
    hands="Sakpata's Gauntlets", --6
    legs="Pumm. Cuisses +3", --11
    feet="Pumm. Calligae +3", --9
    neck="Vim Torque +1",
    waist="Ioskeha Belt +1", --9
    left_ear="Schere Earring", --6
	right_ear="Dedition Earring", 
	--right_ear="Boii Earring +2", --9
    left_ring="Moonlight Ring",
    right_ring="Moonlight Ring",
	back=gear.WARcape_STP, --10
} --69

sets.engaged.Crit = set_combine(sets.engaged, {
	head="Boii Mask +3",
	body="Hjarrandi Breast.",
})

--3 from set above
sets.engaged.Subtle = set_combine(sets.engaged, {
	body="Dagon Breast.", --10ii
	feet="Sakpata's Leggings", --15
	right_ear="Boii Earring +2", --7
	left_ring="Chirich Ring +1", --10
	right_ring="Chirich Ring +1", --10
}) --35

sets.Brazen = {
    ammo="Coiste Bodhar", --3
    head="Hjarrandi Helm", --6
    body="Boii Lorica +3", 
    hands="Sakpata's Gauntlets", --6
    legs=gear.Odyssean.Legs_STP, --11
    feet="Pumm. Calligae +3", --9
    neck="Vim Torque +1",
    waist="Sailfi Belt +1", --9
    left_ear="Schere Earring", --6
	right_ear="Dedition Earring", 
	--right_ear="Boii Earring +2", --9
    left_ring="Chirich Ring +1",
    right_ring="Moonlight Ring",
	back=gear.WARcape_STP, --10
}


    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Hybrid Sets -------------------------------------------

    ------------------------------------------------------------------------------------------------

sets.engaged.DT = {
	ammo="Coiste Bodhar", --3
    head="Sakpata's Helm", --5
    body="Sakpata's Plate", --8
    hands="Sakpata's Gauntlets", --6
    legs="Sakpata's Cuisses", --7
    feet="Sakpata's Leggings", --4
    neck="War. Beads +2", --7
    waist="Ioskeha Belt +1", --9
    --left_ear="Schere Earring", --6
	left_ear="Odnowa Earring +1", 
    right_ear="Boii Earring +2", --9
    left_ring="Moonlight Ring",
    right_ring="Moonlight Ring",
	back=gear.WARcape_STPdbl, --10
	} --68
	
sets.engaged.Crit.DT = set_combine(sets.engaged.DT, {
	head="Boii Mask +3",
	body="Hjarrandi Breast.",
})

 --30 from set already
sets.engaged.Subtle.DT = set_combine(sets.engaged.DT, {
	body="Dagon Breast.", --10
	left_ear="Schere Earring", --3
	left_ring="Chirich Ring +1", --10
	right_ring="Niqmaddu Ring", --5
}) --58

         
    -- Weaponskill sets
sets.precast.WS = {
    ammo="Knobkierrie",
	head="Agoge Mask +3",
	--head="Nyame Helm",
	body="Nyame Mail",
	hands="Boii Mufflers +3",
	--hands="Nyame Gauntlets",
	legs="Nyame Flanchard",
	feet="Nyame Sollerets",
    neck="War. Beads +2",
    waist="Sailfi Belt +1",
    left_ear="Thrud Earring",
    right_ear="Moonshade Earring",
    --left_ring="Beithir Ring",
	left_ring="Ephramad's Ring",
    right_ring="Epaminondas's Ring",
    back=gear.WARcape_WS2,	
	}
	
    sets.precast.WS.AtkCap = set_combine(sets.precast.WS, {
		body="Sakpata's Plate",
		--hands="Sakpata's Gauntlets",
		legs="Boii Cuisses +3",
		--feet="Sakpata's Leggings",
	})
	
	sets.precast.WS.Proc = sets.engaged
	
	sets.precast.WS.DT = set_combine(sets.precast.WS, {
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
	})
	
	sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {
		ammo="Yetshila +1",
		--legs="Boii Cuisses +3",
		feet="Boii Calligae +3",
	})
	
	sets.precast.WS['Impulse Drive'].AtkCap = set_combine(sets.precast.WS['Impulse Drive'], {
		--body="Sakpata's Plate",	
		--hands="Sakpata's Gauntlets",
		legs="Boii Cuisses +3",
		--feet="Sakpata's Leggings",
	})
	
	sets.precast.WS['Impulse Drive'].DT = set_combine(sets.precast.WS['Impulse Drive'], {
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
	})
         
    -- Resolution - FTP .71, 1.5, 2.25, - STR 85% 
    -- Fragmentation/Scission
	sets.precast.WS['Resolution'] = {
	--1132ACC
		ammo="Seeth. Bomblet +1",
		head="Agoge Mask +3",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Boii Cuisses +3",
		feet="Sakpata's Leggings",
		neck="War. Beads +2",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Boii Earring +2",
		left_ring="Ephramad's Ring",
		right_ring="Regal Ring",
		back=gear.WARcape_WS1,
    }
    
	sets.precast.WS['Resolution'].AtkCap = set_combine(sets.precast.WS['Resolution'], { 
		body="Sakpata's Plate",
	})
	
	sets.precast.WS['Resolution'].DT = set_combine(sets.precast.WS['Resolution'], { 
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
	})
	
	sets.precast.WS['Mistral Axe'] = set_combine(sets.precast.WS, {
		legs="Boii Cuisses +3",
		--right_ear="Boii Earring +2",
	})
	
    sets.precast.WS['Mistral Axe'].AtkCap = set_combine(sets.precast.WS['Mistral Axe'], {
		body="Sakpata's Plate",
		--hands="Sakpata's Gauntlets",
		legs="Boii Cuisses +3",
		--feet="Sakpata's Leggings",
	})
	
    sets.precast.WS['Mistral Axe'].DT = set_combine(sets.precast.WS['Mistral Axe'], {
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
	})
	
	sets.precast.WS['Calamity'] = set_combine(sets.precast.WS, {
		--legs="Boii Cuisses +3",
		--right_ear="Boii Earring +2"
	})
	
    sets.precast.WS['Calamity'].AtkCap = set_combine(sets.precast.WS['Calamity'], {
		body="Sakpata's Plate",
		--hands="Sakpata's Gauntlets",
		legs="Boii Cuisses +3",
		--feet="Sakpata's Leggings",
	})
	
    sets.precast.WS['Calamity'].DT = set_combine(sets.precast.WS['Calamity'], {
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
	})
	
	sets.precast.WS['Cloudsplitter'] = set_combine(sets.precast.WS, {
		ammo="Seeth. Bomblet +1",
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		neck="Sanctity Necklace",
		waist="Orpheus's Sash",
		right_ear="Friomisi Earring",
		left_ring="Metamorph Ring +1",
		back=gear.WARcape_CloudSp,
	})
	
    sets.precast.WS['Cloudsplitter'].AtkCap = set_combine(sets.precast.WS['Savage Blade'], {
	})
	
    sets.precast.WS['Cloudsplitter'].DT = set_combine(sets.precast.WS['Savage Blade'], {
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
	})
         
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
		--right_ear="Boii Earring +2",
		--legs="Boii Cuisses +3",
	})
     
    sets.precast.WS['Savage Blade'].AtkCap = set_combine(sets.precast.WS['Savage Blade'], {
		--body="Sakpata's Plate",
		--hands="Sakpata's Gauntlets",
		legs="Boii Cuisses +3",
		--feet="Sakpata's Leggings",
	})
	
    sets.precast.WS['Savage Blade'].DT = set_combine(sets.precast.WS['Savage Blade'], {
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
	})
	
    sets.precast.WS['Judgment'] = set_combine(sets.precast.WS, {
		--right_ear="Boii Earring +2",
		--legs="Boii Cuisses +3",
	})
	
    sets.precast.WS['Judgment'].AtkCap = set_combine(sets.precast.WS['Judgment'], {
		--body="Sakpata's Plate",
		--hands="Sakpata's Gauntlets",
		legs="Boii Cuisses +3",
		feet="Sakpata's Leggings",
	})
	
    sets.precast.WS['Judgment'].DT = set_combine(sets.precast.WS['Judgment'], {
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
	})
	
    sets.precast.WS['Ukko\'s Fury'] = set_combine(sets.precast.WS, {
		ammo="Yetshila +1",
		head="Agoge Mask +3",
		feet="Boii Calligae +3",
		neck="War. Beads +2",
		waist="Sailfi Belt +1",
		left_ear="Thrud Earring",
		right_ear="Boii Earring +2",
		left_ring="Ephramad's Ring",
		right_ring="Regal Ring",
		back=gear.WARcape_WS1,
	})
     
    sets.precast.WS['Ukko\'s Fury'].AtkCap = set_combine(sets.precast.WS['Ukko\'s Fury'], {
		body="Sakpata's Plate",
		--hands="Sakpata's Gauntlets",
		legs="Boii Cuisses +3",
		--feet="Sakpata's Leggings",
	})
	
    sets.precast.WS['Ukko\'s Fury'].DT = set_combine(sets.precast.WS['Ukko\'s Fury'], {
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
	})
	
	sets.precast.WS['Raging Rush'] = sets.precast.WS['Ukko\'s Fury']
     
    sets.precast.WS['Raging Rush'].AtkCap = set_combine(sets.precast.WS['Ukko\'s Fury'], {
		body="Sakpata's Plate",
		--hands="Sakpata's Gauntlets",
		legs="Boii Cuisses +3",
		--feet="Sakpata's Leggings",
	})
	
    sets.precast.WS['Raging Rush'].DT = set_combine(sets.precast.WS['Ukko\'s Fury'], {
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
	})
	
    sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS, {
		legs="Boii Cuisses +3",
		back=gear.WARcape_WS3,
		left_ring="Ephramad's Ring",
		right_ring="Regal Ring",
	})
     
    sets.precast.WS['Upheaval'].AtkCap = set_combine(sets.precast.WS['Upheaval'], {
		body="Sakpata's Plate",
		--hands="Sakpata's Gauntlets",
		legs="Boii Cuisses +3",
		--feet="Sakpata's Leggings",
	})
	
    sets.precast.WS['Upheaval'].DT = set_combine(sets.precast.WS['Upheaval'], {
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
	})
	
    sets.precast.WS['Steel Cyclone'] = set_combine(sets.precast.WS, {
	})
     
    sets.precast.WS['Steel Cyclone'].AtkCap = set_combine(sets.precast.WS['Steel Cyclone'], {
		body="Sakpata's Plate",
		--hands="Sakpata's Gauntlets",
		legs="Boii Cuisses +3",
		--feet="Sakpata's Leggings",
	})
	
    sets.precast.WS['Steel Cyclone'].DT = set_combine(sets.precast.WS['Steel Cyclone'], {
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
	})
	
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
		ammo="Ghastly Tathlum +1",
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		neck="Sanctity Necklace",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		left_ring="Metamorph Ring +1",
		back=gear.WARcape_WSint,
	})
	
    sets.precast.WS['Armor Break'] = set_combine(sets.precast.WS, {
		ammo="Seeth. Bomblet +1",
		head="Boii Mask +3",
		body="Boii Lorica +3",
		hands="Boii Mufflers +3",
		legs="Boii Cuisses +3",
		feet="Boii Calligae +3",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Crep. Earring",
		right_ear="Boii Earring +2",
		left_ring="Metamorph Ring +1",
		right_ring="Stikini Ring +1",
		back=gear.WARcape_WSint,
	})
	
	sets.precast.WS['Armor Break'].proc = sets.engaged	
	
	sets.precast.WS['Aeolian Edge'].proc = sets.engaged
	
    sets.precast.WS['Earth Crusher'] = set_combine(sets.precast.WS, {
		ammo="Ghastly Tathlum +1",
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		neck="Sanctity Necklace",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		left_ring="Metamorph Ring +1",
		back=gear.WARcape_WSint,
	})
	
	sets.precast.WS['Earth Crusher'].proc = sets.engaged
	
    sets.precast.WS['Cataclysm'] = set_combine(sets.precast.WS, {
		ammo="Ghastly Tathlum +1",
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		neck="Sanctity Necklace",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		left_ring="Metamorph Ring +1",
		back=gear.WARcape_WSint,
	})
	
	sets.precast.WS['Cataclysm'].proc = sets.engaged

    sets.precast.WS['Shell Crusher'] = set_combine(sets.precast.WS, {
		ammo="Seeth. Bomblet +1",
		head="Boii Mask +3",
		body="Boii Lorica +3",
		hands="Boii Mufflers +3",
		legs="Boii Cuisses +3",
		feet="Boii Calligae +3",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Crep. Earring",
		right_ear="Boii Earring +2",
		left_ring="Metamorph Ring +1",
		right_ring="Stikini Ring +1",
		back=gear.WARcape_WSint,
	})
     
     -- Mighty Strikes WS Set --
sets.MS_WS = {
	ammo="Yetshila +1", 
    feet="Boii Calligae +3",
	}
	
sets.maxTP = {
	right_ear="Boii Earring +2"
	}
	
sets.Omen = {
	main="Quint Spear",
	sub="Khonsu",
	}
	
sets.Ragnarok = {
	main="Ragnarok",
	sub="Utu Grip",
	}

sets.Polearm = {
	main="Shining One",
	sub="Utu Grip",
	}
	
sets.Aeonic = {
	main="Chango",
	sub="Utu Grip",
	}
	
sets.Club = {
	main="Loxotic Mace +1",
	sub="Blurred Shield +1",
	}

sets.Naegling = {
	main="Naegling",
	sub="Blurred Shield +1",
	}
	
sets.Axe = {
	main="Ikenga's Axe",
	sub="Blurred Shield +1",
	}
	
sets.Malevolence = {
	main="Malevolence",
	sub="Ternion Dagger +1",
}

sets.Staff = {
	main="Xoanon",
	sub="Khonsu",
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
		elseif spell.type == "WeaponSkill" and spell.target.distance > 7 then -- Cancel WS If You Are Out Of Range --
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
	-- Make sure abilities using head gear don't swap 
    if spell.type:lower() == 'weaponskill' then
        if player.equipment.main == "Chango" and player.tp > 1500 then
            equip(sets.maxTP)
		elseif player.equipment.main == "Naegling" and player.tp > 1440 then
			equip(sets.maxTP)
		elseif player.equipment.main == "Loxotic Mace +1" and player.tp > 1440 then
			equip(sets.maxTP)
		elseif player.equipment.main == "Shining One" and player.tp > 2100 then
			equip(sets.maxTP)
		elseif player.equipment.main == "Ikenga's Axe" and player.tp > 1000 then 
			equip(sets.maxTP)
        end
    end
	
	if state.Buff['Mighty Strikes'] and spell.type:lower() == 'weaponskill' then 
		equip(sets.MS_WS)
		else
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
	if state.Buff['Doom'] or state.Buff['Curse'] then
		meleeSet = set_combine(meleeSet, sets.Doom)
	end
	if player.sub_job == 'SAM' and (not state.Buff['Hasso'] and not state.Buff['Seigan']) then 
		if player.equipment.sub == "Utu Grip" then
			send_command('input /ja Hasso')
		elseif player.equipment.sub == "Blurred Shield +1" then

		end
		end
	--[[if not state.Buff['Berserk'] and not state.buff['Defender'] then 
			send_command('input /ja Berserk')
		end
	if not state.Buff['Aggressor'] then 
			send_command('input /ja Aggressor')
		end]]
	--[[if state.Buff['Hasso'] then 
		--add_to_chat(100,'> > > > Should swap to Hasso mode')
        meleeSet = set_combine(meleeSet, sets.Hasso)
    end]]
	return meleeSet
end


-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    end
	if buff == "Doom" or buff == "Curse" then
		if gain then
			equip(sets.doom)
		else
			handle_equipping_gear(player.status)
		end
	end
	--[[if buff == "Scherzo" then 			
		if not gain then 	
			send_command('input /p SCHERZO OFF HELP ME OUT!!!!!!!!!!! <call8>!!!!!!!!!')
		else 
			handle_equipping_gear(player.status)
		end
	end		]]
			
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

        disable('main', 'sub')
		
		

    else

        enable('main', 'sub', 'range', 'ammo', 'neck')

    end

end

function update_melee_groups()

end



-- Select default macro book on initial load or subjob change.

function select_default_macro_book()

    -- Default macro set/book: (set, book)

    --if player.sub_job == 'SAM' then

        set_macro_page(1, 8)

    --else

        set_macro_page(1, 8)

    --end

end



function set_lockstyle()

    send_command('wait 8; input /lockstyleset 99')

end



