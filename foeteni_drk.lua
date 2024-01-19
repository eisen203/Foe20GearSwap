--[[ Inf
Commands
	//gs debugmode
	//gs showswaps
	//gs validate - looks for gear in your sets that isnt in inventory.

-- Scythe Light:
	Insurgency > Vorpal Scythe > Entropy > Guillotine > Entropy > Insurgency 
	Vorpal Scythe > Entropy > Guillotine > Entropy > Insurgency 
	Entropy > Guillotine > Entropy > Insurgency 
	Guillotine > Entropy > Insurgency
	
-- Scythe Darkness: 
    Insurgency (M) > Vorpal Scythe > Vorpal Scythe > Insurgency (M) > Entropy (MM) > Cross Reaper
    Entropy (MM) > Guillotine > Entropy (MM) > Cross Reaper > Entropy (MM)
	Cross Reaper > Insurgency (M) > Entropy (MM) > Cross Reaper
    Insurgency (M) > Entropy (MM) > Cross Reaper
	Cross Reaper > Entropy (MM)
    Entropy (MM) > Cross Reaper

-- Apoc Darkness
    Entropy (MM) > Guillotine > Entropy (MM) > Cross Reaper > Entropy (MM) > Catastrophe (R)
    Entropy (MM) > Guillotine > Entropy (MM) > Cross Reaper > Entropy (MM)
    Insurgency (M) > Entropy (MM) > Cross Reaper > Catastrophe (R)
	Insurgency (M) > Catastrophe (R) > Cross Reaper > Catastrophe (R)
	Cross Reaper > Insurgency (M) > Catastrophe (R) > Cross Reaper
	Catastrophe (R) > Cross Reaper > Catastrophe (R)
	Insurgency (M) > Catastrophe (R) > Cross Reaper
	Cross Reaper > Catastrophe (R) > Catastrophe (R)
    Cross Reaper > Entropy (MM) > Catastrophe (R)
	Entropy (MM) > Cross Reaper > Catastrophe (R)
    Catastrophe (R) > Catastrophe (R)
    Catastrophe (R) > Cross Reaper
    Cross Reaper > Catastrophe (R)

-- Other Light
	Catastrophe (R) > Savage Blade (Q) > Insurgency (M)
    Entropy (MM) > Savage Blade (Q) > Insurgency (M)
	Savage Blade (Q) > Insurgency (M)
	Chant du Cygne (E) > Torcleaver (E)

-- Other Dark
	Atonement (M) > Entropy (MM) > Cross Reaper
	Savage Blade (Q) > Cross Reaper > Entropy (MM)
	Chant du Cygne (E) > Catastrophe (R)
	Chant du Cygne (E) > Entropy (MM)
    Requiescat (MM) > Cross Reaper
	Requiescat (MM) > Torcleaver (E)

-- GreatSword
    Resolution (MM) > Torcleaver (E) > Scourge (R) > Resolution (MM) > Torcleaver (E)
	Resolution (MM) > Torcleaver (E) > Scourge (R) > Resolution (MM)
    Resolution (MM) > Scourge (R) > Torcleaver (E)
	Scourge (R) > Resolution (MM) > Torcleaver (E)
	Torcleaver (E) > Torcleaver (E)
	Scourge (R) > Resolution (MM)
--]]
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
    state.Buff.Souleater = buffactive.Souleater or false
	state.Buff['Dark Seal'] = buffactive['Dark Seal'] or false
	state.Buff['Last Resort'] = buffactive['Last Resort'] or false
	state.Buff['Doom'] = buffactive['Doom'] or false
	state.Buff['Curse'] = buffactive['Curse'] or false
	state.Buff['Hasso'] = buffactive['Hasso'] or false
	state.Buff['Seigan'] = buffactive['Seigan'] or false
		
	include('Mote-TreasureHunter')
	
	LowTierNuke = S{
		'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder',
		'Stone II', 'Water II', 'Aero II', 'Fire II', 'Blizzard II', 'Thunder II',
		'Stone III', 'Water III', 'Aero III', 'Fire III', 'Blizzard III', 'Thunder III',
		'Stonega', 'Waterga', 'Aeroga', 'Firaga', 'Blizzaga', 'Thundaga',
		'Stonega II', 'Waterga II', 'Aeroga II', 'Firaga II', 'Blizzaga II', 'Thundaga II'}
		
	Absorbs = S{'Absorb-STR', 'Absorb-DEX', 'Absorb-VIT', 'Absorb-AGI', 'Absorb-INT', 'Absorb-MND', 'Absorb-CHR', 'Absorb-Attri', 'Absorb-ACC', 'Absorb-TP'}
		
	lockstyleset = 60
end

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    -- Options: Override default values
    state.OffenseMode:options('MultiAtk', 'STP', 'Schere', 'Subtle', 'Dom')
    state.WeaponskillMode:options('Normal', 'AtkCap')
    state.HybridMode:options('Normal', 'DamageTaken')
    state.CastingMode:options('Normal', 'Occult')
    state.IdleMode:options('Normal', 'DamageTaken', 'HP', 'Aminon')
	
	state.WeaponSet = M{['description']='Weapon Set', 'Foenaria', 'Caladbolg',  'Club', 'Sword', 'Ragnarok', 'GAxe', 'Apocalypse', 'Lib', 'Anguta' }
	
	wsnum = 0
	
	send_command('lua l gearinfo')
	
	Haste = 0
	DW_needed = 0  
	DW = false  
	moving = false  
	update_combat_form()  
	determine_haste_group()
	
	state.RR = M{['description']='RR mode','OFF','true'}
	send_command('bind @i gs c cycle RR')
	
	state.AutoWS = M{['description']='Auto WS','OFF','true'}
    send_command('bind @z gs c cycle AutoWS')
    state.AutoWSList = M{['description']='Auto WS List', 'OFF', 'Cata', 'Torc', 'Apoc2Dark', 'Apoc5Dark'}
	send_command('bind @x gs c cycle AutoWSList')
	-- Additional local binds
	include('organizer-lib')
   -- include('Global-Binds.lua') -- OK to remove this line
   -- include('Global-GEO-Binds.lua') -- OK to remove this line	
    select_default_macro_book()
    set_lockstyle()
