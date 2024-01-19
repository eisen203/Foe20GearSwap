-------------------------------------------------------------------------------------------------------------------
-- (Original: Motenten / Modified: Arislan)
-------------------------------------------------------------------------------------------------------------------

--[[    Custom Features:
        
        Magic Burst            Toggle Magic Burst Mode  [Alt-`]
        Haste Detection        Detects current magic haste level and equips corresponding engaged set to
                            optimize delay reduction (automatic)
        Haste Mode            Toggles between Haste II and Haste I recieved, used by Haste Detection [WinKey-H]
        Capacity Pts. Mode    Capacity Points Mode Toggle [WinKey-C]
        Auto. Lockstyle        Automatically locks specified equipset on file load
--]]

--------------------------------------------------------------------------------------------------------------------
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
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Chain Affinity'] = buffactive['Chain Affinity'] or false
    state.Buff.Convergence = buffactive.Convergence or false
    state.Buff.Diffusion = buffactive.Diffusion or false
    state.Buff.Efflux = buffactive.Efflux or false
    
	include('Mote-TreasureHunter')
    
	state.Buff['Unbridled Learning'] = buffactive['Unbridled Learning'] or false
    blue_magic_maps = {}
    
    -- Mappings for gear sets to use for various blue magic spells.
    -- While Str isn't listed for each, it's generally assumed as being at least
    -- moderately signficant, even for spells with other mods.

    -- Physical spells with no particular (or known) stat mods
    blue_magic_maps.Physical = S{'Bilgestorm'}

    -- Spells with heavy accuracy penalties, that need to prioritize accuracy first.
    blue_magic_maps.PhysicalAcc = S{'Heavy Strike'}

    -- Physical spells with Str stat mod
    blue_magic_maps.PhysicalStr = S{'Battle Dance','Bloodrake','Death Scissors','Dimensional Death',
        'Empty Thrash','Quadrastrike','Saurian Slide','Sinker Drill','Spinal Cleave','Sweeping Gouge',
        'Uppercut','Vertical Cleave'}

    -- Physical spells with Dex stat mod
    blue_magic_maps.PhysicalDex = S{'Amorphic Spikes','Asuran Claws','Barbed Crescent','Claw Cyclone',
        'Disseverment','Foot Kick','Frenetic Rip','Goblin Rush','Hysteric Barrage','Paralyzing Triad',
        'Seedspray','Sickle Slash','Smite of Rage','Terror Touch','Thrashing Assault','Vanity Dive'}

    -- Physical spells with Vit stat mod
    blue_magic_maps.PhysicalVit = S{'Body Slam','Cannonball','Delta Thrust','Glutinous Dart','Grand Slam',
        'Power Attack','Quad. Continuum','Sprout Smack','Sub-zero Smash'}

    -- Physical spells with Agi stat mod
    blue_magic_maps.PhysicalAgi = S{'Benthic Typhoon','Feather Storm','Helldive','Hydro Shot','Jet Stream',
        'Pinecone Bomb','Spiral Spin','Wild Oats'}

    -- Physical spells with Int stat mod
    blue_magic_maps.PhysicalInt = S{'Mandibular Bite','Queasyshroom'}

    -- Physical spells with Mnd stat mod
    blue_magic_maps.PhysicalMnd = S{'Ram Charge','Screwdriver','Tourbillion'}

    -- Physical spells with Chr stat mod
    blue_magic_maps.PhysicalChr = S{'Bludgeon'}

    -- Physical spells with HP stat mod
    blue_magic_maps.PhysicalHP = S{'Final Sting'}

    -- Magical spells with the typical Int mod
    blue_magic_maps.Magical = S{'Anvil Lightning','Blastbomb','Blazing Bound','Bomb Toss','Cursed Sphere',
        'Droning Whirlwind','Embalming Earth','Entomb','Firespit','Foul Waters','Ice Break','Leafstorm',
        'Maelstrom','Molting Plumage','Nectarous Deluge','Regurgitation','Rending Deluge','Scouring Spate',
        'Silent Storm','Spectral Floe','Subduction','Tem. Upheaval','Water Bomb'}
    
    blue_magic_maps.MagicalDark = S{'Dark Orb','Death Ray','Eyes On Me','Evryone. Grudge','Palling Salvo',
        'Tenebral Crush'}
        
    blue_magic_maps.MagicalLight = S{'Blinding Fulgor','Diffusion Ray','Radiant Breath','Rail Cannon',
        'Retinal Glare'}

    -- Magical spells with a primary Mnd mod
    blue_magic_maps.MagicalMnd = S{'Acrid Stream','Magic Hammer','Mind Blast'}

    -- Magical spells with a primary Chr mod
    blue_magic_maps.MagicalChr = S{'Mysterious Light'}

    -- Magical spells with a Vit stat mod (on top of Int)
    blue_magic_maps.MagicalVit = S{'Thermal Pulse'}

    -- Magical spells with a Dex stat mod (on top of Int)
    blue_magic_maps.MagicalDex = S{'Charged Whisker','Gates of Hades'}

    -- Magical spells (generally debuffs) that we want to focus on magic accuracy over damage.
    -- Add Int for damage where available, though.
    blue_magic_maps.MagicAccuracy = S{'1000 Needles','Absolute Terror','Actinic Burst','Atra. Libations',
        'Auroral Drape','Awful Eye', 'Blank Gaze','Blistering Roar','Blood Saber','Chaotic Eye',
        'Cimicine Discharge','Cold Wave','Corrosive Ooze','Demoralizing Roar','Digest','Dream Flower',
        'Enervation','Feather Tickle','Filamented Hold','Frightful Roar','Geist Wall','Hecatomb Wave',
        'Infrasonics','Jettatura','Light of Penance','Lowing','Mind Blast','Mortal Ray','MP Drainkiss',
        'Osmosis','Reaving Wind','Sandspin','Sandspray','Sheep Song','Soporific','Sound Blast',
        'Stinking Gas','Sub-zero Smash','Venom Shell','Voracious Trunk','Yawn'}

    -- Breath-based spells
    blue_magic_maps.Breath = S{'Bad Breath','Flying Hip Press','Frost Breath','Heat Breath','Hecatomb Wave',
        'Magnetite Cloud','Poison Breath','Self-Destruct','Thunder Breath','Vapor Spray','Wind Breath'}

    -- Stun spells

    blue_magic_maps.StunPhysical = S{'Frypan','Head Butt','Sudden Lunge','Tail slap','Whirl of Rage'}

    blue_magic_maps.StunMagical = S{'Blitzstrahl','Temporal Shift','Thunderbolt'}
    
    -- Healing spells
    blue_magic_maps.Healing = S{'Healing Breeze','Magic Fruit','Plenilune Embrace','Pollen','Restoral',
        'White Wind','Wild Carrot'}

    -- Buffs that depend on blue magic skill
    blue_magic_maps.SkillBasedBuff = S{'Barrier Tusk','Diamondhide','Magic Barrier','Metallic Body',
        'Plasma Charge','Pyric Bulwark','Reactor Cool','Occultation'}

    -- Other general buffs
    blue_magic_maps.Buff = S{'Amplification','Animating Wail','Carcharian Verve','Cocoon',
        'Erratic Flutter','Exuviation','Fantod','Feather Barrier','Harden Shell','Memento Mori',
        'Nat. Meditation','Orcish Counterstance','Refueling','Regeneration','Saline Coat','Triumphant Roar',
        'Warm-Up','Winds of Promyvion','Zephyr Mantle'}
    
    blue_magic_maps.Refresh = S{'Battery Charge'}

    -- Spells that require Unbridled Learning to cast.
    unbridled_spells = S{'Absolute Terror','Bilgestorm','Blistering Roar','Bloodrake','Carcharian Verve','Cesspool',
        'Crashing Thunder','Droning Whirlwind','Gates of Hades','Harden Shell','Mighty Guard',
        'Polar Roar','Pyric Bulwark','Tearing Gust','Thunderbolt','Tourbillion','Uproot'}

    elemental_ws = S{'Flash Nova', 'Sanguine Blade'}
	

    -- For th_action_check():

    -- JA IDs for actions that always have TH: Provoke, Animated Flourish

    info.default_ja_ids = S{35, 204}

    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish

    info.default_u_ja_ids = S{201, 202, 203, 205, 207}



    lockstyleset = 100
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Eva', 'MidAcc', 'HighAcc', 'STP')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'TH', 'Eva')
    state.PhysicalDefenseMode:options('PDT', 'MDT')
    state.IdleMode:options('Normal', 'Nyame', 'Malig', 'Learning')
	
	state.WeaponSet = M{['description']='Weapon Set', 'none', 'Tizona_Sakpata', 'Tizona_Zant', 'Tizona_Bunzi', 'Tizona_Seq', 'Tizona_TP', 'Naegling_TP', 'Sequence_Naegling', 'Sequence_TP', 'Maxentius_TP', 'Cleave'}
	
    state.MagicBurst = M(false, 'Magic Burst')
    state.CP = M(false, "Capacity Points Mode")

	state.WeaponLock = M(false, 'Weapon Lock')
    -- Additional local binds
	state.AutoWS = M{['description']='Auto WS','OFF','true'}
    send_command('bind @z gs c cycle AutoWS')
    state.AutoWSList = M{['description']='Auto WS List', 'OFF', 'CDC', 'Savage', 'Expiacion', 'Halo', 'Vagary6step'}
	send_command('bind @x gs c cycle AutoWSList')


	include('organizer-lib')
	
    send_command('lua l gearinfo')
	send_command('bind ^= input /gs c cycle treasuremode')
	send_command('bind @w gs c toggle WeaponLock')
   -- include('Global-Binds.lua') -- OK to remove this line
   -- include('Global-GEO-Binds.lua') -- OK to remove this line
	
    select_default_macro_book()
    set_lockstyle()
	
	wsnum = 0
	
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

    send_command('unbind ^c')

    send_command('unbind ^s')

    send_command('unbind ^f')

    send_command('unbind !`')

    send_command('unbind @t')

    send_command('unbind @`')

    send_command('unbind ^insert')

    send_command('unbind ^delete')

    send_command('unbind ^home')

    send_command('unbind ^end')

    send_command('unbind ^pageup')

    send_command('unbind ^pagedown')

    send_command('unbind ^,')

    send_command('unbind @c')

    send_command('unbind @q')

    send_command('unbind @w')
	
	send_command('unbind @z')
	
	send_command('unbind @x')

    send_command('unbind @e')

    send_command('unbind @r')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs

    sets.buff['Burst Affinity'] = {legs="Luhlaza Shalwar +3", feet="Hashi. Basmak +2"}
    sets.buff['Diffusion'] = {feet="Luhlaza Charuqs +1"}
    sets.buff['Efflux'] = {legs="Hashishin Tayt +2"}

    --sets.precast.JA['Azure Lore'] = {hands="Luhlaza Bazubands"}
    sets.precast.JA['Chain Affinity'] = {head="Hashishin Kavuk +2", feet="Assim. Charuqs +3"}
    sets.precast.JA['Convergence'] = {head="Luh. Keffiyeh +3"}
    --sets.precast.JA['Enchainment'] = {body="Luhlaza Jubbah +1"}

	sets.TreasureHunter = { 
		body=gear.Herculean.Body_TH,
		hands=gear.Herculean.Hands_TH,
		waist="Chaac Belt",

		}
	
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
	
	--need 60 with fc trait 3
    sets.precast.FC = {
        -- Colada 4
		ammo="Sapience Orb", --2
		head="Carmine Mask +1", --14
		body="Pinga Tunic", --13
		hands="Leyline Gloves", --8
		legs="Pinga Pants +1", --13
		feet="Carmine Greaves +1", --8
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Etiolation Earring", --1
		right_ear="Loquac. Earring", --2
		left_ring="Defending Ring", 
		right_ring="Kishar Ring", --4
		back=gear.Rosmerta_EVA, --10
		--totalFC = 75
        }

    sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC,{
		body="Hashishin Mintan +3",
	})
	--73
	
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
    sets.precast.FC.Cure = set_combine(sets.precast.FC,{})

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        --ammo="Impatiens",
        --body="Passion Jacket",
		waist="Rumination Sash",
        --ring1="Lebeche Ring",
		right_ring="Prolix Ring",
		back="Perimede Cape",
        })

    
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        }

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        })

    sets.precast.WS['Chant du Cygne'] = {
		ammo="Coiste Bodhar",
		head="Adhemar Bonnet +1",
		body="Gleti's Cuirass",
		hands="Adhemar Wrist. +1", 
		legs="Gleti's Breeches",
		feet=gear.Herculean.Feet_CRITDMG,
		neck="Mirage Stole +2",
		waist="Sailfi Belt +1",
		left_ear="Mache Earring +1", 
		right_ear="Odr Earring",
		left_ring="Ilabrat Ring",
		right_ring="Epona's Ring",
		back=gear.Rosmerta_CDC,
        }

    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS['Chant du Cygne'], {
        head="Carmine Mask +1",
        body="Assim. Jubbah +3",
		hands="Assim. Bazu. +3",
		legs="Carmine Cuisses +1",
        feet="Assim. Charuqs +3",
        right_ear="Telos Earring",
		left_ring="Ilabrat Ring",
		right_ring="Begrudging Ring",
        })

    sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']
    sets.precast.WS['Vorpal Blade'].Acc = sets.precast.WS['Chant du Cygne'].Acc

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
		ammo="Oshasha's Treatise",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Mirage Stole +2",
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Ishvara Earring",
        left_ring="Epaminondas's Ring",  
        right_ring="Metamorph Ring +1",
		back=gear.Rosmerta_WSD,
        })

    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
        head="Carmine Mask +1",
        body="Assim. Jubbah +3",
		--hands="Assim. Bazu. +3",
		legs="Carmine Cuisses +1",
        --feet="Assim. Charuqs +3",
        })

    sets.precast.WS['Requiescat'] = {
		ammo="Coiste Bodhar",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Hashi. Bazu. +1",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Brutal Earring",
		left_ring="Ilabrat Ring", 
		right_ring="Metamorph Ring +1",
		back=gear.Rosmerta_DBL,
        }

    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {
        head="Carmine Mask +1",
        body="Assim. Jubbah +3",
		hands="Assim. Bazu. +3",
		legs="Carmine Cuisses +1",
        feet="Assim. Charuqs +3",
		left_ear="Mache Earring +1",
        right_ear="Telos Earring",
        left_ring="Ilabrat Ring",
		right_ring="Metamorph Ring +1",
        })

    sets.precast.WS['Expiacion'] = set_combine(sets.precast.WS['Savage Blade'], {
        })

    sets.precast.WS['Expiacion'].Acc = set_combine(sets.precast.WS['Expiacion'], {
        })

    sets.precast.WS['Sanguine Blade'] = {
			ammo="Ghastly Tathlum +1",
			head="Pixie Hairpin +1",
			body="Nyame Mail",
			hands="Nyame Gauntlets",
			legs="Luhlaza Shalwar +3",
			feet="Nyame Sollerets", 
			neck="Erra Pendant",
			waist="Eschan Stone",
			left_ear="Hecate's Earring",
			right_ear="Friomisi Earring",
			left_ring="Archon Ring",
			right_ring="Metamorph Ring +1",
			back=gear.Rosmerta_MA,
        }

    sets.precast.WS['True Strike']= set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS['True Strike'].Acc = sets.precast.WS['Savage Blade'].Acc
    sets.precast.WS['Judgment'] = sets.precast.WS['True Strike']
    sets.precast.WS['Judgment'].Acc = sets.precast.WS['True Strike'].Acc
    sets.precast.WS['Black Halo'] = sets.precast.WS['True Strike']
    sets.precast.WS['Black Halo'].Acc = sets.precast.WS['True Strike'].Acc
    sets.precast.WS['Realmrazer'] = sets.precast.WS['Requiescat']
    sets.precast.WS['Realmrazer'].Acc = sets.precast.WS['Requiescat'].Acc
    
    sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS['Sanguine Blade'], {
        head="Nyame Helm",
        left_ring="Levia. Ring +1",
        right_ring="Prolix Ring",
        })
	
	sets.precast['Diaga'] = sets.idle.DT
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	sets.midcast['Diaga'] = sets.idle.DT

	
    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
		head=gear.Herculean.Head_REF, --7
		hands="Rawhide Gloves", --15
		legs="Carmine Cuisses +1", --20
		feet="Amalric Nails +1", --16
        left_ring="Evanescence Ring", --5
        waist="Rumination Sash", --6
		--total = 69
        }

    sets.midcast['Blue Magic'] = {
        --ammo="Mavi Tathlum",
        head="Luh. Keffiyeh +3",
        body="Assim. Jubbah +3",
        hands="Rawhide Gloves",
        legs="Hashishin Tayt +2",
        feet="Luhlaza Charuqs +1",
        neck="Mirage Stole +2",
		right_ear="Hashi Earring +2",
        ring1="Stikini Ring +1",
        ring2="Stikini Ring +1",
        back="Cornflower Cape", 
        }

