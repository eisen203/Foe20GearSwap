-- Original: Motenten / Modified: Arislan

-- Haste/DW Detection Requires Gearinfo Addon



-------------------------------------------------------------------------------------------------------------------

--  Keybinds

-------------------------------------------------------------------------------------------------------------------



--  Modes:      [ F9 ]              Cycle Offense Mode

--              [ CTRL+F9 ]         Cycle Hybrid Modes

--              [ WIN+F9 ]          Cycle Weapon Skill Modes

--              [ F10 ]             Emergency -PDT Mode

--              [ ALT+F10 ]         Toggle Kiting Mode

--              [ F11 ]             Emergency -MDT Mode

--              [ CTRL+F11 ]        Cycle Casting Modes

--              [ F12 ]             Update Current Gear / Report Current Status

--              [ CTRL+F12 ]        Cycle Idle Modes

--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode

--              [ ALT+F9 ]           Toggle Magic Burst Mode

--              [ WIN+C ]           Toggle Capacity Points Mode

--				[ ALT+W ] 			Toggle Weapon Lock Mode

--				SPELL ELEMENT CYCLES

--				CNTRL+1/2		Toggle GainSpell

--				CNTRL+q/w 		Toggle EnSpell

--				CNTRL+a/s		Toggle BarElement

--				CNTRL+z/x		Toggle BarStatus

--              (Global-Binds.lua contains additional non-job-related keybinds)





-------------------------------------------------------------------------------------------------------------------

-- Setup functions for this job.  Generally should not be modified.

-------------------------------------------------------------------------------------------------------------------



--              Addendum Commands:

--              Shorthand versions for each strategem type that uses the version appropriate for

--              the current Arts.

--                                          Light Arts                  Dark Arts

--                                          ----------                  ---------

--              gs c scholar light          Light Arts/Addendum

--              gs c scholar dark                                       Dark Arts/Addendum

--              gs c scholar cost           Penury                      Parsimony

--              gs c scholar speed          Celerity                    Alacrity

--              gs c scholar aoe            Accession                   Manifestation

--              gs c scholar addendum       Addendum: White             Addendum: Black





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

    state.Buff.Saboteur = buffactive.Saboteur or false

    state.Buff.Stymie = buffactive.Stymie or false
	
	state.Buff.Composure = buffactive.Composure or false



    enfeebling_magic_acc = S{'Dispel', 'Distract', 'Distract II', 'Frazzle',

        'Frazzle II'}

    enfeebling_magic_skill = S{'Distract III', 'Frazzle III', 'Poison II'}

    enfeebling_magic_effect = S{'Gravity', 'Gravity II',}

	enfeebling_magic_dur = S{'Sleep', 'Sleepga', 'Sleep II', 'Break', 'Bind', 'Dia', 'Dia II', 'Dia III', 'Diaga', 'Silence'}

    skill_spells = S{

        'Temper', 'Temper II', 'Enfire', 'Enfire II', 'Enblizzard', 'Enblizzard II', 'Enaero', 'Enaero II',

        'Enstone', 'Enstone II', 'Enthunder', 'Enthunder II', 'Enwater', 'Enwater II'}



    lockstyleset = 58
	
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

		packets = require('packets')

    state.OffenseMode:options('Normal', 'Midacc', 'SubtleBlow', 'Enspell')

    state.HybridMode:options('Normal', 'DT')

    state.WeaponskillMode:options('Normal', 'Acc', 'Weather')

    state.CastingMode:options('Normal', 'Burst')

    state.IdleMode:options('Normal', 'DT')


	state.WeaponSet = M{['description']='Weapon Set', 'Crocea_Shield', 'Crocea_Gleti', 'Crocea_Daybreak', 'Crocea_Bunzi', 'Crocea_TP', 'Naegling_TP', "Gleti_Thib", 'Gleti_Daybreak', 'Mandau_Gleti', 'noTPfeed', 'Maxentius_Gleti', 'Maxentius_Thib'}


    state.EnSpell = M{['description']='EnSpell', 'Enfire', 'Enblizzard', 'Enaero', 'Enstone', 'Enthunder', 'Enwater'}

    state.BarElement = M{['description']='BarElement', 'Barfire', 'Barblizzard', 'Baraero', 'Barstone', 'Barthunder', 'Barwater'}

    state.BarStatus = M{['description']='BarStatus', 'Baramnesia', 'Barvirus', 'Barparalyze', 'Barsilence', 'Barpetrify', 'Barpoison', 'Barblind', 'Barsleep'}

    state.GainSpell = M{['description']='GainSpell', 'Gain-STR', 'Gain-INT', 'Gain-AGI', 'Gain-VIT', 'Gain-DEX', 'Gain-MND', 'Gain-CHR'}

	wsnum = 0

	state.AutoWS = M{['description']='Auto WS','OFF','true'}
	send_command('bind @z gs c cycle AutoWS')
    state.AutoWSList = M{['description']='Auto WS List', 'OFF', 'Sanguine', 'Halo', 'Savage', 'Vagary6step'}
	send_command('bind @x gs c cycle AutoWSList')


    state.WeaponLock = M(false, 'Weapon Lock')

    state.MagicBurst = M(false, 'Magic Burst')

    state.NMmode = M(false, 'NMmode')
	send_command('bind @n gs c cycle NMmode')

    state.CP = M(false, "Capacity Points Mode")

    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then

    send_command('lua l gearinfo')

    end

	send_command('lua l partybuffs')
	
    -- Additional local binds

    --include('Global-Binds.lua') -- OK to remove this line

    --include('Global-GEO-Binds.lua') -- OK to remove this line
	
    send_command('bind !f11 gs c toggle MagicBurst')

    send_command('bind ^q gs c cycleback EnSpell')

    send_command('bind ^w gs c cycle EnSpell')

    send_command('bind ^1 gs c cycleback GainSpell')

    send_command('bind ^2 gs c cycle GainSpell')

    send_command('bind ^a gs c cycleback BarElement')

    send_command('bind ^s gs c cycle BarElement')

    send_command('bind ^z gs c cycleback BarStatus')

    send_command('bind ^x gs c cycle BarStatus')

    send_command('bind !c gs c toggle CP')
	
	
	send_command('bind @w gs c toggle WeaponLock')


    select_default_macro_book()

    set_lockstyle()

	include('organizer-lib')

	organizer_items = {
		echos="Echo Drops",
		shihei="Shihei",
	}
	
	Haste = 0

    DW_needed = 0

    DW = false

    moving = false

    update_combat_form()

    determine_haste_group()

end



-- Called when this job file is unloaded (eg: job change)