end

-- Called when this job file is unloaded (eg: job change)
function file_unload()
     send_command('unbind ^`')
     send_command('unbind !`')
     send_command('unbind ^-')
     send_command('unbind ^=')
     send_command('unbind ^f11')
     send_command('unbind @h')
     send_command('unbind @k')
     send_command('unbind @d')
     send_command('unbind !q')
     send_command('unbind !w')
     send_command('unbind !o')
     send_command('unbind !p')
     send_command('unbind ^,')
     send_command('unbind @w')
     send_command('unbind @c')
	 send_command('unbind @z')
	 send_command('unbind @x')
     send_command('unbind ^numlock')
     send_command('unbind ^numpad/')
     send_command('unbind ^numpad*')
     send_command('unbind ^numpad-')
     send_command('unbind ^numpad7')
     send_command('unbind !numpad7')
     send_command('unbind ^numpad9')
     send_command('unbind !numpad4')
     send_command('unbind ^numpad5')
     send_command('unbind ^numpad1')
     send_command('unbind @numpad*')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
-- Precast sets
    sets.precast.JA['Diabolic Eye'] = {hands="Fall. Fin. Gaunt. +3"}
    sets.precast.JA['Arcane Circle'] = {feet="Ignominy Sollerets +3"}
    sets.precast.JA['Nether Void'] = {legs="Heath. Flanchard +3"}
    sets.precast.JA['Souleater'] = {head="Ig. Burgeonet +3"}
    sets.precast.JA['Last Resort'] = {feet="Fall. Sollerets +3", back=gear.DRKcape_DBLATKdex}
    sets.precast.JA['Weapon Bash'] = {hands="Ignominy Gauntlets +3"}
    sets.precast.JA['Blood Weapon'] = {body="Fall. Cuirass +3"}
	sets.precast.JA['Dark Seal']    = {head="Fall. Burgeonet +3"}

--TH gear
	sets.TreasureHunter = { 
		head=gear.Valorous.Head_TH,
		feet=gear.Valorous.Feet_TH ,
		waist="Chaac Belt",
		}
		
-- Waltz set (chr and vit)
    sets.precast.Waltz = {}

-- Fast cast sets for spells
sets.precast.FC = {
	ammo="Sapience Orb", --2
    head="Carmine Mask +1", --14
    body="Sacro Breastplate", --10
    hands="Leyline Gloves", --8
    legs="Eschite Cuisses", --5
    feet="Carmine Greaves +1", --8
    neck="Voltsurge Torque", --4
    waist="Casso Sash",
    left_ear="Malignance Earring", --4
    right_ear="Loquac. Earring", --2
    left_ring="Prolix Ring", --2
    right_ring="Kishar Ring", --4
    back=gear.DRKcape_FstCst, --10
		} --total = 73

sets.precast.FC.Resistant = {
	ammo="Sapience Orb", --2
    legs="Eschite Cuisses", --5
    neck="Voltsurge Torque", --4
    waist="Casso Sash",
    left_ring="Prolix Ring", --2
    right_ring="Kishar Ring", --4
    back=gear.DRKcape_FstCst, --10
		} --total = 27

sets.precast.FC.Impact = set_combine(sets.precast.FC, {
		head=empty, 
		body="Twilight Cloak"
		})

sets.precast['Scarlet Delirium'] = {
	head="Pixie Hairpin +1",
	body="Emet Harness +1",
	hands="Gazu Bracelets +1",
	legs=gear.Odyssean.Legs_STP,
	feet="Thereoid Greaves",
    left_ring="Begrudging Ring",
    right_ring=empty,
	back=empty,
}

sets.precast.JA['Jump'] = {
    ammo="Coiste Bodhar",
	head="Flam. Zucchetto +2",
	body="Hjarrandi Breast.",
    --hands="Sakpata's Gauntlets",
	hands="Crusher Gauntlets",
    legs=gear.Odyssean.Legs_STP,
    feet="Ostro Greaves",
    neck="Abyssal Beads +2",
    waist="Ioskeha Belt +1",
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    left_ring="Moonlight Ring",
    right_ring="Moonlight Ring",
    back=gear.DRKcape_STP,
}

sets.precast.JA['High Jump'] = set_combine(sets.precast.JA['Jump'], {

	})
-- Midcast Sets
    sets.midcast.FastRecast = {
		--[[ammo="Impatiens",
		head="Carmine Mask +1", body=Ody_FC_body,
		back=Ank_FC, neck="Orunmila's Torque",
		hands="Leyline Gloves", waist="Sailfi Belt +1",
		legs="Eschite Cuisses", feet=Ody_FC_feet,
		ring1="Lebeche Ring", ring2="Kishar Ring",
		ear1="Enchanter Earring +1", ear2="Loquacious Earring"]]
		}

-- Specific spells
sets.midcast['Dark Magic'] = {
    ammo="Pemphredo Tathlum",
    head="Sakpata's Helm",  
    body="Heath. Cuirass +3", 
    hands="Fall. Fin. Gaunt. +3", 
    legs="Heath. Flanchard +3", 
    feet="Rat. Sollerets +1",
    neck="Incanter's Torque",
    waist="Casso Sash",
    left_ear="Malignance Earring",
    right_ear="Heathen's Earring +2",
    left_ring="Stikini Ring +1",
    right_ring="Evanescence Ring",
    back="Niht Mantle",
		}