sets.midcast['Blue Magic'].Physical = {
    ammo="Coiste Bodhar",
    head="Hashishin Kavuk +2",
	body="Hashishin Mintan +3",
	hands="Hashi. Bazu. +2",
	legs="Hashishin Tayt +2",
	feet="Hashi. Basmak +2",
    neck="Mirage Stole +2",
    waist="Sailfi Belt +1", 
    left_ear="Telos Earring",
	right_ear="Hashi Earring +1",
    left_ring="Defending Ring",
    right_ring="Ilabrat Ring",
	back=gear.Rosmerta_WSD,
        }

    sets.midcast['Blue Magic'].PhysicalAcc = set_combine(sets.midcast['Blue Magic'].Physical, {
		back=gear.Rosmerta_CDC,
		})

    sets.midcast['Blue Magic'].PhysicalStr = sets.midcast['Blue Magic'].Physical

    sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical, {
		feet="Assim. Charuqs +3",
		left_ear="Mache Earring +1", 
        back=gear.Rosmerta_CDC,
        })

    sets.midcast['Blue Magic'].PhysicalVit = sets.midcast['Blue Magic'].Physical

    sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical, {
        })

    sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical, {
		left_ring="Shiva Ring",
        right_ring="Shiva Ring",
        back=gear.Rosmerta_MA,
        })

    sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical, {
        right_ring="Levia. Ring",
        })
    
    sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical, {ear1="Regal Earring", ear2="Enchntr. Earring +1"})

    sets.midcast['Blue Magic'].Magical = {
		ammo="Ghastly Tathlum +1",
		head="Hashishin Kavuk +3",
		body="Hashishin Mintan +3",
		hands="Hashi. Bazu. +2",
		legs="Hashishin Tayt +2",
		feet="Hashi. Basmak +2",
		neck="Sanctity Necklace",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear="Regal Earring",
		left_ring="Defending Ring",
		right_ring="Metamorph Ring +1",
		back=gear.Rosmerta_MA,
        }

		
    sets.midcast['Blue Magic'].Magical.TH = set_combine(sets.midcast['Blue Magic'].Magical, {    
		body=gear.Herculean.Body_TH,
		hands=gear.Herculean.Hands_TH,
		waist="Chaac Belt",
        })

	sets.midcast['Blue Magic'].Magical.Eva = {
		ammo="Amar Cluster",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Hashi. Bazu. +2",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Bathy Choker +1",
		waist="Kasiri Belt",
		left_ear="Eabani Earring",
		right_ear="Infused Earring",
		left_ring="Defending Ring",
		right_ring="Shneddick Ring",
		back=gear.Rosmerta_EVA,
		}

    sets.midcast['Blue Magic'].MagicalDark = set_combine(sets.midcast['Blue Magic'].Magical, {
        head="Pixie Hairpin +1",
        left_ring="Archon Ring",
        })
		
	sets.midcast['Blue Magic'].MagicalDark.Eva = sets.midcast['Blue Magic'].Magical.Eva

    sets.midcast['Blue Magic'].MagicalLight = set_combine(sets.midcast['Blue Magic'].Magical, {
        })
		
	sets.midcast['Blue Magic'].MagicalLight.Eva = sets.midcast['Blue Magic'].Magical.Eva

    sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical, {
        })
		
	sets.midcast['Blue Magic'].MagicalMnd.Eva = sets.midcast['Blue Magic'].Magical.Eva

    sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical, {
        })
		
	sets.midcast['Blue Magic'].MagicalDex.Eva = sets.midcast['Blue Magic'].Magical.Eva

    sets.midcast['Blue Magic'].MagicalVit = sets.midcast['Blue Magic'].Magical
	
	sets.midcast['Blue Magic'].MagicalVit.Eva = sets.midcast['Blue Magic'].Magical.Eva
    
	sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical, {
		})
		
	sets.midcast['Blue Magic'].MagicalChr.Eva = sets.midcast['Blue Magic'].Magical.Eva

    sets.midcast['Blue Magic'].MagicAccuracy = {
		ammo="Pemphredo Tathlum",
		head="Hashishin Kavuk +2",
		body="Hashishin Mintan +3",
		hands="Hashi. Bazu. +2",
		legs="Hashishin Tayt +2",
		feet="Hashi. Basmak +2",
		neck="Mirage Stole +2",
		waist="Acuity Belt +1",
		left_ear="Digni. Earring",
		right_ear="Hashi Earring +2",
		left_ring="Stikini Ring +1",
		right_ring="Metamorph Ring +1",
		back=gear.Rosmerta_MA,
        }
		
    sets.midcast['Blue Magic'].MagicAccuracy.TH = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {    
		body=gear.Herculean.Body_TH,
		hands=gear.Herculean.Hands_TH,
		waist="Chaac Belt",
        })

	sets.midcast['Blue Magic'].MagicAccuracy.Eva = sets.midcast['Blue Magic'].Magical.Eva

    sets.midcast['Blue Magic'].Breath = sets.midcast['Blue Magic'].Magical
	
	sets.midcast['Blue Magic'].Breath.Eva = sets.midcast['Blue Magic'].Magical.Eva


    sets.midcast['Blue Magic'].StunPhysical = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {
        head="Hashishin Kavuk +2",
		body="Hashishin Mintan +3",
		hands="Hashi. Bazu. +2",
		legs="Hashishin Tayt +2",
		feet="Hashi. Basmak +2",
        neck="Mirage Stole +2",
        })
		
	sets.midcast['Blue Magic'].StunPhysical.Eva = sets.midcast['Blue Magic'].Magical.Eva
		
	sets.midcast['Blue Magic'].StunMagical = sets.midcast['Blue Magic'].MagicAccuracy
	
	sets.midcast['Blue Magic'].StunMagical.Eva = sets.midcast['Blue Magic'].Magical.Eva
	
	sets.midcast['Blue Magic']['Cruel Joke'] = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {

        })
		
	sets.midcast['Blue Magic']['Cruel Joke'].Eva = sets.midcast['Blue Magic'].Magical.Eva
		
    sets.midcast['Blue Magic'].Healing = {
        ammo="Pemphredo Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Hashi. Bazu. +2",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Phalaina Locket",
		waist="Gishdubar Sash",
		left_ear="Mendi. Earring",
		right_ear="Hashi Earring +2",
		left_ring="Defending Ring",
		right_ring="Stikini Ring +1",
		back=gear.Rosmerta_STP,
        }
		
	sets.midcast['Blue Magic'].Healing.Eva = sets.midcast['Blue Magic'].Magical.Eva

    sets.midcast['Blue Magic'].HealingSelf = set_combine(sets.midcast['Blue Magic'].Healing, {
        --hands="Buremte Gloves", -- (13)
        --legs="Gyve Trousers", -- 10
        --neck="Phalaina Locket", -- 4(4)
        --ring2="Asklepian Ring", -- (3)
        --waist="Gishdubar Sash", -- (10)
        })
		
	sets.midcast['Blue Magic'].HealingSelf.Eva = sets.midcast['Blue Magic'].Magical.Eva
		

    sets.midcast['Blue Magic']['White Wind'] = {
		head="Nyame Helm",
		body="Nyame Mail", 
		hands="Hashi. Bazu. +2",
		legs="Nyame Flanchard", 
		feet="Nyame Sollerets",
		neck="Unmoving Collar +1", 
		waist="Plat. Mog. Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Defending Ring",
		right_ring="Gelatinous Ring +1", 
		back="Moonbeam Cape",
        }	
        
    sets.midcast['Blue Magic'].Buff = sets.midcast['Blue Magic']
    sets.midcast['Blue Magic'].Refresh = set_combine(sets.midcast['Blue Magic'], {
		head="Amalric Coif +1", 
		waist="Gishdubar Sash", 
		--back="Grapevine Cape",
		})
    sets.midcast['Blue Magic'].SkillBasedBuff = sets.midcast['Blue Magic']
    
    sets.midcast['Blue Magic']['Occultation'] = set_combine(sets.midcast['Blue Magic'], {
        hands="Hashi. Bazu. +2",
        })
		
    sets.midcast['Blue Magic']['Osmosis'] = set_combine(sets.midcast['Blue Magic'], {
        hands="Hashi. Bazu. +2",
        })
		
    sets.midcast['Blue Magic']['Sheep Song'] = sets.Enmity
	
	sets.midcast['Blue Magic']['Sheep Song'].Eva = sets.midcast['Blue Magic'].Magical.Eva

    sets.midcast['Blue Magic']['Carcharian Verve'] = set_combine(sets.midcast['Blue Magic'].Buff, {
        head="Amalric Coif +1",
        waist="Emphatikos Rope",
        })

    sets.midcast['Enhancing Magic'] = {
        head="Carmine Mask +1",
        body=gear.Telchine.Body_dur,
        hands=gear.Telchine.Hands_dur,
		legs="Carmine Cuisses +1",
		feet=gear.Telchine.Feet_dur, 
		neck="Incanter's Torque",
		waist="Cascade Belt",
		left_ear="Andoaa Earring",
		right_ear="Ethereal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Perimede Cape",
        }

    sets.midcast.EnhancingDuration = {
        head=gear.Telchine.Head_dur,
        body=gear.Telchine.Body_dur,
        hands=gear.Telchine.Hands_dur,
        legs=gear.Telchine.Legs_dur,
        feet=gear.Telchine.Feet_dur,
        }

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
		head="Amalric Coif +1", 
		waist="Gishdubar Sash", 
		--back="Grapevine Cape",
		})
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
	waist="Siegel Sash",
	})