function user_unload()

    send_command('unbind ^`')

    send_command('unbind !`')

    send_command('unbind ^-')

    send_command('unbind ^=')

    send_command('unbind !-')

    send_command('unbind !=')

    send_command('unbind ^;')

    send_command('unbind ![')

    send_command('unbind !;')

    send_command('unbind !q')

    send_command('unbind !w')

    send_command('unbind !e')

    send_command('unbind !r')

    send_command('unbind !y')

    send_command('unbind !o')

    send_command('unbind !p')

    send_command('unbind @w')

    send_command('unbind @c')
	
	send_command('unbind @z')
	
	send_command('unbind @x')

    send_command('unbind ^r')
	
	send_command('unbind ^e')

    send_command('unbind !insert')

    send_command('unbind !delete')

    send_command('unbind ^insert')

    send_command('unbind ^delete')

    send_command('unbind ^home')

    send_command('unbind ^end')

    send_command('unbind ^pageup')

    send_command('unbind ^pagedown')

    send_command('unbind ^numpad7')

    send_command('unbind ^numpad9')

    send_command('unbind ^numpad4')

    send_command('unbind ^numpad1')

    send_command('unbind ^numpad2')

	send_command('unbind ^,')

	send_command('unbind ^.')

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

	sets.TreasureHunter = { 
		hands=gear.Merlinic.Hands_TH,
		feet=gear.Merlinic.Feet_TH, 
		waist="Chaac Belt",
		}

sets.Enmity = {
    ammo="Sapience Orb",
    head="Halitus Helm",
    body="Emet Harness +1",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Unmoving Collar +1",
    waist="Flume Belt",
    left_ear="Friomisi Earring",
    right_ear="Cryptic Earring",
    left_ring="Supershear Ring",
    right_ring="Eihwaz Ring",
    back="Reiki Cloak",
	}
	
    -- Precast sets to enhance JAs

    sets.precast.JA['Chainspell'] = {body="Viti. Tabard +3"}
	sets.precast.JA['Animated Flourish'] = sets.Enmity
	sets.precast.JA['Provoke'] = sets.Enmity
	sets.precast.JA['Warcry'] = sets.Enmity


    -- Fast cast sets for spells
--need 50 in gear to cap
sets.precast.FC = {
	ammo="Ghastly Tathlum +1",
    head="Atrophy Chapeau +3", --16
    body="Viti. Tabard +3",  --13
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet=gear.Merlinic.Feet_FC,  --11
    neck="Loricate Torque +1", 
    waist="Luminary Sash",
    left_ear="Malignance Earring", --4
    right_ear="Lethargy Earring +1",  --8
    left_ring="Defending Ring",
    right_ring="Gelatinous Ring +1", 
    back=gear.RDMcape_MND, 
} --total 52



    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
		sub="Ammurapi Shield",
		waist="Siegel Sash"
		})



    sets.precast.FC.Cure = set_combine(sets.precast.FC, {

        })



    sets.precast.FC.Curaga = sets.precast.FC.Cure

    sets.precast.FC['Healing Magic'] = sets.precast.FC.Cure

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {})



    sets.precast.FC.Impact = set_combine(sets.precast.FC, {
    ammo="Sapience Orb",
	head=empty,
    body="Twilight Cloak",
    hands="Leyline Gloves",
    neck="Voltsurge Torque",
    left_ring="Prolix Ring",
        })



    sets.precast.FC['Dispelga'] = set_combine(sets.precast.FC, {main="Daybreak"})

    sets.precast.Storm = set_combine(sets.precast.FC, {})

    sets.precast.FC.Utsusemi = sets.precast.FC





    ------------------------------------------------------------------------------------------------

    ------------------------------------- Weapon Skill Sets ----------------------------------------

    ------------------------------------------------------------------------------------------------



sets.precast.WS = {
	ammo="Oshasha's Treatise",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Sherida Earring",
    right_ear="Moonshade Earring",
    left_ring="Ephramad's Ring",
    right_ring="Epaminondas's Ring",
    back=gear.RDMcape_WSD, 
	}


    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
		range="Ullr",
		ammo="",
        })

	sets.precast.WS.Atk = set_combine(sets.precast.WS, {
	})

	sets.precast.WS.Proc = {}

sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
    ammo="Yetshila +1",
	head="Blistering Sallet +1",
	body="Malignance Tabard",
	hands="Malignance Gloves",
	legs="Viti. Tights +3",
    feet="Thereoid Greaves",
	waist="Sailfi Belt +1",
    left_ear="Sherida Earring",
    right_ear="Mache Earring +1",
    left_ring="Ephramad's Ring",
    right_ring="Ilabrat Ring",
    back=gear.RDMcape_CDC, 
	})



    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS['Chant du Cygne'], {
		range="Ullr",
		ammo="",
        })

    sets.precast.WS['Chant du Cygne'].Atk = set_combine(sets.precast.WS['Chant du Cygne'], {
		head="Vitiation Chapeau +3",
		body="Vitiation Tabard +3",
		hands="Vitiation Gloves +3",
        })

    sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']

    sets.precast.WS['Vorpal Blade'].Acc = sets.precast.WS['Chant du Cygne'].Acc

	sets.precast.WS['Vorpal Blade'].Atk = sets.precast.WS['Chant du Cygne'].Atk

sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
	--hands="Atrophy Gloves +3",
	neck="Rep. Plat. Medal",
	waist="Sailfi Belt +1",
	})



    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
		range="Ullr",
		ammo="",
        neck="Combatant's Torque",
        waist="Sailfi Belt +1",
        })

    sets.precast.WS['Savage Blade'].Atk = set_combine(sets.precast.WS['Savage Blade'], {
        neck="Combatant's Torque",
		left_ring="Ilabrat Ring",
        })

    sets.precast.WS['Death Blossom'] = sets.precast.WS['Savage Blade']

    sets.precast.WS['Death Blossom'].Acc = sets.precast.WS['Savage Blade'].Acc

	sets.precast.WS['Death Blossom'].Atk = sets.precast.WS['Savage Blade'].Atk
	
    sets.precast.WS['Circle Blade'] = sets.precast.WS['Savage Blade']

    sets.precast.WS['Circle Blade'].Acc = sets.precast.WS['Savage Blade'].Acc

	sets.precast.WS['Circle Blade'].Atk = sets.precast.WS['Savage Blade'].Atk


sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
    right_ring="Ilabrat Ring",
        })



    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {
		range="Ullr",
		ammo="",
        neck="Combatant's Torque",
        })

    sets.precast.WS['Requiescat'].Atk = set_combine(sets.precast.WS['Requiescat'], {

       --[[ neck="Combatant's Torque",

        ear1="Mache Earring +1",

        ring1="Ramuh Ring +1",

        waist="Sailfi Belt +1",]]

        })


sets.precast.WS['Sanguine Blade'] = {  -- amalric+1 body, legs, feet has 175 before set bonus wich is 205 and 75 mnd total and 109INT
    ammo="Sroda Tathlum",
	--ammo="Ghastly Tathlum +1",
    head="Pixie Hairpin +1",
    body="Nyame Mail",
	--body="Amalric Doublet +1",
	--="Nyame Gauntlets",
	hands="Leth. Ganth. +3",
	--hands="Amalric Gages +1",
    legs="Nyame Flanchard",
	--legs="Amalric Slops +1",
    feet="Leth. Houseaux +3",
    neck="Dls. Torque +2",
    waist="Orpheus's Sash",
	--waist="Skrymir Cord",
    left_ear="Regal Earring", --4
    right_ear="Malignance Earring",  --8
    left_ring="Archon Ring",
    right_ring="Epaminondas's Ring",
    back=gear.RDMcape_MND,
        }

    sets.precast.WS['Sanguine Blade'].Weather = set_combine(sets.precast.WS['Sanguine Blade'], {
		waist="Hachirin-no-Obi",
        })