sets.midcast['Dark Magic'].Resistant = {
    ammo="Pemphredo Tathlum",
    legs="Heath. Flanchard +3", 
    feet="Ratri Sollerets +1",
    neck="Erra Pendant",
    waist="Casso Sash",
    left_ring="Stikini Ring +1",
    right_ring="Evanescence Ring",
    back="Niht Mantle",
	}
	
sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
    ammo="Pemphredo Tathlum",
    head="Fall. Burgeonet +3", 
    body="Carm. Sc. Mail +1", 
    hands="Fall. Fin. Gaunt. +3", 
    legs="Heath. Flanchard +3", 
    feet="Ratri Sollerets +1",
    neck="Erra Pendant",
    waist="Orpheus's Sash",
    left_ear="Hirudinea Earring",
    right_ear="Heathen's Earring +2",
    left_ring="Stikini Ring +1",
    right_ring="Evanescence Ring",
    back="Niht Mantle",
		})
	
sets.midcast.Drain.Resistant = {
    ammo="Pemphredo Tathlum",
	legs="Heath. Flanchard +3", 
    feet="Ratri Sollerets +1",
    neck="Erra Pendant",
    waist="Casso Sash",
    left_ring="Archon Ring",
    right_ring="Evanescence Ring",
    back="Niht Mantle",
		}

	sets.midcast['Drain III'] = sets.midcast.Drain
	sets.midcast['Drain III'].Resistant = sets.midcast.Drain.Resistant
		
	sets.midcast.Aspir = sets.midcast.Drain
	sets.midcast.Aspir.Resistant = sets.midcast.Drain.Resistant
	
-- Absorbs
sets.midcast.Absorb = {
    ammo="Pemphredo Tathlum",
    head="Ig. Burgeonet +3",  
    body="Heath. Cuirass +3",
    hands="Heath. Gauntlets +3", 
    legs="Heath. Flanchard +3", 
    feet="Ratri Sollerets +1",
    neck="Erra Pendant",
    waist="Eschan Stone",
    left_ear="Malignance Earring",
    right_ear="Heathen's Earring +2",
    left_ring="Moonlight Ring",
    right_ring="Kishar Ring",
    back=gear.DRKcape_FstCst,
		}
    
sets.midcast.Absorb.Resistant = set_combine(sets.midcast.Absorb, {
    ammo="Pemphredo Tathlum",
    legs="Heath. Flanchard +3", 
    feet="Ratri Sollerets +1",
    neck="Erra Pendant",
    waist="Eschan Stone",
    left_ring="Stikini Ring +1",
    right_ring="Kishar Ring",
    back=gear.DRKcape_FstCst,
		})

sets.midcast['Absorb-TP'] = set_combine(sets.midcast.Absorb, {
		head="Heath. Bur. +3",   
		hands="Heath. Gauntlets +3",    
		feet="Heath. Sollerets +3",
		waist="Sailfi Belt +1",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
	})
sets.midcast['Absorb-TP'].Resistant = set_combine(sets.midcast.Absorb.Resistant, {--hands="Heathen's Gauntlets +1"})
	})
	
sets.midcast['Endark II'] = set_combine(sets.midcast['Dark Magic'], {
	body="Carm. Sc. Mail +1",
})	
	
sets.midcast['Enfeebling Magic'] = {
    ammo="Pemphredo Tathlum",
    head="Heath. Bur. +3",  
    body="Heath. Cuirass +3", 
    hands="Heath. Gauntlets +3", 
    legs="Heath. Flanchard +3", 
    feet="Heath. Sollerets +3",
    neck="Erra Pendant",
    waist="Eschan Stone",
    left_ear="Malignance Earring",
    right_ear="Heathen's Earring +2",
    left_ring="Moonlight Ring",
    right_ring="Stikini Ring +1",
    back=gear.DRKcape_FstCst,
		}
	
sets.midcast['Enfeebling Magic'].Resistant = {
    ammo="Pemphredo Tathlum",
    legs="Heath. Flanchard +3", 
    neck="Erra Pendant",
    waist="Eschan Stone",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back=gear.DRKcape_FstCst,
		}
		
sets.midcast['Poison'] = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)

-- Based on HP when casted.
sets.midcast['Dread Spikes'] = {
	--main="Crepuscular Scythe",
    --ammo="Impatiens",
    head="Ratri Sallet +1",
    body="Heath. Cuirass +3",
    hands="Ratri Gadlings +1",
    legs="Ratri Cuisses",
    feet="Ratri Sollerets +1",
    neck="Unmoving Collar +1",
    waist="Plat. Mog. Belt",
    left_ear="Tuisto Earring",
    right_ear="Odnowa Earring +1",
    left_ring="Moonlight Ring",
    right_ring="Moonlight Ring",
    back="Moonbeam Cape",
		}

sets.midcast.Stun = {
    ammo="Pemphredo Tathlum",
    head="Nyame Helm",
    body="Heath. Cuirass +3",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Ratri Sollerets +1",
    neck="Incanter's Torque",
    waist="Ioskeha Belt +1",
    left_ear="Malignance Earring",
    right_ear="Heathen's Earring +2",
    left_ring="Moonlight Ring",
    right_ring="Moonlight Ring",
    back=gear.DRKcape_FstCst,
		}

sets.midcast.Stun.Resistant = {
        ammo="Sapience Orb", --2
        legs="Heath. Flanchard +3", 
        neck="Unmoving Collar +1", --10
		waist="Eschan Stone", --3
		left_ring="Supershear Ring", --5  
        right_ring="Eihwaz Ring", --5
	    back="Niht Mantle", --10
		}
		

	sets.midcast.Impact = {
		ammo="Coiste Bodhar",
		head=empty, 
		body="Twilight Cloak",
		hands="Gazu Bracelets +1",
		legs=gear.Odyssean.Legs_STP,
		feet="Heath. Sollerets +3",
		neck="Vim Torque +1",
		waist="Oneiros Rope",
		left_ear="Crep. Earring",
		right_ear="Dedition Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back=gear.DRKcape_FstCst,
		}
	sets.midcast.Impact.Resistant = set_combine(sets.midcast['Dark Magic'].Resistant, {head=empty, body="Twilight Cloak"})