sets.midcast.Phalanx = set_combine(sets.midcast['Enhancing Magic'], {
    head=gear.Taeon.Head_PHLX,
    body=gear.Herculean.Body_PHLX,
    hands=gear.Taeon.Hands_PHLX,
    legs=gear.Taeon.Legs_PHLX,
    feet=gear.Taeon.Feet_PHLX,
	})
    
sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {
	ammo="Staunch Tathlum", --10
	head="Amalric Coif +1", 
	hands="Rawhide Gloves", --15
	legs="Carmine Cuisses +1", --20
	feet="Amalric Nails +1", --15
    left_ring="Evanescence Ring", --5
	waist="Rumination Sash", --6
	--waist="Emphatikos Rope"
	})  --total spellint. 71

    sets.midcast.Protect = {
	--ring1="Sheltered Ring"
	}
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect


    sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {
        --ear2="Vor Earring",
        })

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Resting sets
    sets.resting = sets.idle


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {
		ammo="Staunch Tathlum",
		head="Gleti's Mask",
		body="Hashishin Mintan +3",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Etiolation Earring",
		right_ear="Ethereal Earring",
		left_ring="Defending Ring",
		right_ring="Shneddick Ring",
		back=gear.Rosmerta_STP,
        }

sets.idle.Nyame = {
    ammo="Amar Cluster",
	head="Nyame Helm",
	body="Nyame Mail",
	hands="Nyame Gauntlets",
	legs="Nyame Flanchard",
	feet="Nyame Sollerets",
    neck="Bathy Choker +1",
    waist="Kasiri Belt",
	left_ear="Eabani Earring",
	right_ear="Infused Earring",
    left_ring="Defending Ring",
    right_ring="Shneddick Ring",
    back=gear.Rosmerta_EVA,
        }
		