sets.precast.WS['Seraph Blade'] = set_combine(sets.precast.WS['Sanguine Blade'], {
    --head="Viti. Chapeau +3",
	head="Nyame Helm",
	--right_ear="Moonshade Earring",
	left_ring="Freke Ring",
        })

    sets.precast.WS['Seraph Blade'].Weather = set_combine(sets.precast.WS['Seraph Blade'], {
		waist="Hachirin-no-Obi",
        })
		
sets.precast.WS['Shining Blade'] = set_combine(sets.precast.WS['Sanguine Blade'], {
    --head="Viti. Chapeau +3",
	head="Nyame Helm",
	--right_ear="Moonshade Earring",
	left_ring="Freke Ring",
        })

    sets.precast.WS['Shining Blade'].Weather = set_combine(sets.precast.WS['Seraph Blade'], {
		waist="Hachirin-no-Obi",
        })

sets.precast.WS['Burning Blade'] = set_combine(sets.precast.WS['Sanguine Blade'], {
    --head="Viti. Chapeau +3",
	head="Nyame Helm",
	--right_ear="Moonshade Earring",
	left_ring="Freke Ring",
	back=gear.RDMcape_WSDint,
        })

    sets.precast.WS['Burning Blade'].Weather = set_combine(sets.precast.WS['Seraph Blade'], {
		waist="Hachirin-no-Obi",
        })

sets.precast.WS['Red Lotus Blade'] = set_combine(sets.precast.WS['Sanguine Blade'], {
    --head="Viti. Chapeau +3",
	head="Nyame Helm",
	--right_ear="Moonshade Earring",
	left_ring="Freke Ring",
	back=gear.RDMcape_WSDint,
        })

    sets.precast.WS['Red Lotus Blade'].Weather = set_combine(sets.precast.WS['Seraph Blade'], {
		waist="Hachirin-no-Obi",
        })

sets.precast.WS['Mercy Stroke'] = set_combine(sets.precast.WS, {
	ammo="Coiste Bodhar",
	neck="Rep. Plat. Medal",
	--neck="Fotia Gorget",
	waist="Sailfi Belt +1",
    right_ear="Ishvara Earring",
    left_ring="Ephramad's Ring",
    right_ring="Epaminondas's Ring",
    back=gear.RDMcape_WSD, 
})

sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Sanguine Blade'], {
	head="Nyame Helm",
	--right_ear="Moonshade Earring",
	left_ring="Freke Ring",
	back=gear.RDMcape_WSDint,
		})
		
    sets.precast.WS['Aeolian Edge'].Weather = set_combine(sets.precast.WS['Aeolian Edge'], {
		waist="Hachirin-no-Obi",
        })

sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS['Savage Blade'], {
	
	})



sets.precast.WS['Black Halo'].Acc = set_combine(sets.precast.WS['Black Halo'], {
		range="Ullr",
		ammo="",
	})
	
sets.precast.WS['Empyreal Arrow'] = {
	head="Nyame Helm",
	body="Nyame Mail",
	hands="Nyame Gauntlets",
	legs="Nyame Flanchard",
	feet="Nyame Sollerets",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Telos Earring",
    right_ear="Enervating Earring",
    left_ring="Hajduk Ring",
    right_ring="Cacoethic Ring +1",
	back=gear.RDMcape_RACC,
}





    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Midcast Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------



    sets.midcast.FastRecast = sets.precast.FC



    sets.midcast.SpellInterrupt = {

    --sub="Sacro Bulwark", 
	--ammo="Staunch Tathlum", --10
	body="Ros. Jaseran +1", --25
	hands=gear.Chironic.Hands_MACC_MND, --20
	legs="Carmine Cuisses +1", --20
	feet="Amalric Nails +1", --15
	--ear1="Halasz Earring",
	-- ring1="Freke Ring",
	--left_ring="Evanescence Ring", 
	waist="Emphatikos Rope", --12

        }


sets.midcast.Cure = {
    head="Vanya Hood", --10
    body="Bunzi's Robe", --15
    --hands="Kaykaus Cuffs +1", --11
    legs="Atrophy Tights +3", --12
    --feet="Kaykaus Boots", --10
    neck="Phalaina Locket", --4
    waist="Luminary Sash",
    left_ear="Malignance Earring",
    right_ear="Mendi. Earring", --5
    left_ring="Defending Ring",
    right_ring="Gelatinous Ring +1",
    back="Ghostfyre Cape", --6
	}
	

sets.midcast.CureWeather = set_combine(sets.midcast.Cure, {
        waist="Hachirin-no-Obi",
    })



sets.midcast.CureSelf = set_combine(sets.midcast.Cure, {
	neck="Phalaina Locket", -- 4(4)
	waist="Gishdubar Sash", -- (10)
	})



    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
        })



sets.midcast.StatusRemoval = {

}
        



sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
	--hands="Hieros Mittens",
	})



sets.midcast['Enhancing Magic'] = {
	main="Pukulatmuj +1",
	sub="Ammurapi Shield",
    head=gear.Telchine.Head_dur,
    body="Viti. Tabard +3", 
    hands="Atrophy Gloves +3",
    legs=gear.Telchine.Legs_dur,
    feet="Leth. Houseaux +3",
    neck="Dls. Torque +2",
    waist="Embla Sash",
    left_ear="Mimir Earring",
    right_ear="Lethargy Earring +1",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Ghostfyre Cape",
	}

sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'], {
       })


sets.midcast.EnhancingSkill = set_combine(sets.midcast['Enhancing Magic'], {
	sub="Forfend +1",
	head="Befouled Crown",
	hands="Viti. Gloves +3",
	legs="Atrophy Tights +3",
	neck="Incanter's Torque",
	waist="Olympus Sash",
	right_ear="Andoaa Earring",
	   })

sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {
	body=gear.Telchine.Body_dur,
	feet="Bunzi's Sabots",
        })

sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
	head="Amalric Coif +1", -- +2
	body="Atrophy Tabard +3", -- +2
	legs="Leth. Fuseau +3", -- +4
	})



sets.midcast.RefreshSelf = set_combine(sets.midcast.Refresh, {
	waist="Gishdubar Sash",
	--back="Grapevine Cape"
	})



sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
	neck="Nodens Gorget",
	waist="Siegel Sash",
	left_ear="Earthcry Earring",
	})



sets.midcast['Phalanx'] = set_combine(sets.midcast['Enhancing Magic'], {
    head=gear.Taeon.Head_PHLX,
    body=gear.Taeon.Body_PHLX,
    hands=gear.Taeon.Hands_PHLX,
    legs=gear.Taeon.Legs_PHLX,
    feet=gear.Taeon.Feet_PHLX,
	})