-- Elemental Magic sets are default for handling low-tier nukes.
sets.midcast.LowTierNuke = {
    ammo="Staunch Tathlum", --2
	head="Nyame Helm",
	body="Nyame Mail",
	hands="Nyame Gauntlets",
	legs="Nyame Flanchard",
	feet="Heath. Sollerets +3",
	neck="Loricate Torque +1", --6
    waist="Oneiros Rope",
    left_ear="Crep. Earring",
    right_ear="Dedition Earring",
    left_ring="Defending Ring", --10
    right_ring="Chirich Ring +1",
    back=gear.DRKcape_STP,
	--[[
	ammo="Ghastly Tathlum +1",
	head="Nyame Helm",
	body="Sacro Breastplate",
	hands="Fall. Fin. Gaunt. +3",
	legs="Nyame Flanchard",
	feet="Heath. Sollerets +3",
    neck="Sibyl Scarf",
    waist="Orpheus's Sash",
    left_ear="Friomisi Earring",
    right_ear="Crep. Earring",
    left_ring="Metamorph Ring +1",
    right_ring="Shiva Ring +1",
    back=gear.DRKcape_FstCst, 
	]]
		}

sets.midcast.LowTierNuke.Occult = {
	ammo="Coiste Bodhar",
	head="Hjarrandi Helm",
	body="Hjarrandi Breast.",
    hands="Sakpata's Gauntlets",
    legs=gear.Odyssean.Legs_STP,
	feet="Heath. Sollerets +3",
    neck="Vim Torque +1",
    waist="Oneiros Rope",
    left_ear="Crep. Earring",
    right_ear="Dedition Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back=gear.DRKcape_STP,
		}

	-- Custom classes for high-tier nukes.
	sets.midcast.HighTierNuke = sets.midcast.LowTierNuke
	sets.midcast.HighTierNuke.Occult = sets.midcast.LowTierNuke.Occult

-- Resting sets
	sets.resting = {

}
							--DT/PDT/MDT, just one number means its DT, and (x) = -x
-- Idle sets
sets.idle = {
    ammo="Staunch Tathlum", --2
	head="Ratri Sallet +1",
	--head="Crepuscular Helm",
	body="Sacro Breastplate",
	hands="Volte Moufles",
    legs="Sakpata's Cuisses",
	feet="Nyame Sollerets",
    neck="Bathy Choker +1", --6
    waist="Flume Belt", --0/4/0
    left_ear="Infused Earring", --0/0/1
    right_ear="Eabani Earring", --0/0/3
    left_ring="Defending Ring", --10
    right_ring="Shneddick Ring", --0/7/0
    back=gear.DRKcape_DBLATKstr, 
		} --totals 41/52/44
						
						--DT/PDT/MDT, just one number means its DT, and (x) = -x
sets.idle.DamageTaken = {
    ammo="Staunch Tathlum", --2
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck="Loricate Torque +1", --6
    waist="Flume Belt", --0/4/0
    left_ear="Infused Earring", --0/0/1
    right_ear="Etiolation Earring", --0/0/3
    left_ring="Defending Ring", --10
    right_ring="Shneddick Ring", --7
    back=gear.DRKcape_DBLATKdex, --5
		} --totals 47/51/50
							--DT/PDT/MDT, just one number means its DT, and (x) = -x
sets.idle.HP = {
    ammo="Staunch Tathlum", --2
    head="Ratri Sallet +1",  --(7)
    --body="Ratri Plate +1", --(13)
	body="Sacro Breastplate",
    hands="Ratri Gadlings +1", --(9)
    legs="Ratri Cuisses", 
    feet="Rat. Sollerets +1", --(6)
    neck="Bathy Choker +1",
    waist="Plat. Mog. Belt", --3DT
	left_ear="Tuisto Earring", --3MDT
	right_ear="Odnowa Earring +1", 
    left_ring="Moonlight Ring", --10
    right_ring="Shneddick Ring", --7
    back=gear.DRKcape_DBLATKstr, --10PDT
	}--totals (7)/10/5
							--DT/PDT/MDT, just one number means its DT, and (x) = -x
sets.idle.Town = {
    	head="Shaded Specs.",
		body="Goldsmith's Apron",
		neck="Goldsm. Torque",
		left_ring="Craftmaster's Ring",
		right_ring="Shneddick Ring", --7
		} --totals 47/51/50
							--DT/PDT/MDT, just one number means its DT, and (x) = -x
sets.idle.Weak = {
    ammo="Staunch Tathlum", --2
	head="Crepuscular Helm", 
    body="Crepuscular Mail",
    hands="Sakpata's Gauntlets", --8
    legs="Nyame Flanchard", 
    feet="Sakpata's Leggings", --6
    neck="Loricate Torque +1", --6
    waist="Flume Belt", --0/4/0
	left_ear="Tuisto Earring", --3MDT
	right_ear="Odnowa Earring +1", 
    left_ring="Moonlight Ring", --10
    right_ring="Shneddick Ring",
    back="Moonbeam Cape", --5
		} --totals 48/52/51
		