sets.idle.Malig = {
    ammo="Amar Cluster",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Bathy Choker +1",
    waist="Kasiri Belt",
	left_ear="Eabani Earring",
	right_ear="Infused Earring",
    left_ring="Defending Ring",
    right_ring="Shneddick Ring",
    back=gear.Rosmerta_EVA,
        }
		
    sets.idle.Refresh = set_combine(sets.idle, {
		head=gear.Herculean.Head_REF,
		body="Amalric Doublet +1",
		hands=gear.Herculean.Hands_REF,
		feet=gear.Herculean.Feet_REF,
        })

    sets.idle.Town = set_combine(sets.idle, {
		head="Shaded Specs.",
		body="Goldsmith's Apron",
		neck="Goldsm. Torque",
		left_ring="Craftmaster's Ring",
        })

    sets.idle.Weak = sets.idle.DT

    sets.idle.Learning = set_combine(sets.idle, sets.Learning)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = {
		ammo="Staunch Tathlum",
		head="Malignance Chapeau", --3/3
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Chapeau", --2/3
        neck="Loricate Torque +1", 
		waist="Olseni Belt",
		left_ear="Etiolation Earring",
		right_ear="Ethereal Earring",
		left_ring="Defending Ring",
		right_ring="Shneddick Ring",
		back=gear.Rosmerta_STP,	
	}
    sets.defense.MDT = sets.idle.DT

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    sets.engaged = {
    --  1280acc --
		ammo="Coiste Bodhar",
        head="Malignance Chapeau", --6/6
        body="Malignance Tabard", --9/9
        hands="Adhemar Wrist. +1",
        legs="Malignance Tights", --7/7
        feet=gear.Herculean.Feet_TRPLacc,
		neck="Mirage Stole +2",
		waist="Reiki Yotai", --7
		left_ear="Eabani Earring", --4
		right_ear="Suppanomimi", --5
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back=gear.Rosmerta_STP, 
        } -- 37% DW
        
    sets.engaged.Eva = set_combine(sets.engaged, {
		ammo="Amar Cluster",
		neck="Bathy Choker +1",
		waist="Reiki Yotai", --7
		left_ear="Eabani Earring",
		right_ear="Infused Earring",
		left_ring="Defending Ring",
		back=gear.Rosmerta_EVA,
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.Eva, {
		left_ear="Cessance Earring",
		left_ring="Ilabrat Ring",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
		left_ear="Digni. Earring",
        })

    sets.engaged.STP = set_combine(sets.engaged, {
        left_ring="Ilabrat Ring",
        })

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.DW.Dagger.Accuracy.Evasion



    -- * DW6: +37%
    -- * DW5: +35%
    -- * DW4: +30%
    -- * DW3: +25% (NIN Subjob)
    -- * DW2: +15% (DNC Subjob)
    -- * DW1: +10%
    
    -- No Magic Haste (74% DW to cap or 44% with DW4 or 49 with DW3)
    sets.engaged.DW = {
    --  1280acc --
		ammo="Coiste Bodhar",
        head="Malignance Chapeau", --6/6
        body="Malignance Tabard", --9/9
        hands="Adhemar Wrist. +1",
        legs="Malignance Tights", --7/7
        feet=gear.Herculean.Feet_TRPLacc,
		neck="Mirage Stole +2",
		waist="Reiki Yotai", --7
		left_ear="Eabani Earring", --4
		right_ear="Suppanomimi", --5
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back=gear.Rosmerta_STP, 
        } -- 37% DW
        
    sets.engaged.DW.Eva = set_combine(sets.engaged.DW, {
		ammo="Amar Cluster",
		neck="Bathy Choker +1",
		waist="Reiki Yotai", --7
		left_ear="Eabani Earring",
		right_ear="Infused Earring",
		left_ring="Defending Ring",
		back=gear.Rosmerta_EVA,
        })

    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW.Eva, {
		left_ear="Cessance Earring",
		left_ring="Ilabrat Ring",
        })

    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {
		left_ear="Digni. Earring",
        })

    sets.engaged.DW.STP = set_combine(sets.engaged.DW, {
        left_ring="Ilabrat Ring",
        })

    -- 15% Magic Haste (67% DW to cap or 37% with DW4 or 42 with DW3)
    sets.engaged.DW.LowHaste = {
	--  1280acc --
		ammo="Coiste Bodhar",
        head="Malignance Chapeau", --6/6
        body="Malignance Tabard", --9/9
        hands="Adhemar Wrist. +1",
        legs="Malignance Tights", --7/7
        feet=gear.Herculean.Feet_TRPLacc,
		neck="Mirage Stole +2",
		waist="Reiki Yotai", --7
		left_ear="Eabani Earring", --4
		right_ear="Suppanomimi", --5
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back=gear.Rosmerta_STP, 
        } -- 37%

    sets.engaged.DW.Eva.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
		ammo="Amar Cluster",
		neck="Bathy Choker +1",
		waist="Reiki Yotai", --7
		left_ear="Eabani Earring",
		right_ear="Infused Earring",
		left_ring="Defending Ring",
		back=gear.Rosmerta_EVA,
        })

    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.Eva.LowHaste, {
		left_ear="Cessance Earring",
		left_ring="Ilabrat Ring",
        })

    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.Eva.LowHaste, {
		left_ear="Digni. Earring",
        })

    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
		left_ring="Ilabrat Ring",
        })

    -- 30% Magic Haste (56% DW to cap or 26% with DW4 or 31 with DW3)
    sets.engaged.DW.MidHaste = {
	--  1258acc --	
		ammo="Coiste Bodhar",
        head="Malignance Chapeau", --6/6
        body="Malignance Tabard", --9/9
        hands="Adhemar Wrist. +1",
        legs="Malignance Tights", --7/7
        feet=gear.Herculean.Feet_TRPLacc,
		neck="Mirage Stole +2",
		waist="Reiki Yotai", --7
		left_ear="Eabani Earring", --4
		right_ear="Suppanomimi", --5
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back=gear.Rosmerta_STP, 
        } -- 31%

    sets.engaged.DW.Eva.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
		ammo="Amar Cluster",
		neck="Bathy Choker +1",
		waist="Reiki Yotai", --7
		left_ear="Infused Earring",
		right_ear="Eabani Earring",
		left_ring="Defending Ring",
		back=gear.Rosmerta_EVA,
        })

    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.Eva.MidHaste, {
		left_ear="Cessance Earring",
		left_ring="Ilabrat Ring",
        })

    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste.MidAcc, {
		left_ear="Digni. Earring",
        })

    sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
		left_ring="Ilabrat Ring",
        })
        
    -- 35% Magic Haste (51% DW to cap or 21% with Dw4 or 25 with DW3)
    sets.engaged.DW.HighHaste = {
	--  1267acc --		
		ammo="Coiste Bodhar",
        head="Malignance Chapeau", --6/6
        body="Malignance Tabard", --9/9
        hands="Adhemar Wrist. +1",
        legs="Malignance Tights", --7/7
        feet=gear.Herculean.Feet_TRPLacc,
		neck="Mirage Stole +2",
		waist="Reiki Yotai", --7
		left_ear="Eabani Earring", --4
		right_ear="Hashi. Earring +2", 
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back=gear.Rosmerta_STP, 
        } -- 26%

    sets.engaged.DW.Eva.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
		ammo="Amar Cluster",
		neck="Bathy Choker +1",
		waist="Reiki Yotai", --7
		left_ear="Infused Earring",
		right_ear="Eabani Earring",
		left_ring="Defending Ring",
		back=gear.Rosmerta_EVA,
        }) -- 22%

    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.Eva.HighHaste, {
		left_ear="Cessance Earring",
		left_ring="Ilabrat Ring",
        })

    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {
		left_ear="Digni. Earring",
        })

    sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        })

    -- 43% Magic Haste (37% DW to cap or 7% with DW4 or 11 with DW3)
    sets.engaged.DW.MaxHaste = {
	--  1258acc -- 
		ammo="Coiste Bodhar",
        head="Malignance Chapeau", --6/6
        body="Malignance Tabard", --9/9
        hands="Adhemar Wrist. +1",
        legs="Malignance Tights", --7/7
        feet=gear.Herculean.Feet_TRPLacc,
		neck="Mirage Stole +2",
		waist="Reiki Yotai", --7
		left_ear="Eabani Earring", --4
		right_ear="Hashi. Earring +2", 
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back=gear.Rosmerta_STP,  
        } --11%

    sets.engaged.DW.Eva.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
		ammo="Amar Cluster",
		neck="Bathy Choker +1",
		waist="Reiki Yotai", --7
		left_ear="Infused Earring",
		right_ear="Eabani Earring",
		left_ring="Defending Ring",
		back=gear.Rosmerta_EVA,
        })

    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.Eva.MaxHaste, {
		waist="Reiki Yotai",
		left_ring="Ilabrat Ring",
        }) --6%

    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {
		left_ear="Digni. Earring",
        })

    sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
		ammo="Coiste Bodhar",
		left_ring="Ilabrat Ring",
        })
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        head="Nyame Helm", --6/6
        body="Nyame Mail", --9/9
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches", --7/7
        feet="Nyame Sollerets",
		left_ring="Defending Ring",
        } --
    
    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)

    sets.engaged.Eva.DT = set_combine(sets.engaged.Eva, sets.engaged.Hybrid)

    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)

    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)

    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)



    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)

    sets.engaged.DW.Eva.DT = set_combine(sets.engaged.DW.Eva, sets.engaged.Hybrid)

    sets.engaged.DW.MidAcc.DT = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)

    sets.engaged.DW.HighAcc.DT = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)

    sets.engaged.DW.STP.DT = set_combine(sets.engaged.DW.STP, sets.engaged.Hybrid)



    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.Eva.DT.LowHaste = set_combine(sets.engaged.DW.Eva.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.MidAcc.DT.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.HighAcc.DT.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.STP.DT.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.Hybrid)



    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.Eva.DT.MidHaste = set_combine(sets.engaged.DW.Eva.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.MidAcc.DT.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.HighAcc.DT.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.STP.DT.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.Hybrid)



    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.Eva.DT.HighHaste = set_combine(sets.engaged.DW.Eva.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.MidAcc.DT.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.HighAcc.DT.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.STP.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste.STP, sets.engaged.Hybrid)



    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.DW.Eva.DT.MaxHaste = set_combine(sets.engaged.DW.Eva.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.DW.MidAcc.DT.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.DW.HighAcc.DT.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.DW.STP.DT.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.Hybrid)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.magic_burst = set_combine(sets.midcast['Blue Magic'].Magical, {
        body="Samnuha Coat", --(8)
        hands="Amalric Gages +1", --(5)
        left_ring="Mujin Band", --(5)
        --back="Seshaw Cape", --5
        })

    sets.Kiting = {legs="Carmine Cuisses +1"}
    sets.Learning = {hands="Assim. Bazu. +3"}
    sets.latent_refresh = {waist="Fucho-no-obi"}

    sets.buff.Doom = {	
		--left_ring="Eshmun's Ring", 
		right_ring="Purity Ring", 
		waist="Gishdubar Sash",
		}
	
	sets.Legion = {
		left_ear="Ouesk Earring",
		left_ring="Chirich Ring +1",
	}
	
	sets.Tizona_Sakpata = {
		main="Tizona", 
		sub="Sakpata's Sword",
		}
	sets.Tizona_Zant = {
		main="Tizona", 
		sub="Zantetsuken",
		}		
	
	sets.Tizona_Bunzi = {
		main="Tizona", 
		sub="Bunzi's Rod",
		}
	
	sets.Tizona_Seq = {
		main="Tizona", 
		sub="Sequence",
		}
		
	sets.Tizona_TP = {
		main="Tizona", 
		sub="Thibron",
		}

	sets.Naegling_TP = {
		main="Naegling", 
		sub="Thibron",
		}

	sets.Sequence_Naegling = {
		main="Sequence", 
		sub="Naegling",
		}
		
	sets.Sequence_TP = {
		main="Sequence", 
		sub="Thibron",
		}	

		
	
	sets.Cleave = {
		main="Maxentius",
		sub="Bunzi's Rod",
		}
		
	sets.Maxentius_TP = {
		main="Maxentius",
		sub="Thibron",
	}