sets.midcast['Haste II'] = sets.midcast.EnhancingDuration
       

sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {
	head="Amalric Coif +1",
	--ammo="Staunch Tathlum",
	--hands=gear.Chironic.Hands_MACC_MND,
	--legs="Carmine Cuisses +1",
	--feet="Amalric Nails +1",
	--ear1="Halasz Earring",
	-- ring1="Freke Ring",
	--left_ring="Evanescence Ring",
	waist="Emphatikos Rope",

        })



    sets.midcast.Storm = sets.midcast.EnhancingDuration

sets.midcast.GainSpell = {
	hands="Viti. Gloves +3",
	}

    sets.midcast.SpikesSpell = {legs="Viti. Tights +3"}



sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {
	--ring2="Sheltered Ring"
	})

    sets.midcast.Protectra = sets.midcast.Protect

    sets.midcast.Shell = sets.midcast.Protect

    sets.midcast.Shellra = sets.midcast.Shell





     -- Custom spell classes

sets.midcast.MndEnfeebles = {
	--main="Crocea Mors",
	--main="Daybreak",
	main="Bunzi's Rod",
	sub="Ammurapi Shield",
    ammo="Regal Gem",
    head="Viti. Chapeau +3",
    body="Lethargy Sayon +3",
    hands="Regal Cuffs",
	--hands="Leth. Ganth. +3",
    legs=gear.Chironic.Legs_MACC_INT,
	--legs="Leth. Fuseau +3",
    feet="Leth. Houseaux +3",
    neck="Dls. Torque +2",
    waist="Obstin. Sash",
    left_ear="Snotra Earring",
    right_ear="Lethargy Earring +1",
    left_ring="Metamorph Ring +1",
    right_ring="Kishar Ring",
    back=gear.RDMcape_MND,
	}



sets.midcast.MndEnfeeblesAcc = set_combine(sets.midcast.MndEnfeebles, {
	--range="Ullr",
	ammo="Regal Gem",
	--head="Atrophy Chapeau +3",
	body="Atrophy Tabard +3",
	hands="Leth. Ganth. +3",
	right_ring="Stikini Ring +1",
	})
	
sets.midcast.IntEnfeebles = {
	--main="Crocea Mors",
	main="Bunzi's Rod",
	--sub="Bunzi's Rod",
	sub="Ammurapi Shield",
    ammo="Regal Gem",
    head="Viti. Chapeau +3",
    body="Lethargy Sayon +3",
    hands="Regal Cuffs",
	--hands="Leth. Ganth. +3",
    legs=gear.Chironic.Legs_MACC_INT,
	--legs="Leth. Fuseau +3",
    feet="Leth. Houseaux +3",
    neck="Dls. Torque +2",
    waist="Obstin. Sash",
    left_ear="Snotra Earring",
    right_ear="Lethargy Earring +1",
    left_ring="Metamorph Ring +1",
    right_ring="Kishar Ring",
	back=gear.RDMcape_INT,
    }


sets.midcast.IntEnfeeblesAcc = set_combine(sets.midcast.IntEnfeebles, {
	--range="Ullr",
	ammo="Regal Gem",
	--head="Atrophy Chapeau +3",
	--body="Atrophy Tabard +3",
	hands="Leth. Ganth. +3",
	--waist="Sacro Cord",
	right_ring="Stikini Ring +1",
	})

sets.midcast.SkillEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
		--main="Contemplator +1", 
		--sub="Enki Strap",
		--body="Atrophy Tabard +3",
		hands="Leth. Ganth. +3",
		legs=gear.Chironic.Legs_MACC_INT,
        --feet="Vitiation Boots +3",
        --neck="Incanter's Torque",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
	})

sets.midcast.EffectEnfeebles = set_combine(sets.midcast.IntEnfeebles, {
		ammo="Regal Gem",
		body="Lethargy Sayon +3",
		feet="Vitiation Boots +3",
        })

sets.midcast.DurEnfeebles = set_combine(sets.midcast.IntEnfeebles, {
    body="Lethargy Sayon +3",
	--hands="Leth. Ganth. +3",
	legs="Leth. Fuseau +3",
	feet="Leth. Houseaux +3",
	right_ring="Kishar Ring",
        })
		
sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles

sets.midcast.ElementalEnfeeble.Acc = sets.midcast.IntEnfeebles.Acc

sets.midcast.Dispelga = set_combine(sets.midcast.IntEnfeeblesAcc, {main="Daybreak", sub="Ammurapi Shield"})





sets.midcast['Blind II'] = set_combine(sets.midcast.IntEnfeebles, sets.midcast.EffectEnfeebles)
sets.midcast['Blind II'].Acc = set_combine(sets.midcast.IntEnfeebles.Acc, sets.midcast.EffectEnfeebles.Acc)

	
sets.midcast['Dia III'] = {}--set_combine(sets.midcast.MndEnfeebles, sets.midcast.EffectEnfeebles, {head="Viti. Chapeau +3"})

sets.midcast['Dia II'] = set_combine(sets.midcast.MndEnfeebles, sets.midcast.EffectEnfeebles)
	

sets.midcast['Dark Magic'] = {
	main="Crocea Mors",
	sub="Ammurapi Shield",
    ammo="Pemphredo Tathlum",
    head="Atrophy Chapeau +3",
    body="Carm. Sc. Mail +1", 
    hands="Leth. Ganth. +3",
    legs="Leth. Fuseau +3",
    feet="Leth. Houseaux +3",
    neck="Erra Pendant",
    waist="Casso Sash",
    left_ear="Malignance Earring",
    right_ear="Regal Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back=gear.RDMcape_INT,
	}


sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head="Pixie Hairpin +1",
        waist="Fucho-no-obi",
		right_ring="Archon Ring",
        })



    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {waist="Luminary Sash"})

    sets.midcast['Bio III'] = set_combine(sets.midcast['Dark Magic'], {
})



sets.midcast['Elemental Magic'] = {
	main="Bunzi's Rod",
	sub="Ammurapi Shield",
    ammo="Ghastly Tathlum +1",
	head="Leth. Chappel +3",
	body="Lethargy Sayon +3",
	--body="Amalric Doublet +1",
	--hands="Amalric Gages +1",
	hands="Leth. Ganth. +3",
    --legs="Amalric Slops +1",
	legs="Leth. Fuseau +3",
    feet="Leth. Houseaux +3",
    neck="Dls. Torque",
    waist="Acuity Belt +1",
    left_ear="Malignance Earring",
    right_ear="Regal Earring",
    left_ring="Freke Ring",
    right_ring="Metamorph Ring +1",
    back=gear.RDMcape_INT,
	}

sets.midcast['Elemental Magic'].Burst = set_combine(sets.midcast['Elemental Magic'], {
	head="Ea Hat +1",
	body="Ea Houppe. +1",
	hands="Bunzi's Gloves",
	--legs="Ea Slops +1",
	--="Mizu. Kubikazari",
	})