sets.idle.RR = {
    ammo="Staunch Tathlum", --2
	head="Ratri Sallet +1",
	head="Crepuscular Helm",
	body="Crepuscular Mail",
	hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
	feet="Nyame Sollerets",
    neck="Bathy Choker +1", --6
    waist="Flume Belt", --0/4/0
    left_ear="Infused Earring", --0/0/1
    right_ear="Eabani Earring", --0/0/3
    left_ring="Defending Ring", --10
    right_ring="Shneddick Ring", --0/7/0
    back=gear.DRKcape_DBLATKstr, 
		}

--sets.precast.WS
sets.idle.Aminon = {
    ammo="Staunch Tathlum", --2
	head="Ratri Sallet +1",
	body="Ratri Plate +1",
	hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
	feet="Nyame Sollerets",
    neck="Vim Torque +1", --6
    waist="Plat. Mog. Belt", --3DT
    left_ear="Etiolation Earring", --0/0/1
    right_ear="Eabani Earring", --0/0/3
    left_ring="Defending Ring", --10
    right_ring="Roller's Ring", --0/7/0
    back=gear.DRKcape_WSint,
		} 


	sets.Kiting = {right_ring="Shneddick Ring"}

-- Custom buff sets
	sets.Souleater = {head="Ignominy Burgeonet +3"}
	sets['Last Resort'] = {
		--head="Hjarrandi Helm", 
		--body="Hjarrandi Breast.", 
		--feet="Fall. Sollerets +3",
	}
	sets.Doom = {ring2="Purity Ring"}
	sets['Dark Seal'] = {head="Fallen's Burgeonet +3"}
	sets.Aftermath = {}

sets.engaged = {}

-- Engaged Sets #s based off Caladbolg

--1192acc, 81stp, 21da, 12dt, 22pdt
sets.engaged.STP = {
    ammo="Coiste Bodhar",
	head="Flam. Zucchetto +2",
	body="Hjarrandi Breast.",
    hands="Sakpata's Gauntlets",
    legs=gear.Odyssean.Legs_STP,
    feet="Flam. Gambieras +2",
    neck="Abyssal Beads +2",
    waist="Ioskeha Belt +1",
    left_ear="Dedition Earring",
    right_ear="Crep. Earring",
    left_ring="Moonlight Ring",
    right_ring="Moonlight Ring",
    back=gear.DRKcape_STP,
}

--1199acc, 23stp, 61da, 30dt
sets.engaged.MultiAtk = {
    ammo="Coiste Bodhar",
    head="Flam. Zucchetto +2",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Ignominy Flanchard +3",
    feet="Flam. Gambieras +2",
    neck="Abyssal Beads +2",
    waist="Ioskeha Belt +1",
    left_ear="Dedition Earring",
	right_ear="Telos Earring",
    --right_ear="Schere Earring",
    left_ring="Moonlight Ring",
    right_ring="Moonlight Ring",
    back=gear.DRKcape_STP,
}

--11 sb from set before
sets.engaged.Subtle  = set_combine(sets.engaged.MultiAtk, {
	body="Dagon Breast.",
	feet="Sakpata's Leggings", --15
	left_ear="Digni. Earring", --5
	left_ring="Chirich Ring +1", --10
	--right_ring="Chirich Ring +1", --10
	right_ring="Niqmaddu Ring",
	back=gear.DRKcape_STP,
})
 --46 sb1 and 15 sbii
sets.engaged.Dom = set_combine(sets.idle.Aminon, {
    neck="Vim Torque +1",
})
--1199acc, 23stp, 61da, 30dt
sets.engaged.Schere = set_combine(sets.engaged.MultiAtk, {
    right_ear="Schere Earring",
})

-- Engaged DamageTaken
sets.engaged.DamageTaken={}

--1153acc, 15stp, 50da, 46dt the subtle blow set for now 30 subtle blow
sets.engaged.STP.DamageTaken = {
    ammo="Coiste Bodhar",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck="Abyssal Beads +2",
    waist="Ioskeha Belt +1",
    left_ear="Dedition Earring",
    right_ear="Schere Earring",
    left_ring="Moonlight Ring",
    right_ring="Moonlight Ring",
    back=gear.DRKcape_STP,
		}

--1153acc, 15stp, 50da, 46dt	
sets.engaged.MultiAtk.DamageTaken = {
    ammo="Coiste Bodhar",
    head="Nyame Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck="Abyssal Beads +2",
    waist="Ioskeha Belt +1",
    left_ear="Dedition Earring",
	right_ear="Telos Earring",
    --right_ear="Schere Earring",
    left_ring="Moonlight Ring",
    right_ring="Moonlight Ring",
    back=gear.DRKcape_STP,
		}
	--23sb1 from set before
sets.engaged.Subtle.DamageTaken = set_combine(sets.engaged.MultiAtk.DamageTaken, {
	body="Dagon Breast.",
	--left_ear="Digni. Earring", --5
	left_ring="Defending Ring", 
	--right_ring="Chirich Ring +1", --10
	right_ring="Niqmaddu Ring",
	back=gear.DRKcape_STP,
	})
		
sets.engaged.Schere.DamageTaken = set_combine(sets.engaged.MultiAtk.DamageTaken, {
	head="Nyame Helm",
    body="Nyame Mail",
    legs="Nyame Flanchard",
    --feet="Nyame Sollerets",
	right_ear="Schere Earring",
})

	sets.engaged.HP = {
		ammo="Staunch Tathlum", --2
		head="Ratri Sallet +1", --(8)
		body="Hjarrandi Breast.", --12
		hands="Ratri Gadlings +1", --(10)
		legs="Ig. Flanchard +3", 
		feet="Rat. Sollerets +1", --(6)
		neck="Loricate Torque +1",--6
		waist="Ioskeha Belt +1",
		left_ear="Tuisto Earring", --3MDT
		right_ear="Odnowa Earring +1", 
		left_ring="Moonlight Ring", --5
		right_ring="Moonlight Ring", --5
		back=gear.DRKcape_DBLATKdex, --10PDT
	}--totals 23/3/5
	sets.engaged.MultiAtk.HP = set_combine(sets.engaged.HP, {})
	sets.engaged.Subtle.HP = set_combine(sets.engaged.HP, {})
	sets.engaged.Schere.HP = set_combine(sets.engaged.HP, {
		right_ear="Schere Earring", 
	})
	