end

-------------------------------------------------------------------------------------------------------------------

-- Job-specific hooks for standard casting events.

-------------------------------------------------------------------------------------------------------------------



-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.

-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.

function job_precast(spell, action, spellMap, eventArgs)

equip(sets[state.WeaponSet.current])

    if unbridled_spells:contains(spell.english) and not state.Buff['Unbridled Learning'] then

        eventArgs.cancel = true

        windower.send_command('@input /ja "Unbridled Learning" <me>; wait 4; input /ma "'..spell.name..'" '..spell.target.name)

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
		
		elseif spell.type == "WeaponSkill" and spell.target.distance > 5 and player.status == 'Engaged' then -- Cancel WS If You Are Out Of Range --
		cancel_spell()
		add_to_chat(123, spell.name..' Canceled: [Out of Range]')
		return

    end

end



function job_post_precast(spell, action, spellMap, eventArgs)

    if spell.type == 'WeaponSkill' then

        if elemental_ws:contains(spell.name) then

            -- Matching double weather (w/o day conflict).

            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then

                equip({waist="Hachirin-no-Obi"})

            -- Target distance under 1.7 yalms.

            elseif spell.target.distance < (1.7 + spell.target.model_size) then

                equip({waist="Orpheus's Sash"})

            -- Matching day and weather.

            elseif spell.element == world.day_element and spell.element == world.weather_element then

                equip({waist="Hachirin-no-Obi"})

            -- Target distance under 8 yalms.

            elseif spell.target.distance < (8 + spell.target.model_size) then

                equip({waist="Orpheus's Sash"})

            -- Match day or weather.

            elseif spell.element == world.day_element or spell.element == world.weather_element then

                equip({waist="Hachirin-no-Obi"})

            end

        end

    end