sets.midcast['Elemental Magic'].Acc = set_combine(sets.midcast['Elemental Magic'], {
	--range="Ullr",
	})
	
sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
	ammo="Coiste Bodhar",
	head=empty,
	body="Twilight Cloak",
    body="Twilight Cloak",
    hands="Malignance Gloves",
	hands="Gazu Bracelets +1",
    legs="Perdition Slops",
    feet="Malignance Boots",
    neck="Anu Torque",
    waist="Oneiros Rope",
    left_ear="Dedition Earring",
    right_ear="Crepuscular Earring",
    left_ring="Crepuscular Ring",
    right_ring="Chirich Ring +1",
    back=gear.RDMcape_STP,
	})

sets.midcast.Utsusemi = set_combine(sets.midcast.SpellInterrupt, {
    head="Halitus Helm",
    --body="Emet Harness +1",
    --hands={ name="Merlinic Dastanas", augments={'Mag. Acc.+1','"Treasure Hunter"+1','Accuracy+19 Attack+19',}},
    neck="Unmoving Collar +1",
    left_ear="Friomisi Earring",
    right_ear="Cryptic Earring",
    left_ring="Eihwaz Ring",
    right_ring="Supershear Ring",
    back="Reiki Cloak",
	})



    -- Initializes trusts at iLvl 119

    sets.midcast.Trust = sets.precast.FC



    -- Job-specific buff sets

sets.buff.ComposureOther = {
	head="Leth. Chappel +3",
	legs="Leth. Fuseau +3",
	}

    sets.buff.Saboteur = {hands="Leth. Ganth. +3",}





    ------------------------------------------------------------------------------------------------

    ----------------------------------------- Idle Sets --------------------------------------------

    ------------------------------------------------------------------------------------------------



sets.idle = {
    head="Viti. Chapeau +3",
    body="Lethargy Sayon +3",
	--body="Zendik Robe",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Loricate Torque +1",
    waist="Flume Belt",
    left_ear="Infused Earring",
    right_ear="Etiolation Earring",
    left_ring="Defending Ring",
    right_ring="Shneddick Ring",
    back=gear.RDMcape_DW,
	}



sets.idle.DT = set_combine(sets.idle, {
    ammo="Staunch Tathlum",
    head="Nyame Helm",
    body="Nyame Mail",
	})



sets.idle.Town = set_combine(sets.idle, {
		head="Shaded Specs.",
		body="Goldsmith's Apron",
		neck="Goldsm. Torque",
		left_ring="Craftmaster's Ring",
        })



    sets.idle.Weak = sets.idle.DT



    sets.resting = set_combine(sets.idle, {
        })



    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Defense Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------



    sets.defense.PDT = sets.idle.DT

    sets.defense.MDT = sets.idle.DT



    sets.magic_burst = sets.midcast['Elemental Magic'].Seidr



    sets.Kiting = {right_ring="Shneddick Ring",}

    sets.latent_refresh = {waist="Fucho-no-obi"}





    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Engaged Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------



    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous

    -- sets if more refined versions aren't defined.

    -- If you create a set with both offense and defense modes, the offense mode should be first.

    -- EG: sets.engaged.Dagger.Accuracy.Evasion



sets.engaged = {
	ammo="Coiste Bodhar",
    head="Bunzi's Hat",
    --body="Ayanmo Corazza +2",
    body="Malignance Tabard",
	hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Crep. Earring",
    right_ear="Dedition Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back=gear.RDMcape_STP,
	}

    sets.engaged.MidAcc = set_combine(sets.engaged, {
    range="Ullr",
	ammo="Chapuli Arrow",
        })



    sets.engaged.SubtleBlow = set_combine(sets.engaged, {
		neck="Bathy Choker +1",
		left_ear="Sherida Earring",
		right_ear="Digni. Earring",
        })

    sets.engaged.Enspell = set_combine(sets.engaged, {
		ammo="Sroda Tathlum",
		hands="Aya. Manopolas +2",
		waist="Orpheus's Sash",
        })
		
    -- No Magic Haste (74% DW to cap)

sets.engaged.DW = {
	ammo="Coiste Bodhar",
    head="Bunzi's Hat",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
	feet="Malignance Boots",
    neck="Anu Torque",
    waist="Reiki Yotai", 
    left_ear="Dedition Earring",
    right_ear="Crep. Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back=gear.RDMcape_STP, --10
	} --11

    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW, {
	    range="Ullr",
		ammo="Chapuli Arrow",
        })



    sets.engaged.DW.SubtleBlow = set_combine(sets.engaged.DW, {
		neck="Bathy Choker +1",
		left_ear="Sherida Earring",
		right_ear="Digni. Earring",
        })
    
	sets.engaged.DW.Enspell = set_combine(sets.engaged.DW, {
	    range="Ullr",
		ammo="Chapuli Arrow",
		hands="Ayanmo Manopolas +2",
		legs="Viti. Tights +3",
		neck="Dls. Torque +2",
		waist="Orpheus's Sash",
		right_ear="Lethargy Earring +1",
		back=gear.RDMcape_DW,
        })

    -- 15% Magic Haste (67% DW to cap)

sets.engaged.DW.LowHaste = set_combine(sets.engaged.DW, {
	})

    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
		    range="Ullr",
			ammo="Chapuli Arrow",
        })


    sets.engaged.DW.SubtleBlow.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
		neck="Bathy Choker +1",
		left_ear="Sherida Earring",
		right_ear="Digni. Earring",
        })

    sets.engaged.DW.Enspell.LowHaste = sets.engaged.DW.Enspell
    
	-- 30% Magic Haste (56% DW to cap)

sets.engaged.DW.MidHaste = set_combine(sets.engaged.DW, {
	})
	
sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
		range="Ullr",
		ammo="Chapuli Arrow",
        })



    sets.engaged.DW.SubtleBlow.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
		neck="Bathy Choker +1",
		left_ear="Sherida Earring",
		right_ear="Digni. Earring",
        })

sets.engaged.DW.Enspell.MidHaste = sets.engaged.DW.Enspell


    -- 35% Magic Haste (51% DW to cap)

sets.engaged.DW.HighHaste = set_combine(sets.engaged.DW, {
	})

sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
		range="Ullr",
		ammo="Chapuli Arrow",
        })



    sets.engaged.DW.SubtleBlow.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
		neck="Bathy Choker +1",
		left_ear="Sherida Earring",
		right_ear="Digni. Earring",
        })

sets.engaged.DW.Enspell.HighHaste = sets.engaged.DW.Enspell
		
    -- 45% Magic Haste (36% DW to cap)

sets.engaged.DW.MaxHaste = set_combine(sets.engaged.DW , {
	
	})
		
		
		
sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
		range="Ullr",
		ammo="Chapuli Arrow",
        })



    sets.engaged.DW.SubtleBlow.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
		neck="Bathy Choker +1",
		left_ear="Sherida Earring",
		right_ear="Digni. Earring",
        })

sets.engaged.DW.Enspell.MaxHaste = sets.engaged.DW.Enspell

    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Hybrid Sets -------------------------------------------

    ------------------------------------------------------------------------------------------------