sets.precast.WS = {
    ammo="Knobkierrie",
    --ammo="Crepuscular Pebble",
    head="Nyame Helm",
    body="Nyame Mail",
	hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Heath. Sollerets +3",
	--feet="Nyame Sollerets",
    neck="Abyssal Beads +2",
    waist="Sailfi Belt +1",
    left_ear="Moonshade Earring", 
    right_ear="Heath. Earring +2",
    left_ring="Epaminondas's Ring",
	--left_ring="Sroda Ring",
    right_ring="Ephramad's Ring",
    back=gear.DRKcape_WSDstr,
		}
sets.precast.WS.Acc = set_combine(sets.precast.WS, {
	body="Ignominy Cuirass +3",
	left_ring="Beithir Ring",
	right_ring="Regal Ring",
	})
		
sets.precast.WS.AtkCap = set_combine(sets.precast.WS, {
    head="Heath. Bur. +3",
	--hands="Sakpata's Gauntlets",
	--feet="Sakpata's Leggings",
	left_ring="Sroda Ring",
	})
sets.precast.WS.Dom = set_combine(sets.precast.WS, {
	feet="Hervor Sollerets",
	})
sets.precast.WS.Schere = set_combine(sets.precast.WS, {
	right_ear="Schere Earring",
	})

sets.precast.WS['Shadow of Death'] = set_combine(sets.precast.WS, {
    head="Pixie Hairpin +1",
    --neck="Sanctity Necklace",
    waist="Orpheus's Sash",
    right_ring="Archon Ring",
    back=gear.DRKcape_FstCst, 
	})		
	
sets.precast.WS['Shadow of Death'].Acc = set_combine(sets.precast.WS['Shadow of Death'], { 
		
		})

sets.precast.WS['Shadow of Death'].AtkCap = set_combine(sets.precast.WS['Shadow of Death'], { 

		})
		
sets.precast.WS['Dark Harvest'] = sets.precast.WS['Shadow of Death']		
	
sets.precast.WS['Dark Harvest'].Acc = set_combine(sets.precast.WS['Dark Harvest'], { 
		
		})
		
sets.precast.WS['Dark Harvest'].AtkCap = set_combine(sets.precast.WS['Dark Harvest'], { 
		
		})
			
-- Entropy - FTP 0.75, 1.25, 2.0, - INT 85% -- Gravitation/Reverberation
sets.precast.WS['Entropy'] = set_combine(sets.precast.WS, { 
    head="Heath. Bur. +3",
	waist="Fotia Belt",
    left_ring="Shiva Ring",
    back=gear.DRKcape_WSint,
	})
		
sets.precast.WS['Entropy'].Acc = set_combine(sets.precast.WS['Entropy'], { 	
	--1205acc
	ammo="Seething Bomblet +1",	
		})

sets.precast.WS['Entropy'].AtkCap = set_combine(sets.precast.WS['Entropy'], { 	
    head="Heath. Bur. +3",
	--feet="Sakpata's Leggings",
	left_ring="Sroda Ring",
		})
sets.precast.WS['Entropy'].Dom = set_combine(sets.precast.WS['Entropy'], { 	
	feet="Hervor Sollerets",	
		})
		
sets.precast.WS['Insurgency'] = set_combine(sets.precast.WS, { 
    head="Heath. Bur. +3",
    --back=gear.DRKcape_WSint,
	left_ring="Sroda Ring",
	})
		
sets.precast.WS['Insurgency'].Acc = set_combine(sets.precast.WS['Insurgency'], { 	
	--1205acc
	ammo="Seething Bomblet +1",
	left_ear="Cessance Earring",
	right_ear="Telos Earring",		
		})

sets.precast.WS['Insurgency'].AtkCap = set_combine(sets.precast.WS['Insurgency'], { 	
    head="Heath. Bur. +3",
	--feet="Sakpata's Leggings",
		})
sets.precast.WS['Insurgency'].Dom = set_combine(sets.precast.WS['Insurgency'], { 	
	feet="Hervor Sollerets",	
		})	

sets.precast.WS['Origin'] = set_combine(sets.precast.WS, { 
	--waist="Fotia Belt",
    --back=gear.DRKcape_WSint,
	})		
		
sets.precast.WS['Origin'].Acc = set_combine(sets.precast.WS['Origin'], { 	
	--1205acc
	ammo="Seething Bomblet +1",	
		})

sets.precast.WS['Origin'].AtkCap = set_combine(sets.precast.WS['Origin'], { 	
    head="Heath. Bur. +3",
	--feet="Sakpata's Leggings",
		})
sets.precast.WS['Origin'].Dom = set_combine(sets.precast.WS['Origin'], { 	
	feet="Hervor Sollerets",	
		})		
		
-- Catastrophe - FTP 2.75 - STR 40%, INT 40% - WSdmg% -- Darkness/Gravitation
sets.precast.WS['Catastrophe'] = set_combine(sets.precast.WS, { 
    left_ear="Thrud Earring",
	})
	
	sets.precast.WS['Catastrophe'].Acc = set_combine(sets.precast.WS['Catastrophe'], {
		
		})

	sets.precast.WS['Catastrophe'].AtkCap = set_combine(sets.precast.WS['Catastrophe'], {
	    --head="Heath. Bur. +3",
		left_ring="Sroda Ring",
		})	
	sets.precast.WS['Catastrophe'].Dom = set_combine(sets.precast.WS['Catastrophe'], { 	
		feet="Hervor Sollerets",	
		})		