end



-- Run after the default midcast() is done.

-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.

function job_post_midcast(spell, action, spellMap, eventArgs)

    -- Add enhancement gear for Chain Affinity, etc.

    if spell.skill == 'Blue Magic' then

        for buff,active in pairs(state.Buff) do

            if active and sets.buff[buff] then

                equip(sets.buff[buff])

            end

        end

        if spellMap == 'Magical' then

            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then

                equip({waist="Hachirin-no-Obi"})

            end

        end

        if spellMap == 'Healing' and spell.target.type == 'SELF' then

            equip(sets.midcast['Blue Magic'].HealingSelf)

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

equip(sets[state.WeaponSet.current])

    if not spell.interrupted then

        if spell.english == "Dream Flower" then

            send_command('@timers c "Dream Flower ['..spell.target.name..']" 90 down spells/00098.png')

        elseif spell.english == "Soporific" then

            send_command('@timers c "Sleep ['..spell.target.name..']" 90 down spells/00259.png')

        elseif spell.english == "Sheep Song" then

            send_command('@timers c "Sheep Song ['..spell.target.name..']" 60 down spells/00098.png')

        elseif spell.english == "Yawn" then

            send_command('@timers c "Yawn ['..spell.target.name..']" 60 down spells/00098.png')

        elseif spell.english == "Entomb" then

            send_command('@timers c "Entomb ['..spell.target.name..']" 60 down spells/00547.png')

        end

    end