sets.engaged.Hybrid = set_combine(sets.engaged.DW, {
    --head="Malignance Chapeau",
    head="Bunzi's Hat",
    body="Malignance Tabard",
	--body="Nyame Mail",
    hands="Malignance Gloves",
    legs="Malignance Tights",
	--legs="Nyame Flanchard",
    --feet="Malignance Boots",
	feet="Nyame Sollerets",
	left_ring="Defending Ring", --10/10
		}) -- 50/50



    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)

    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)

    sets.engaged.SubtleBlow.DT = set_combine(sets.engaged.SubtleBlow, sets.engaged.Hybrid)



    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)

    sets.engaged.DW.MidAcc.DT = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)

    sets.engaged.DW.SubtleBlow.DT = set_combine(sets.engaged.DW.SubtleBlow, sets.engaged.Hybrid)



    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.MidAcc.DT.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.SubtleBlow.DT.LowHaste = set_combine(sets.engaged.DW.SubtleBlow.LowHaste, sets.engaged.Hybrid)



    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.MidAcc.DT.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.SubtleBlow.DT.MidHaste = set_combine(sets.engaged.DW.SubtleBlow.MidHaste, sets.engaged.Hybrid)



    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.MidAcc.DT.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.SubtleBlow.DT.HighHaste = set_combine(sets.engaged.DW.SubtleBlow.HighHaste, sets.engaged.Hybrid)



    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.DW.MidAcc.DT.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.DW.SubtleBlow.DT.MaxHaste = set_combine(sets.engaged.DW.SubtleBlow.MaxHaste, sets.engaged.Hybrid)





    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Special Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------



    sets.buff.Doom = {
		left_ring="Purity Ring",
        waist="Gishdubar Sash", --10
        }

		
	sets.midcast.Earth = {
		ammo="Ghastly Tathlum +1",		
		neck="Quanpur Necklace"
		}
	
	sets.DualINT = {
		sub="Bunzi's Rod",
	}
	
	sets.DualMND = {
		sub="Daybreak",
	}
	
    sets.Obi = {waist="Hachirin-no-Obi"}

    --sets.CP = {back="Mecisto. Mantle"}
	
	sets.Crocea_Shield = {
		main="Crocea Mors",
		sub="Forfend +1",
		}
		
	sets.Crocea_Derm = {
		main="Crocea Mors", 
		sub="Demers. Degen +1",
		}
		
	sets.Crocea_Gleti = {
		main="Crocea Mors", 
		sub="Gleti's Knife",
		}		
		
	sets.Crocea_Tern = {
		main="Crocea Mors", 
		sub="Ternion Dagger +1",
		}

	sets.Crocea_Tauret = {
		main="Crocea Mors", 
		sub="Tauret",
		}

	sets.Crocea_Seq = {
		main="Crocea Mors", 
		sub="Sequence",		
	}
	
	sets.Crocea_Daybreak = {
		main="Crocea Mors", 
		sub="Daybreak",
		}
		
	sets.Crocea_Bunzi = {
		main="Crocea Mors", 
		sub="Bunzi's Rod",
		}
	
	sets.Crocea_TP = {
		main="Crocea Mors", 
		sub="Thibron",
		}

	sets.Naegling_TP = {
		main="Naegling", 
		sub="Thibron",
		}

	sets.Naegling_Seq = {
		main="Naegling", 
		sub="Sequence",		
	}
			
	sets.Naegling_Tern = {
		main="Naegling", 
		sub="Ternion Dagger +1",
		}	
		
	sets.Naegling_Gleti = {
		main="Naegling",
		sub="Gleti's Knife",
	}

	sets.Naegling_Tauret = {
		main="Naegling", 
		sub="Tauret",
		}	
	
	sets.Seq_Derm = {
		main="Sequence", 
		sub="Demers. Degen +1",	
	}
		
	sets.noTPfeed = {
		main="Aern Dagger",
		sub="Qutrub Knife",
		range="Ullr",
		ammo="Chapuli Arrow",
	}
		
    sets.Gleti_Thib = {
		main="Gleti's Knife",
		sub="Thibron",
		}
		
	sets.Gleti_Daybreak = {
		sub="Gleti's Knife",
		sub="Bunzi's Rod",
	}
		
	sets.Maxentius_Gleti = {
		main="Maxentius",
		sub="Gleti's Knife",
		--sub="Ammurapi Shield",
	}
	
	sets.Maxentius_Thib = {
		main="Maxentius",
		sub="Thibron",
		}		
		
	sets.Club_Single = {
		main="Maxentius",
		sub="Sacro Bulwark",
		}	
	sets.BunziAmmu = {
		main="Bunzi's Rod",
		sub="Ammurapi Shield",
		}
		
    sets.Mandau_Gleti = {
		main="Mandau",
		sub="Gleti's Knife",
		--sub="Sacro Bulwark",
		}
		
end



-------------------------------------------------------------------------------------------------------------------

-- Job-specific hooks for standard casting events.

-------------------------------------------------------------------------------------------------------------------
function job_precast(spell, action, spellMap, eventArgs)

	equip(sets[state.WeaponSet.current])

    if spellMap == 'Utsusemi' then

        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then

            cancel_spell()

            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')

            eventArgs.handled = true

            return

        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then

            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')

        end
		--[[
		elseif spell.type == "WeaponSkill" and spell.target.distance > 10 and player.status == 'Engaged' then -- Cancel WS If You Are Out Of Range --
		cancel_spell()
		add_to_chat(123, spell.name..' Canceled: [Out of Range]')
		return
		]]

    end
	
    if spell.skill == 'Elemental Magic' and spell.english ~= 'Impact' then
		refine_various_spells(spell, action, spellMap, eventArgs)
	end

end


function job_post_precast(spell, action, spellMap, eventArgs)

    if spell.name == 'Impact' then

        equip(sets.precast.FC.Impact)

    end
    
	if spell.english == "Phalanx II" and spell.target.type == 'SELF' then

        cancel_spell()

        send_command('@input /ma "Phalanx" <me>')

    end

end



-- Run after the default midcast() is done.

-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.

function job_post_midcast(spell, action, spellMap, eventArgs)

    if spell.skill == 'Enhancing Magic' then

        if classes.NoSkillSpells:contains(spell.english) then

            equip(sets.midcast.EnhancingDuration)

            if spellMap == 'Refresh' then

                equip(sets.midcast.Refresh)

                if spell.target.type == 'SELF' then

                    equip (sets.midcast.RefreshSelf)

              end

            end

        elseif skill_spells:contains(spell.english) then

            equip(sets.midcast.EnhancingSkill)

        elseif spell.english:startswith('Gain') then

            equip(sets.midcast.GainSpell)

        elseif spell.english:contains('Spikes') then

            equip(sets.midcast.SpikesSpell)

        end

        if (spell.target.type == 'PLAYER' or spell.target.type == 'NPC') and buffactive['Composure'] then

            equip(sets.buff.ComposureOther)

        end
	
    end

    if spellMap == 'Cure' and spell.target.type == 'SELF' then

        equip(sets.midcast.CureSelf)

    end
	
	if spell.skill == 'Enfeebling Magic' and not enfeebling_magic_skill:contains(spell.english) then 
		
		if DW == true then
			
			equip(sets.DualMND)
			
		end
		
		if buffactive.Saboteur then 
		
			equip(sets.buff.Saboteur)
			
		end
		
	end

    if spell.skill == 'Elemental Magic' then

        if state.MagicBurst.value and spell.english ~= 'Death' then

            equip(sets.magic_burst)

            if spell.english == "Impact" then

                equip(sets.midcast.Impact)

            end

        end

        if (spell.element == world.day_element or spell.element == world.weather_element) then

            equip(sets.Obi)

        end
		
		if spell.element == "Earth" then 
			equip(sets.midcast.Earth)
		end
		
		if DW == true then
			equip(sets.DualMND)
		end
    end