-- Quietus - FTP 3.0, - STR 60% MND 60% - Triple Dmg, Ignores Defense -- Darkness/Distortion
sets.precast.WS['Quietus'] = set_combine(sets.precast.WS, {
	right_ear="Heath. Earring +2",
	})	
	
	sets.precast.WS['Quietus'].Acc = set_combine(sets.precast.WS['Quietus'], {
	})

	sets.precast.WS['Quietus'].AtkCap = set_combine(sets.precast.WS['Quietus'], {
	    --head="Heath. Bur. +3",
		feet="Sakpata's Leggings",
		left_ring="Sroda Ring",
	})	
	sets.precast.WS['Quietus'].Dom = set_combine(sets.precast.WS['Quietus'], { 	
		feet="Hervor Sollerets",	
		})
	
-- Resolution - FTP .71, 1.5, 2.25, - STR 85% Multi Hit -- Fragmentation/Scission
sets.precast.WS['Resolution'] = {
	--1202acc--
    ammo="Crepuscular Pebble",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Ig. Gauntlets +3",
    legs="Ig. Flanchard +3",
    feet="Sakpata's Leggings",
    neck="Abyssal Beads +2",
    waist="Sailfi Belt +1",
    left_ear="Moonshade Earring",
    right_ear="Heath. Earring +2",
    left_ring="Sroda Ring",
    right_ring="Ephramad's Ring",
	back=gear.DRKcape_DBLATKstr,
		}
sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS['Resolution'], { 
	--1243acc
    head="Ignominy Burgeonet +3",
    feet="Flam. Gambieras +2",
	--left_ear="Zwazo Earring +1",
	right_ear="Telos Earring",
		})

sets.precast.WS['Resolution'].AtkCap = set_combine(sets.precast.WS['Resolution'], { 
	--1304acc
    head="Heath. Bur. +3",
		})			
		
-- Torcleaver - FTP 4.75, 7.5, 10, - VIT 80% -- Light/Distortion
sets.precast.WS['Torcleaver'] = set_combine(sets.precast.WS, {
	--waist="Fotia Belt",
    --back=gear.DRKcape_WSDvit,
	})	 
		
sets.precast.WS['Torcleaver'].Acc = set_combine(sets.precast.WS['Torcleaver'], {
	head="Sakpata's Helm",
	body="Ignominy Cuirass +3",
	hands="Sakpata's Gauntlets",
	left_ring="Beithir Ring",
	right_ring="Regal Ring",
		})

sets.precast.WS['Torcleaver'].AtkCap = set_combine(sets.precast.WS['Torcleaver'], {
    head="Heath. Bur. +3",
    --body="Sakpata's Plate",
	--hands="Sakpata's Gauntlets",
	--legs="Sakpata's Cuisses",
	left_ring="Sroda Ring",
		})
sets.precast.WS['Torcleaver'].Dom = set_combine(sets.precast.WS['Torcleaver'], { 	
	feet="Hervor Sollerets",	
		})
-- Scourge - FTP 3.0, - STR 40% VIT 40% -- Light/Fusion
	sets.precast.WS['Scourge'] = sets.precast.WS['Torcleaver']
	sets.precast.WS['Scourge'].Acc = sets.precast.WS['Torcleaver'].Acc
	sets.precast.WS['Scourge'].AtkCap = sets.precast.WS['Torcleaver'].AtkCap
	
    sets.precast.WS['Armor Break'] = set_combine(sets.precast.WS, {
		ammo="Seeth. Bomblet +1",
		head="Heath. Bur. +3",  
		body="Heath. Cuirass +3", 
		hands="Heath. Gauntlets +3", 
		legs="Heath. Flanchard +3", 
		feet="Heath. Sollerets +3",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Crep. Earring",
		right_ear="Heath. Earring +2",
		left_ring="Metamorph Ring +1",
		right_ring="Stikini Ring +1",
		back=gear.DRKcape_FstCst,
	})

--My Customs
sets.RR = {
	head="Crepuscular Helm",
	body="Crepuscular Mail",
}
	
sets.Lugra = {left_ear="Lugra Earring +1"}

sets.maxTP = {left_ear="Thrud Earring"}

sets.LowTP = {waist = "Fotia Belt"}
	
sets.Anguta = {
	main = "Anguta",
	sub = "Utu Grip",
}

sets.Apocalypse = {
	main= "Apocalypse",
	sub= "Utu Grip",
}

sets.Foenaria = {
	main= "Foenaria",
	sub= "Utu Grip",
}

sets.Caladbolg = {
	main = "Caladbolg",
	sub = "Utu Grip",
}	

sets.Lib = {
	main = "Liberator",
	sub = "Utu Grip",
}	

sets.Ragnarok = {
	main="Ragnarok",
	sub="Utu Grip",
	}
	
sets.GAxe = {
	main="Lycurgos",
	sub="Utu Grip",
	}
	
sets.Club = {
	main="Loxotic Mace +1",
	sub="Blurred Shield +1",
	}

sets.Sword = {
	main="Naegling",
	sub="Blurred Shield +1",
	}
	
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Echo Drops" <me>')
		
		--[[
		elseif spell.type == "WeaponSkill" and spell.target.distance > 5 and player.status == 'Engaged' then -- Cancel WS If You Are Out Of Range --
		cancel_spell()
		add_to_chat(123, spell.name..' Canceled: [Out of Range]')
		return
		]]
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
	-- Make sure abilities using head gear don't swap 
    if spell.type:lower() == 'weaponskill' then
        if player.tp > 2000 then
            equip(sets.maxTP)
		else
		-- use Lugra + moonshade
		--[[if world.time >= (17*60) or world.time <= (7*60) then
			equip(sets.Lugra)
			
		else
			-- do nothing.
	]]
        end
    end