end



-------------------------------------------------------------------------------------------------------------------

-- Job-specific hooks for non-casting events.

-------------------------------------------------------------------------------------------------------------------



-- Called when a player gains or loses a buff.

-- buff == buff gained or lost

-- gain == true if the buff was gained, false if it was lost.

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

        disable('main', 'sub', 'neck' 'range', 'ammo')

    else

        enable('main', 'sub', 'neck', 'range', 'ammo')

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

    th_update(cmdParams, eventArgs)

end



function update_combat_form()

    if DW == true then

        state.CombatForm:set('DW')

    elseif DW == false then

        state.CombatForm:reset()

    end

end



-- Custom spell mapping.

-- Return custom spellMap value that can override the default spell mapping.

-- Don't return anything to allow default spell mapping to be used.

function job_get_spell_map(spell, default_spell_map)

    if spell.skill == 'Blue Magic' then

        for category,spell_list in pairs(blue_magic_maps) do

            if spell_list:contains(spell.english) then

                return category

            end

        end

    end

end



-- Modify the default idle set after it was constructed.

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

    if state.IdleMode.value == 'Learning' then

       equip(sets.Learning)

       disable('hands')

    else

        enable('hands')

    end



    return idleSet

end



-- Modify the default melee set after it was constructed.

function customize_melee_set(meleeSet)

    if state.TreasureMode.value == 'Fulltime' then

        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
	
	if world.zone == "LegionA" then 
		meleeSet = set_combine(meleeSet, sets.Legion)
	end
    
	end

	

    return meleeSet

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