end



function job_aftercast(spell, action, spellMap, eventArgs)

    equip(sets[state.WeaponSet.current])

    if spell.english:contains('Sleep') and not spell.interrupted then

        set_sleep_timer(spell)
		
	elseif spell.english:match('Bind') and not spell.interrupted then

        set_bind_timer(spell)
	
	elseif spell.english:match('Silence') and not spell.interrupted then

        set_silence_timer(spell)		

    end
	
end



-------------------------------------------------------------------------------------------------------------------

-- Job-specific hooks for non-casting events.

-------------------------------------------------------------------------------------------------------------------



function job_buff_change(buff,gain)

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

        disable('main','sub')
		--'main','sub','range', 'ammo', 

    else

        enable('main','sub')

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



-- Custom spell mapping.

function job_get_spell_map(spell, default_spell_map)

    if spell.action_type == 'Magic' then

        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then

            if (world.weather_element == 'Light' or world.day_element == 'Light') then

                return 'CureWeather'

            end

        end

        if spell.skill == 'Enfeebling Magic' then

            if enfeebling_magic_skill:contains(spell.english) then

                return "SkillEnfeebles"

            elseif enfeebling_magic_effect:contains(spell.english) then

                return "EffectEnfeebles"
            
			elseif enfeebling_magic_dur:contains(spell.english) then

                return "DurEnfeebles"

            elseif spell.type == "WhiteMagic" then

                if enfeebling_magic_acc:contains(spell.english) and not buffactive.Stymie then

                    return "MndEnfeeblesAcc"

                else

                    return "MndEnfeebles"

              end

            elseif spell.type == "BlackMagic" then

                if enfeebling_magic_acc:contains(spell.english) and not buffactive.Stymie then

                    return "IntEnfeeblesAcc"

                else

                    return "IntEnfeebles"

              end

            else

                return "MndEnfeebles"

            end

        end

    end

end



-- Modify the default idle set after it was constructed.

function customize_idle_set(idleSet)

    if player.mpp < 51 then

        idleSet = set_combine(idleSet, sets.latent_refresh)

     elseif state.CP.current == 'on' then

        equip(sets.CP)

        disable('back')

    else

        enable('back')

    end



    return idleSet

end



-- Set eventArgs.handled to true if we don't want the automatic display to be run.

function display_current_job_state(eventArgs)

    display_current_caster_state()

    eventArgs.handled = true

end



-- Function to display the current relevant user state when doing an update.

-- Return true if display was handled, and you don't want the default info shown.

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

function job_self_command(cmdParams, eventArgs)

    if cmdParams[1]:lower() == 'scholar' then

        handle_strategems(cmdParams)

        eventArgs.handled = true

    elseif cmdParams[1]:lower() == 'nuke' then

        handle_nuking(cmdParams)

        eventArgs.handled = true

    elseif cmdParams[1]:lower() == 'enspell' then

        send_command('@input /ma '..state.EnSpell.value..' <me>')

    elseif cmdParams[1]:lower() == 'barelement' then

        send_command('@input /ma '..state.BarElement.value..' <me>')

    elseif cmdParams[1]:lower() == 'barstatus' then

        send_command('@input /ma '..state.BarStatus.value..' <me>')

    elseif cmdParams[1]:lower() == 'gainspell' then

        send_command('@input /ma '..state.GainSpell.value..' <me>')

    end



    gearinfo(cmdParams, eventArgs)

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

        elseif strategem == 'addendum' then

            send_command('input /ja "Addendum: Black" <me>')

        else

            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')

        end

    else

        add_to_chat(123,'No arts has been activated yet.')

    end

end

function set_silence_timer(spell)

    local self = windower.ffxi.get_player()

    if spell.en == "Silence" then 
		--for normal silence duration
        --baseS = 120
		--estimated shinryu duration
		baseS = 72
    end



    if state.Buff.Saboteur then

        if state.NMmode.value == 'NMmode' then

            baseS = baseS * 1.39

        else

            baseS = baseS * 2.14

        end

    end

    -- Merit Points Duration Bonus
    
	baseS = baseS + self.merits.enfeebling_magic_duration*6

    -- Relic Head Duration Bonus
   
   if not ((buffactive.Stymie and buffactive.Composure)) then

        baseS = baseS + self.merits.enfeebling_magic_duration*3

    end
	
	-- Job Points Buff

    baseS = baseS + self.job_points.rdm.enfeebling_magic_duration



    if state.Buff.Stymie then

        baseS = baseS + self.job_points.rdm.stymie_effect

    end



    --User enfeebling duration enhancing gear total

    gear_mult = 1.45

    --User enfeebling duration enhancing augment total

    aug_mult = 1.25

    --Estoquer/Lethargy Composure set bonus
    --2pc = 1.1 / 3pc = 1.2 / 4pc = 1.35 / 5pc = 1.5
    
	empy_mult = 1 --from sets.midcast.Sleep
	
	if (buffactive.Composure and not buffactive.Stymie and not buffactive.Saboteur) then 
	
		empy_mult = 1.2 --from sets.midcast.SleepMaxDuration	
		
	elseif (buffactive.Stymie and not buffactive.Composure and not buffactive.Saboteur) then 
	
		baseS = baseS + self.job_points.rdm.stymie_effect
		
    elseif (buffactive.Stymie and buffactive.Composure and not buffactive.Saboteur) then
        
		if buffactive.Stymie then
        
			baseS = baseS + self.job_points.rdm.stymie_effect
        
		end
        
		empy_mult = 1.2 --from sets.midcast.SleepMaxDuration
		
	elseif (buffactive.Composure and not buffactive.Stymie and buffactive.Saboteur) then 
	
		gear_mult = 1.25
		
		empy_mult = 1.35 --from sets.midcast.SleepMaxDuration	
		
	elseif (buffactive.Stymie and not buffactive.Composure and buffactive.Saboteur) then 
	
		baseS = baseS + self.job_points.rdm.stymie_effect
		
		gear_mult = 1.25
		
    elseif (buffactive.Stymie and buffactive.Composure and buffactive.Saboteur) then
        
		if buffactive.Stymie then
        
			baseS = baseS + self.job_points.rdm.stymie_effect
        
		end
		
		gear_mult = 1.25
        
		empy_mult = 1.35 --from sets.midcast.SleepMaxDuration
    
	end

    totalDurationS = math.floor(baseS * gear_mult * aug_mult * empy_mult)
	
    -- Create the custom timer
	
	if spell.english == "Silence" then 
		
        send_command('@timers c "Silence ['..spell.target.name..']" ' ..totalDurationS.. ' down spells/00059.png')

    end
	