end


-- Job-specific hooks for standard casting events.
function job_midcast(spell, action, spellMap, eventArgs)
 
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if spellMap == 'Cure' and spell.target.type == 'SELF' then
		equip(sets.midcast.CureSelf)
	end
	if buffactive['Dark Seal'] and S{"Drain III"}:contains(spell.english)then
        equip({head="Fall. Burgeonet +3"})
    end
	if spell.english == "Scarlet Delirium" then 
		equip(sets.precast['Scarlet Delirium'])
	end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
 
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
	if spell.english == "Scarlet Delirium" then 
		equip(sets.precast['Scarlet Delirium'])
	end
end

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

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)

    if player.mpp < 51 then

        idleSet = set_combine(idleSet, sets.latent_refresh)

    end

    return idleSet

end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	if state.Buff.Souleater then
		meleeSet = set_combine(meleeSet, sets.Souleater)
	end
	if state.Buff['Doom'] or state.Buff['Curse'] then
		meleeSet = set_combine(meleeSet, sets.Doom)
	end
    if state.Buff['Last Resort'] then 
		meleeSet = set_combine(meleeSet, sets['Last Resort'])
    end 
	--[[if player.sub_job == 'SAM' and (not state.Buff['Hasso'] and not state.Buff['Seigan']) then 
		send_command('@input /ja Hasso')
	end]]
	return meleeSet
end


---------------------------------------------------------------------
-- General hooks for other events.
---------------------------------------------------------------------

-- Called when the player's status changes.
--function job_status_change(newStatus, oldStatus, eventArgs)

--end

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    end
	if buff == "Souleater" then
        handle_equipping_gear(player.status)
    end
	if buff == "Doom" or buff == "Curse" then
		if gain then
			equip(sets.doom)
		else
			handle_equipping_gear(player.status)
		end
	end
	if buff == "Nether Void" and buff == "Dark Seal" then
		if gain then
			send_command('input /ma drain3 <t>')
		else
			handle_equipping_gear(player.status)
		end
	end	
end

----------------------------------------------------------------------
-- User code that supplements self-commands.
-----------------------------------------------------------------------

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
----------------------------------------------------------------------
-- Utility functions specific to this job.
-----------------------------------------------------------------------
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
	if state.RR.value == 'true' then 
		equip(sets.RR)
		disable('head', 'body')
		else 
		enable('head', 'body')
	end
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
	if spell.skill == 'Dark Magic' and Absorbs:contains(spell.english) then
		return 'Absorb'
	end

	if spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' then
		if LowTierNuke:contains(spell.english) then
			return 'LowTierNuke'
		else
			return 'HighTierNuke'
		end
	end
end

function select_earring()
    if world.time >= (17*60) or world.time <= (7*60) then
        return sets.Lugra
    else
        -- do nothing
    end
end

function update_melee_groups()

end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(1, 9)
    elseif player.sub_job == 'RDM' then
        set_macro_page(1, 9)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 9)
    elseif player.sub_job == 'THF' then
        set_macro_page(1, 9)
    else
        set_macro_page(1, 9)
    end
end

function set_lockstyle()
	send_command('wait 8; input /lockstyleset 104 ')
end


windower.raw_register_event('incoming chunk', function(id,original,modified,injected,blocked)
    local self = windower.ffxi.get_player()
	    if player.status ~= 'Engaged' then
		wsnum = 0   

		--------------------- Add Auto WS LIst not on or whatever
	end
    if id == 0x028 then
        local packet = packets.parse('incoming', original)
        local category = packet['Category']
        if packet.Actor == self.id and category == 1 and state.AutoWS.value == 'true' then
			
			if state.AutoWSList.value == 'Cata' and player.tp >= 1000 and wsnum == 0 then
                    send_command('input /ws Catastrophe <t>')
                    wsnum = 0
			end
			
			if state.AutoWSList.value == 'Torc' and player.tp >= 1000 and wsnum == 0 then
                    send_command('input /ws Torcleaver <t>')
                    wsnum = 0
			end
				
			if state.AutoWSList.value == 'Apoc5Dark' and player.tp >= 1000 and wsnum == 0 then
                    send_command('input /ws Cross Reaper <t>')
                    wsnum = wsnum + 1
 
                elseif state.AutoWSList.value == 'Apoc5Dark' and player.tp >= 1000 and wsnum == 1 then 
                    send_command('input /ws Insurgency <t>')
                    wsnum = wsnum + 1
 
                elseif state.AutoWSList.value == 'Apoc5Dark' and player.tp >= 1000 and wsnum == 2 then
                    send_command('input /ws Entropy <t>')
                    wsnum = wsnum + 1
 
                elseif state.AutoWSList.value == 'Apoc5Dark' and player.tp >= 1000 and wsnum == 3 then
                    send_command('input /ws Cross Reaper  <t>')
                    wsnum = wsnum + 1
               
			    elseif state.AutoWSList.value == 'Apoc5Dark' and player.tp >= 1000 and wsnum == 4 then
                    send_command('input /ws Catastrophe  <t>')
                    wsnum = 0
					add_to_chat(100," WS #0 nigga")
				end
			
			if state.AutoWSList.value == 'Apoc2Dark' and player.tp >= 1000 and wsnum == 0 then
                    send_command('input /ws Catastrophe  <t>')
                    wsnum = wsnum + 1	
				elseif state.AutoWSList.value == 'Apoc2Dark' and player.tp >= 1000 and wsnum == 1 then
                    send_command('input /ws Cross Reaper  <t>')
                    wsnum = wsnum +1	
				elseif state.AutoWSList.value == 'Apoc2Dark' and player.tp >= 1000 and wsnum == 2 then
                    send_command('input /ws Catastrophe  <t>')
                    wsnum = 0						

				end	
				end
			end
		end)