function determine_haste_group()

    classes.CustomMeleeGroups:clear()

    if DW == true then

        if DW_needed < 12 then

            classes.CustomMeleeGroups:append('MaxHaste')

        elseif DW_needed > 11 and DW_needed < 22 then

            classes.CustomMeleeGroups:append('HighHaste')

        elseif DW_needed > 21 and DW_needed < 28 then

            classes.CustomMeleeGroups:append('MidHaste')

        elseif DW_needed > 27 and DW_needed < 38 then

            classes.CustomMeleeGroups:append('LowHaste')

        elseif DW_needed > 37 then

            classes.CustomMeleeGroups:append('')

        end

    end

end


function update_active_abilities()

    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false

    state.Buff['Efflux'] = buffactive['Efflux'] or false

    state.Buff['Diffusion'] = buffactive['Diffusion'] or false

end



-- State buff checks that will equip buff gear and mark the event as handled.

function apply_ability_bonuses(spell, action, spellMap)

    if state.Buff['Burst Affinity'] and (spellMap == 'Magical' or spellMap == 'MagicalLight' or spellMap == 'MagicalDark' or spellMap == 'Breath') then

        if state.MagicBurst.value then

            equip(sets.magic_burst)

        end

        equip(sets.buff['Burst Affinity'])

    end

    if state.Buff.Efflux and spellMap == 'Physical' then

        equip(sets.buff['Efflux'])

    end

    if state.Buff.Diffusion and (spellMap == 'Buffs' or spellMap == 'BlueSkill') then

        equip(sets.buff['Diffusion'])

    end



    if state.Buff['Burst Affinity'] then equip (sets.buff['Burst Affinity']) end

    if state.Buff['Efflux'] then equip (sets.buff['Efflux']) end

    if state.Buff['Diffusion'] then equip (sets.buff['Diffusion']) end

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



windower.register_event('zone change', 

    function()

        send_command('gi ugs true')

    end

)
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(1, 12)
    elseif player.sub_job == 'RDM' then
        set_macro_page(1, 12)
    else
        set_macro_page(1, 12)
    end
end

function set_lockstyle()
    --send_command('wait 6; input /lockstyleset 17')
	send_command('wait 8; input /lockstyleset 80')
end