end


function set_bind_timer(spell)

    local self = windower.ffxi.get_player()

    if spell.en == "Bind" then 

        baseB = 45
		
    end



    if state.Buff.Saboteur then

        if state.NMmode.value == 'NMmode' then

            baseB = baseB * 1.39

        else

            baseB = baseB * 2.14

        end

    end

    -- Merit Points Duration Bonus
    
	baseB = baseB + self.merits.enfeebling_magic_duration*6

    -- Relic Head Duration Bonus
   
   if not ((buffactive.Stymie and buffactive.Composure)) then

        baseB = baseB + self.merits.enfeebling_magic_duration*3

    end
	
	-- Job Points Buff

    baseB = baseB + self.job_points.rdm.enfeebling_magic_duration



    if state.Buff.Stymie then

        baseB = baseB + self.job_points.rdm.stymie_effect

    end



    --User enfeebling duration enhancing gear total

    gear_mult = 1.45

    --User enfeebling duration enhancing augment total

    aug_mult = 1.25

    --Estoquer/Lethargy Composure set bonus
    --2pc = 1.1 / 3pc = 1.2 / 4pc = 1.35 / 5pc = 1.5
    
	empy_mult = 1 --from sets.midcast.Sleep
	
	if (buffactive.Composure and not buffactive.Stymie and not buffactive.Saboteur) then 
	
		empy_mult = 1.2 --from sets.midcast.SleepMaxDuration	
		
	elseif (buffactive.Stymie and not buffactive.Composure and not buffactive.Saboteur) then 
	
		baseB = baseB + self.job_points.rdm.stymie_effect
		
    elseif (buffactive.Stymie and buffactive.Composure and not buffactive.Saboteur) then
        
		if buffactive.Stymie then
        
			baseB = baseB + self.job_points.rdm.stymie_effect
        
		end
        
		empy_mult = 1.2 --from sets.midcast.SleepMaxDuration
		
	elseif (buffactive.Composure and not buffactive.Stymie and buffactive.Saboteur) then 
	
		gear_mult = 1.25
		
		empy_mult = 1.35 --from sets.midcast.SleepMaxDuration	
		
	elseif (buffactive.Stymie and not buffactive.Composure and buffactive.Saboteur) then 
	
		baseB = baseB + self.job_points.rdm.stymie_effect
		
		gear_mult = 1.25
		
    elseif (buffactive.Stymie and buffactive.Composure and buffactive.Saboteur) then
        
		if buffactive.Stymie then
        
			baseB = baseB + self.job_points.rdm.stymie_effect
        
		end
		
		gear_mult = 1.25
        
		empy_mult = 1.35 --from sets.midcast.SleepMaxDuration
    
	end

    totalDurationB = math.floor(baseB * gear_mult * aug_mult * empy_mult)
	
    -- Create the custom timer
	
	if spell.english == "Bind" then 
		
        send_command('@timers c "Bind ['..spell.target.name..']" ' ..totalDurationB.. ' down spells/00258.png')

    end
	
end


function set_sleep_timer(spell)

    local self = windower.ffxi.get_player()

    if spell.en == "Sleep II" then 

        base = 90

    elseif spell.en == "Sleep" or spell.en == "Sleepga" then 

        base = 60
		
    end



    if state.Buff.Saboteur then

        if state.NMmode.value == 'NM mode' then

            base = base * 1.39

        else

            base = base * 2.14

        end

    end

    -- Merit Points Duration Bonus
    
	base = base + self.merits.enfeebling_magic_duration*6

    -- Relic Head Duration Bonus
   
   if not ((buffactive.Stymie and buffactive.Composure)) then

        base = base + self.merits.enfeebling_magic_duration*3

    end
	
	-- Job Points Buff

    base = base + self.job_points.rdm.enfeebling_magic_duration



    if state.Buff.Stymie then

        base = base + self.job_points.rdm.stymie_effect

    end



    --User enfeebling duration enhancing gear total

    gear_mult = 1.45

    --User enfeebling duration enhancing augment total

    aug_mult = 1.25

    --Estoquer/Lethargy Composure set bonus
    --2pc = 1.1 / 3pc = 1.2 / 4pc = 1.35 / 5pc = 1.5
    
	empy_mult = 1 --from sets.midcast.Sleep
	
	if (buffactive.Composure and not buffactive.Stymie and not buffactive.Saboteur) then 
	
		empy_mult = 1.2 --from sets.midcast.SleepMaxDuration	
		
	elseif (buffactive.Stymie and not buffactive.Composure and not buffactive.Saboteur) then 
	
		base = base + self.job_points.rdm.stymie_effect
		
    elseif (buffactive.Stymie and buffactive.Composure and not buffactive.Saboteur) then
        
		if buffactive.Stymie then
        
			base = base + self.job_points.rdm.stymie_effect
        
		end
        
		empy_mult = 1.2 --from sets.midcast.SleepMaxDuration
		
	elseif (buffactive.Composure and not buffactive.Stymie and buffactive.Saboteur) then 
	
		gear_mult = 1.25
		
		empy_mult = 1.35 --from sets.midcast.SleepMaxDuration	
		
	elseif (buffactive.Stymie and not buffactive.Composure and buffactive.Saboteur) then 
	
		base = base + self.job_points.rdm.stymie_effect
		
		gear_mult = 1.25
		
    elseif (buffactive.Stymie and buffactive.Composure and buffactive.Saboteur) then
        
		if buffactive.Stymie then
        
			base = base + self.job_points.rdm.stymie_effect
        
		end
		
		gear_mult = 1.25
        
		empy_mult = 1.35 --from sets.midcast.SleepMaxDuration
    
	end

    totalDuration = math.floor(base * gear_mult * aug_mult * empy_mult)

        

    -- Create the custom timer

    if spell.english == "Sleep II" then

        send_command('@timers c "Sleep II ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00259.png')

    elseif spell.english == "Sleep" or spell.english == "Sleepga" then

        send_command('@timers c "Sleep ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00253.png')

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
        if spell.skill == 'Elemental Magic' then
            spell_index = table.find(degrade_array[spell.element],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array[spell.element][spell_index - 1] 
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


windower.register_event('zone change', 

    function()

        if player.sub_job == 'NIN' or player.sub_job == 'DNC' then

            send_command('gi ugs true')

        end

    end

)



-- Select default macro book on initial load or subjob change.

function select_default_macro_book()

    -- Default macro set/book

    set_macro_page(1, 1)

end



function set_lockstyle()

    send_command('wait 8; input /lockstyleset ' .. lockstyleset)

end


		
