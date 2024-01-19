-- Original: Motenten / Modified: Arislan

-- Haste/DW Detection Requires Gearinfo Addon



-------------------------------------------------------------------------------------------------------------------

--  Keybinds

-------------------------------------------------------------------------------------------------------------------



--  Modes:      [ F9 ]              Cycle Offense Modes

--              [ CTRL+F9 ]         Cycle Hybrid Modes

--              [ ALT+F9 ]          Cycle Ranged Modes

--              [ WIN+F9 ]          Cycle Weapon Skill Modes

--              [ F10 ]             Emergency -PDT Mode

--              [ ALT+F10 ]         Toggle Kiting Mode

--              [ F11 ]             Emergency -MDT Mode

--              [ F12 ]             Update Current Gear / Report Current Status

--              [ CTRL+F12 ]        Cycle Idle Modes

--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode

--              [ WIN+C ]           Toggle Capacity Points Mode

--              [ WIN+` ]           Toggle use of Luzaf Ring.

--              [ WIN+Q ]           Quick Draw shot mode selector.

--

--  Abilities:  [ CTRL+- ]          Quick Draw primary shot element cycle forward.

--              [ CTRL+= ]          Quick Draw primary shot element cycle backward.

--              [ ALT+- ]           Quick Draw secondary shot element cycle forward.

--              [ ALT+= ]           Quick Draw secondary shot element cycle backward.

--              [ CTRL+[ ]          Quick Draw toggle target type.

--              [ CTRL+] ]          Quick Draw toggle use secondary shot.


--

--  Weapons:    [ WIN+E/R ]         Cycles between available Weapon Sets

--              [ WIN+W ]           Toggle Ranged Weapon Lock

--

--

--              (Global-Binds.lua contains additional non-job-related keybinds)





-------------------------------------------------------------------------------------------------------------------

--  Custom Commands (preface with /console to use these in macros)

-------------------------------------------------------------------------------------------------------------------



--  gs c qd                         Uses the currently configured shot on the target, with either <t> or

--                                  <stnpc> depending on setting.

--  gs c qd t                       Uses the currently configured shot on the target, but forces use of <t>.

--

--  gs c cycle mainqd               Cycles through the available steps to use as the primary shot when using

--                                  one of the above commands.

--  gs c cycle altqd                Cycles through the available steps to use for alternating with the

--                                  configured main shot.

--  gs c toggle usealtqd            Toggles whether or not to use an alternate shot.

--  gs c toggle selectqdtarget      Toggles whether or not to use <stnpc> (as opposed to <t>) when using a shot.

--

--  gs c toggle LuzafRing           Toggles use of Luzaf Ring on and off





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

    -- QuickDraw Selector

    state.Mainqd = M{['description']='Primary Shot', 'Fire Shot', 'Ice Shot', 'Wind Shot', 'Earth Shot', 'Thunder Shot', 'Water Shot'}

    state.Altqd = M{['description']='Secondary Shot', 'Fire Shot', 'Ice Shot', 'Wind Shot', 'Earth Shot', 'Thunder Shot', 'Water Shot'}

    state.UseAltqd = M(false, 'Use Secondary Shot')

    state.SelectqdTarget = M(false, 'Select Quick Draw Target')

    state.IgnoreTargetting = M(false, 'Ignore Targetting')



    state.QDMode = M{['description']='Quick Draw Mode', 'STP', 'Enhance', 'Potency', 'TH'}



    state.Currentqd = M{['description']='Current Quick Draw', 'Main', 'Alt'}



    -- Whether to use Luzaf's Ring

    state.LuzafRing = M(true, "Luzaf's Ring")

    -- Whether a warning has been given for low ammo

    state.warned = M(false)



    elemental_ws = S{'Aeolian Edge', 'Leaden Salute', 'Wildfire'}



    include('Mote-TreasureHunter')



    -- For th_action_check():

    -- JA IDs for actions that always have TH: Provoke, Animated Flourish

    info.default_ja_ids = S{35, 204}

    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish

    info.default_u_ja_ids = S{201, 202, 203, 205, 207}



    define_roll_values()



    lockstyleset = 1

end



-------------------------------------------------------------------------------------------------------------------

-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.

-------------------------------------------------------------------------------------------------------------------



-- Setup vars that are user-dependent.  Can override this function in a sidecar file.

function user_setup()

    state.OffenseMode:options('Normal', 'Glass')

    state.HybridMode:options('Normal', 'DT')

    state.RangedMode:options('Normal', 'Acc', 'Recycle', 'STP', 'Critical')

    state.WeaponskillMode:options('Normal', 'Acc')

    state.IdleMode:options('Normal', 'DT', 'Refresh')

	wsnum = 0
	
	rotation = 0

    state.WeaponSet = M{['description']='Weapon Set', 'DeathPenalty_DualWield_Dagger', 'Fomalhaut_DualWield_Dagger', 'DeathPenalty_SingleWield_Dagger', 'DeathPenalty_SingleWield_Sword', 'DeathPenalty_DualWield_Sword', 'Fomalhaut_SingleWield_Dagger', 'Fomalhaut_SingleWield_Sword', 'Fomalhaut_DualWield_Sword', 'Ataktos_Dagger', 'Ataktos_Sword'}

    state.CP = M(false, "Capacity Points Mode")

    state.WeaponLock = M(false, 'Weapon Lock')



    gear.RAbullet = "Chrono Bullet"
	gear.RAccbullet = "Chrono Bullet"
    gear.WSbullet = "Chrono Bullet"
	--gear.WSbullet = "Eminent Bullet"
    gear.MAbullet = "Living Bullet"
	--gear.MAbullet = "Eminent Bullet"
	gear.QDbullet = "Living Bullet"
    options.ammo_warning_limit = 10



    -- Additional local binds

    send_command('lua l gearinfo')

	
	state.AutoWS = M{['description']='Auto WS','OFF','true'}
    send_command('bind @z gs c cycle AutoWS')
    state.AutoWSList = M{['description']='Auto WS List', 'OFF', 'Leaden', 'SavageBld', 'AE'}
	send_command('bind @x gs c cycle AutoWSList')

    send_command('bind ^insert gs c cycleback mainqd')

    send_command('bind ^delete gs c cycle mainqd')

    send_command('bind ^home gs c cycle altqd')

    send_command('bind ^end gs c cycleback altqd')

    send_command('bind ^pageup gs c toggle selectqdtarget')

    send_command('bind ^pagedown gs c toggle usealtqd')

	
	send_command ('bind ^l gs c toggle LuzafRing')
	
    send_command('bind @q gs c cycle QDMode')

    send_command('bind @w gs c toggle WeaponLock')

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

    send_command('unbind ^numlock')

    send_command('unbind ^numpad/')

    send_command('unbind ^numpad*')

    send_command('unbind ^numpad-')

    send_command('unbind ^numpad8')

    send_command('unbind ^numpad4')

    send_command('unbind ^numpad5')

    send_command('unbind ^numpad6')

    send_command('unbind ^numpad1')

    send_command('unbind ^numpad2')

    send_command('unbind numpad0')



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



    sets.precast.JA['Snake Eye'] = {legs="Lanun Trews +1"}

    sets.precast.JA['Wild Card'] = {feet="Lanun Bottes +3"}

    sets.precast.JA['Random Deal'] = {body="Lanun Frac +3"}


-- take out the main and range slots to stop losing TP when engaged
sets.precast.CorsairRoll = {
	main={ name="Rostam", augments={'Path: C',}}, 
	range="Compensator",
    head="Lanun Tricorne +3",
    hands="Chasseur's Gants +3",
    neck="Regal Necklace",
	back=gear.CORcape_Snp,
	}


	--sets.precast.CorsairRoll.Duration = {main="Lanun Knife", range="Compensator", neck="Regal Necklace",}
    sets.precast.CorsairRoll.Duration = {main={ name="Rostam", augments={'Path: C',}}, range="Compensator"}

    sets.precast.CorsairRoll.LowerDelay = {back="Gunslinger's Cape"}

    sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Chas. Culottes +2"})

    sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Chass. Bottes +2"})

    sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Chass. Tricorne +2"})

    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac +2"})

    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +3"})



    sets.precast.LuzafRing = set_combine(sets.precast.CorsairRoll, {right_ring="Luzaf's Ring",})

    sets.precast.FoldDoubleBust = {hands="Lanun Gants +1"}



    sets.precast.Waltz = {

       -- body="Passion Jacket",

       -- neck="Phalaina Locket",

       -- ring1="Asklepian Ring",

        waist="Gishdubar Sash",

        }



    sets.precast.Waltz['Healing Waltz'] = {}



sets.precast.FC = {
    head="Carmine Mask +1", 
    body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}}, --10
    hands="Leyline Gloves", 
    legs="Malignance Tights",
    feet="Carmine Greaves +1",
    neck="Voltsurge Torque",
    waist="Flume Belt",
    left_ear="Etiolation Earring",
    right_ear="Loquac. Earring",
    left_ring="Prolix Ring",
    right_ring="Kishar Ring",
    back=gear.CORcape_Snp,
	}



    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})



    -- (10% Snapshot from JP Gifts) snapshot/rapidshot

sets.precast.RA = {
    ammo=gear.RAbullet,
    head=gear.Taeon.Head_Snp, --10/0
    body="Oshosi Vest", --12/0
    hands="Carmine Fin. Ga. +1", --8/11
    legs="Adhemar Kecks +1", --10/13
    feet="Meg. Jam. +2", --10/0
	neck="Comm. Charm +2", --4/0
    waist="Yemaya Belt", --0/5
    back=gear.CORcape_Snp, --10/0
	right_ring="Crepuscular Ring", --3/0
	} --67/60 snapshot / 29 rapid shot	



    sets.precast.RA.Flurry1 = set_combine(sets.precast.RA, {
		
		heads="Chass. Tricone +2", --0/16
        body="Laksa. Frac +3", --0/20

        }) --45/45 snapshot / 65 rapid shot



    sets.precast.RA.Flurry2 = set_combine(sets.precast.RA.Flurry1, {

        --head="Chass. Tricorne +2", --0/16

        --feet="Pursuer's Gaiters", --0/10


        }) --30/30

    sets.precast.CorsairShot = {

        }

    sets.precast.CorsairShot.Potency = {
        ammo=gear.QDbullet,
        head="Laksa. Tricorne +3",
		body="Lanun Frac +3", 
		hands="Carmine Fin. Ga. +1",
		legs="Nyame Flanchard",
		feet="Lanun Bottes +3",
		neck="Comm. Charm +1",
		waist="K. Kachina Belt +1",
		left_ear="Hecate's Earring",
		right_ear="Friomisi Earring",
		left_ring="Dingir Ring",
		right_ring="Crepuscular Ring", --3/0
		back=gear.CORcape_MWSD,
        }

    sets.precast.CorsairShot.STP = {
        ammo=gear.QDbullet,
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Comm. Charm +1",
        left_ear="Crep. Earring",
        right_ear="Dedition Earring",
        left_ring="Ilabrat Ring",
        right_ring="Crepuscular Ring", --3/0
        back=gear.CORcape_rSTP,
        waist="Yemaya Belt", 
        }



    sets.precast.CorsairShot['Light Shot'] = {
        ammo=gear.QDbullet,
        head="Laksa. Tricorne +3",
        body="Chasseur's Frac +2",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Laksa. Bottes +3",
        neck="Comm. Charm +1",
		waist="K. Kachina Belt +1",
        left_ear="Crep. Earring",
        right_ear="Digni. Earring",
        left_ring="Regal Ring",
        right_ring="Crepuscular Ring", --3/0
        back=gear.CORcape_MWSD,
        }



    sets.precast.CorsairShot['Dark Shot'] = sets.precast.CorsairShot['Light Shot']

    sets.precast.CorsairShot.Enhance = set_combine(sets.precast.CorsairShot.STP, { 
	
		feet="Chass. Bottes +2"
	
	})



    ------------------------------------------------------------------------------------------------

    ------------------------------------- Weapon Skill Sets ----------------------------------------

    ------------------------------------------------------------------------------------------------



sets.precast.WS ={
	ammo=gear.WSbullet,
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Chasseur's Gants +3",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Comm. Charm +1",
    waist="K. Kachina Belt +1",
    left_ear="Moonshade Earring",
    right_ear="Telos Earring",
    left_ring="Ephramad's Ring",
    right_ring="Epaminondas's Ring",
    back=gear.CORcape_RWSD,
}



    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
--[[
        ammo=gear.RAccbullet,

        ear1="Beyla Earring",

        ear2="Telos Earring",

        neck="Iskur Gorget",

        ring2="Hajduk Ring +1",

        waist="K. Kachina Belt +1",]]

        })



sets.precast.WS['Last Stand'] = {
	ammo=gear.WSbullet,
    head="Nyame Helm",
    body="Nyame Mail",
	--body="Ikenga's Vest",
    hands="Chasseur's Gants +3",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Moonshade Earring",
    right_ear="Telos Earring",
    left_ring="Ephramad's Ring",
    right_ring="Epaminondas's Ring",
	back=gear.CORcape_RWSD,
	}



    sets.precast.WS['Last Stand'].Acc = set_combine(sets.precast.WS['Last Stand'], {

        })
		
sets.precast.WS['Detonator'] = {
	ammo=gear.WSbullet,
    head="Nyame Helm",
	--body="Nyame Mail",
    body="Ikenga's Vest",
    hands="Chasseur's Gants +3",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Iskur Gorget",
    waist="Yemaya Belt",
    left_ear="Moonshade Earring",
    right_ear="Telos Earring",
    left_ring="Ephramad's Ring",
    right_ring="Epaminondas's Ring",
	ba--ck=gear.CORcape_RWSD,
	}



sets.precast.WS['Wildfire'] = 	{
	ammo=gear.MAbullet,
    head="Nyame Helm",
    body="Lanun Frac +3", 
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Lanun Bottes +3",
    neck="Comm. Charm +1",
    waist="K. Kachina Belt",
    left_ear="Ishvara Earring",
    right_ear="Friomisi Earring",
    left_ring="Dingir Ring",
    right_ring="Epaminondas's Ring",
	back=gear.CORcape_MWSD,
        }  



    sets.precast.WS['Hot Shot'] = set_combine(sets.precast.WS, {
		head="Nyame Helm",
		body="Lanun Frac +3", 
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Lanun Bottes +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Chas. Earring +2",
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back=gear.CORcape_MWSD,
	})



sets.precast.WS['Leaden Salute'] = --sets.midcast.RA
	{
	ammo=gear.MAbullet,
    head="Pixie Hairpin +1",
    body="Lanun Frac +3",
	--body="Nyame Mail",
	hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Lanun Bottes +3",
    neck="Comm. Charm +1",
    waist="K. Kachina Belt +1",
    left_ear="Moonshade Earring",
    right_ear="Friomisi Earring",
    left_ring="Archon Ring",
    right_ring="Epaminondas's Ring",
	back=gear.CORcape_MWSD,
        } 



    sets.precast.WS['Evisceration'] = {
        head="Adhemar Bonnet +1",
        body="Meg. Cuirie +2",
        hands="Adhemar Wrist. +1",
        legs="Meg. Chausses +2",
        feet=gear.Herculean.Feet_CRITDMG,
        neck="Fotia Gorget",
        left_ear="Mache Earring +1",
        right_ear="Odr Earring",
        left_ring="Ephramad's Ring",
        right_ring="Regal Ring",
        back=gear.CORcape_STP,
        waist="Sailfi Belt +1",

        }



    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {

        })



sets.precast.WS['Savage Blade'] = {
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Rep. Plat. Medal",
    waist="Sailfi Belt +1",
    --left_ear="Moonshade Earring",
    right_ear="Telos Earring",
    left_ring="Ephramad's Ring",
    right_ring="Epaminondas's Ring",
    back=gear.CORcape_Savage,
    }



sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
	})



    sets.precast.WS['Swift Blade'] = set_combine(sets.precast.WS['Savage Blade'], {

        })



    sets.precast.WS['Swift Blade'].Acc = set_combine(sets.precast.WS['Swift Blade'], {

        })



sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS['Swift Blade'], {
    head="Adhemar Bonnet +1", 
    body="Nyame Mail", 
    hands="Adhemar Wrist. +1", 
    legs="Meg. Chausses +2",
    feet=gear.Herculean.Feet_TRPLacc,
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Moonshade Earring", 
    right_ear="Telos Earring",
    left_ring="Ephramad's Ring",
    right_ring="Regal Ring",
    back=gear.CORcape_STP,
    }) --MND



sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {

	})

sets.precast.WS['Circle Blade'] = {

	}


sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Wildfire'], {
	neck="Fotia Gorget",
	waist="Fotia Belt",
	ear1="Moonshade Earring",
	})



    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Midcast Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------



    sets.midcast.FastRecast = sets.precast.FC



    sets.midcast.SpellInterrupt = {

        legs="Carmine Cuisses +1", --20

        ring1="Evanescence Ring", --5

        }



    sets.midcast.Cure = {

        neck="Incanter's Torque",

        --ear1="Roundel Earring",

        ear2="Mendi. Earring",

        --ring1="Lebeche Ring",

        --ring2="Haoma's Ring",

        --waist="Bishop's Sash",

        }



    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt



    sets.midcast.CorsairShot = {

        }
		

    sets.precast.CorsairShot.Potency = {
        ammo=gear.QDbullet,
        head="Laksa. Tricorne +3",
		body="Lanun Frac +3", 
		hands="Carmine Fin. Ga. +1",
		legs="Nyame Flanchard",
		feet="Lanun Bottes +3",
		neck="Comm. Charm +1",
		waist="K. Kachina Belt +1",
		left_ear="Hecate's Earring",
		right_ear="Friomisi Earring",
		left_ring="Dingir Ring",
		right_ring="Crepuscular Ring", --3/0
		back=gear.CORcape_MWSD,
        }

    sets.midcast.CorsairShot.STP = {
        ammo=gear.QDbullet,
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Comm. Charm +1",
        left_ear="Crep. Earring",
        right_ear="Telos Earring",
        left_ring="Ilabrat Ring",
        right_ring="Crepuscular Ring", --3/0
        back=gear.CORcape_rSTP,
        waist="Yemaya Belt", 
        }

    sets.midcast.CorsairShot['Light Shot'] = {
        ammo=gear.QDbullet,
        head="Laksa. Tricorne +3",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Laksa. Bottes +3",
        neck="Comm. Charm +1",
		waist="K. Kachina Belt +1",
        left_ear="Crep. Earring",
        right_ear="Digni. Earring",
        left_ring="Regal Ring",
        right_ring="Crepuscular Ring", --3/0
        back=gear.CORcape_MWSD,
        }



    sets.midcast.CorsairShot['Dark Shot'] = sets.midcast.CorsairShot['Light Shot']

    sets.midcast.CorsairShot.Enhance = set_combine(sets.midcast.CorsairShot.STP, { 
	
		feet="Chass. Bottes +2"
	
	})



    -- Ranged gear

sets.midcast.RA = {
   -- head="Ikenga's Hat",
	head="Malignance Chapeau",
    --body="Nisroch Jerkin",
	body="Ikenga's Vest",
    hands="Ikenga's Gloves",
    legs="Chas. Culottes +2",
   -- feet="Ikenga's Clogs",
	feet="Malignance Boots",
    neck="Iskur Gorget",
    waist="Yemaya Belt",
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    left_ring="Ilabrat Ring",
    right_ring="Crepuscular Ring",
    back=gear.CORcape_rSTP,
	}



	sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {
		waist="K. Kachina Belt +1",
        left_ring="Hajduk Ring", 
		right_ring="Cacoethic Ring +1",
        })



    sets.midcast.RA.Recycle = set_combine(sets.midcast.RA, {
		body="Laksa. Frac +3",
		hands="Ikenga's Gloves",
		legs="Adhemar Kecks +1",
		right_ear="Chas. Earring +2",
        })



    sets.midcast.RA.Critical = set_combine(sets.midcast.RA, {
        --head="Meghanada Visor +2",

        --body="Meg. Cuirie +2",

        --hands="Mummu Wrists +2",

        --legs="Mummu Kecks +2",

        --feet="Osh. Leggings +1",

        --ring1="Begrudging Ring",

        --ring2="Mummu Ring",
		body="Nisroch Jerkin",
		right_ear="Odr Earring",
        waist="K. Kachina Belt +1", 

        })



    sets.midcast.RA.STP = set_combine(sets.midcast.RA, {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Chas. Culottes +2",
		feet="Malignance Boots",
        })



    sets.TripleShot = set_combine(sets.midcast.RA, {

        head="Oshosi Mask +1", --5

        body="Chasseur's Frac +2", --13

        --hands="Oshosi Gloves", --3
		hands="Lanun Gants +3",

        legs="Oshosi Trousers +1", --6

        feet="Oshosi Leggings +1", --3

        }) --27


    sets.TripleShotCritical = set_combine(sets.TripleShot, {
--[[
        head="Meghanada Visor +2",

        waist="K. Kachina Belt +1", ]]

        })





    ------------------------------------------------------------------------------------------------

    ----------------------------------------- Idle Sets --------------------------------------------

    ------------------------------------------------------------------------------------------------



    sets.resting = {}



sets.idle = {
	ammo=gear.RAbullet,
	head="Nyame Helm",
	body="Nyame Mail",
	hands="Nyame Gauntlets",
	legs="Nyame Flanchard",
	feet="Nyame Sollerets",
    neck="Loricate Torque +1",
    waist="Flume Belt",
    left_ear="Eabani Earring",
    right_ear="Etiolation Earring",
    left_ring="Defending Ring",
    right_ring="Shneddick Ring",
    back=gear.CORcape_Snp,
	}



    sets.idle.DT = set_combine(sets.idle, {

        })



    sets.idle.Refresh = set_combine(sets.idle, {

        })



    sets.idle.Town = set_combine(sets.idle, {
		head="Shaded Specs.",
		body="Goldsmith's Apron",
		neck="Goldsm. Torque",
		left_ring="Craftmaster's Ring",
        })





    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Defense Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------



    sets.defense.PDT = sets.idle.DT



    sets.defense.MDT = {

        }



    sets.Kiting = {}





    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Engaged Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------



    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous

    -- sets if more refined versions aren't defined.

    -- If you create a set with both offense and defense modes, the offense mode should be first.

    -- EG: sets.engaged.Dagger.Accuracy.Evasion



sets.engaged = {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +2",
    feet="Malignance Boots",
    neck="Iskur Gorget",
    waist="Sailfi Belt +1",
    left_ear="Cessance Earring",
    right_ear="Dedition Earring",
    left_ring="Chirich Ring +1",
    right_ring="Epona's Ring",
    back=gear.CORcape_STP,
	}



    sets.engaged.LowAcc = set_combine(sets.engaged, {

        })



    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {

        })



    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {

        })



    sets.engaged.STP = set_combine(sets.engaged, {

        })



    -- * DNC Subjob DW Trait: +15%

    -- * NIN Subjob DW Trait: +25%



    -- No Magic Haste (74% DW to cap)

sets.engaged.DW = {
    head="Adhemar Bonnet +1",
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, 
	--head="Malignance Chapeau",
    --body="Malignance Tabard",
    hands="Adhemar Wrist. +1",
    legs="Chas. Culottes +2",
    feet=gear.Herculean.Feet_TRPLacc,
    neck="Iskur Gorget",
    waist="Reiki Yotai",
	left_ear="Eabani Earring",
    --left_ear="Crep. Earring",
    right_ear="Dedition Earring",
    left_ring="Chirich Ring +1",
    right_ring="Epona's Ring",
    back=gear.CORcape_STP,
} --37



    sets.engaged.DW.LowAcc = set_combine(sets.engaged.DW, {

        })



    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW.LowAcc, {

        })



    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {

        })



    sets.engaged.DW.STP = set_combine(sets.engaged.DW, {

        })



    -- 15% Magic Haste (67% DW to cap)

sets.engaged.DW.LowHaste = set_combine(sets.engaged.DW, {

        })



    sets.engaged.DW.LowAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {

        })



    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, {

        })



    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {

        })



    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.LowHaste, {

        })



    -- 30% Magic Haste (56% DW to cap)

sets.engaged.DW.MidHaste = set_combine(sets.engaged.DW, {

        })



    sets.engaged.DW.LowAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {

        })



    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, {

        })



    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {

        })



    sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.MidHaste, {

        })



    -- 35% Magic Haste (51% DW to cap)

sets.engaged.DW.HighHaste = set_combine(sets.engaged.DW, {

        })



    sets.engaged.DW.LowAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {

        })



    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, {

        })



    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {

        })



    sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.HighHaste, {

        })



    -- 45% Magic Haste (36% DW to cap)

sets.engaged.DW.MaxHaste = set_combine(sets.engaged.DW, {

        })



    sets.engaged.DW.LowAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {

        })



    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {

        })



    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {

        })



    sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {

        })



    sets.engaged.DW.MaxHastePlus = set_combine(sets.engaged.DW.MaxHaste, {})

    sets.engaged.DW.LowAcc.MaxHastePlus = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {})

    sets.engaged.DW.MidAcc.MaxHastePlus = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {})

    sets.engaged.DW.HighAcc.MaxHastePlus = set_combine(sets.engaged.DW.HighAcc.MaxHaste, {})

    sets.engaged.DW.STP.MaxHastePlus = set_combine(sets.engaged.DW.STP.MaxHaste, {})





    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Hybrid Sets -------------------------------------------

    ------------------------------------------------------------------------------------------------



sets.engaged.Hybrid = {
    head="Malignance Chapeau",
    body="Malignance Tabard",
	--body="Nyame Mail",
    --hands="Malignance Gloves",
	hands="Nyame Gauntlets",
    legs="Malignance Tights",
	--legs="Nyame Flanchard",
    --feet="Malignance Boots",
	feet="Nyame Sollerets",
    neck="Iskur Gorget",
    waist="Sailfi Belt +1",
    left_ear="Odnowa Earring +1",
    right_ear="Dedition Earring",
    left_ring="Defending Ring",
    right_ring="Epona's Ring",
	back=gear.CORcape_STP,
        }



    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)

    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.engaged.Hybrid)

    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)

    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)

    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)



    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)

    sets.engaged.DW.LowAcc.DT = set_combine(sets.engaged.DW.LowAcc, sets.engaged.Hybrid)

    sets.engaged.DW.MidAcc.DT = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)

    sets.engaged.DW.HighAcc.DT = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)

    sets.engaged.DW.STP.DT = set_combine(sets.engaged.DW.STP, sets.engaged.Hybrid)



    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.LowAcc.DT.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.MidAcc.DT.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.HighAcc.DT.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.STP.DT.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.Hybrid)



    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.LowAcc.DT.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.MidAcc.DT.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.HighAcc.DT.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.STP.DT.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.Hybrid)



    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.LowAcc.DT.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.MidAcc.DT.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.HighAcc.DT.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.STP.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste.STP, sets.engaged.Hybrid)



    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.DW.LowAcc.DT.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.DW.MidAcc.DT.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.DW.HighAcc.DT.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.DW.STP.DT.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.Hybrid)



    sets.engaged.DW.DT.MaxHastePlus = set_combine(sets.engaged.DW.MaxHastePlus, sets.engaged.Hybrid)

    sets.engaged.DW.LowAcc.DT.MaxHastePlus = set_combine(sets.engaged.DW.LowAcc.MaxHastePlus, sets.engaged.Hybrid)

    sets.engaged.DW.MidAcc.DT.MaxHastePlus = set_combine(sets.engaged.DW.MidAcc.MaxHastePlus, sets.engaged.Hybrid)

    sets.engaged.DW.HighAcc.DT.MaxHastePlus = set_combine(sets.engaged.DW.HighAcc.MaxHastePlus, sets.engaged.Hybrid)

    sets.engaged.DW.STP.DT.MaxHastePlus = set_combine(sets.engaged.DW.STP.MaxHastePlus, sets.engaged.Hybrid)





    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Special Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------



    sets.buff.Doom = {

        --neck="Nicander's Necklace", --20

        --ring1={name="Eshmun's Ring", bag="wardrobe3"}, --20

        --ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20

        waist="Gishdubar Sash", --10

        }



    sets.FullTP = {ear1="Ishvara Earring"}

    sets.Obi = {waist="Hachirin-no-Obi"}

    --sets.CP = {back="Mecisto. Mantle"}

    --sets.Reive = {neck="Ygnas's Resolve +1"}



    sets.TreasureHunter = {
		body=gear.Herculean.Body_TH,
		hands=gear.Herculean.Hands_TH,
		waist="Chaac Belt",
	}



    sets.DeathPenalty_DualWield_Dagger = {
		main={ name="Rostam", augments={'Path: A',}}, 
		--sub="Demers. Degen +1",
		sub="Gleti's Knife",
		--sub="Tauret",
		range="Death Penalty"}

    sets.DeathPenalty_DualWield_Sword = {main="Naegling", sub="Demers. Degen +1", range="Death Penalty"}
	
	sets.DeathPenalty_SingleWield_Sword = {main="Naegling", sub="Nusku Shield", range="Death Penalty"}

    sets.DeathPenalty_SingleWield_Dagger = {main={ name="Rostam", augments={'Path: A',}}, sub="Nusku Shield", range="Death Penalty"}
	
	--sets.Armageddon_M = {main={name={ name="Rostam", augments={'Path: A',}},, bag="wardrobe3"}, sub="Tauret", range="Armageddon"}

    --sets.Armageddon_R = {main="Fettering Blade", sub="Nusku Shield", range="Armageddon"}

    sets.Fomalhaut_SingleWield_Dagger = {main={ name="Rostam", augments={'Path: A',}}, sub="Nusku Shield", range="Fomalhaut"}

    sets.Fomalhaut_SingleWield_Sword = {main="Naegling", sub="Nusku Shield", range="Fomalhaut"}
	
	sets.Fomalhaut_DualWield_Dagger = {main={ name="Rostam", augments={'Path: A',}}, sub="Gleti's Knife", range="Fomalhaut"}
	
	sets.Fomalhaut_DualWield_Sword = {main="Naegling", sub="Demers. Degen +1", range="Fomalhaut"}

    sets.Ataktos_Sword = {
		main="Naegling", 
		--sub="Demers. Degen +1", 
		sub="Gleti's Knife",
		--sub="Nusku Shield",
		range="Ataktos"
		}
	
	sets.Ataktos_Dagger = {
		main={ name="Rostam", augments={'Path: A',}}, 
		--sub="Demers. Degen +1",
		--sub="Gleti's Knife",
		sub="Tauret",
		range="Death Penalty"}


end





-------------------------------------------------------------------------------------------------------------------

-- Job-specific hooks for standard casting events.

-------------------------------------------------------------------------------------------------------------------



-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.

-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.

function job_precast(spell, action, spellMap, eventArgs)

    equip(sets[state.WeaponSet.current])

    -- Check that proper ammo is available if we're using ranged attacks or similar.

    if spell.action_type == 'Ranged Attack' or spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then

        do_bullet_checks(spell, spellMap, eventArgs)

    end



    -- Gear

    if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") then
	
		rotation = 0

        if player.status ~= 'Engaged' then

            equip(sets.precast.CorsairRoll.Duration)

        end

        if state.LuzafRing.value then

            equip(sets.precast.LuzafRing)

        end

    end



    if spell.english == 'Fold' and buffactive['Bust'] == 2 then

        if sets.precast.FoldDoubleBust then

            equip(sets.precast.FoldDoubleBust)

            eventArgs.handled = true

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
			--[[elseif spell.type == "WeaponSkill" and spell.target.distance > 5 and player.status == 'Engaged' then -- Cancel WS If You Are Out Of Range --
			cancel_spell()
			add_to_chat(123, spell.name..' Canceled: [Out of Range]')
			return]]
        
		end

    end

end



function job_post_precast(spell, action, spellMap, eventArgs)

    if spell.action_type == 'Ranged Attack' then

        if flurry == 2 then

            equip(sets.precast.RA.Flurry2)

        elseif flurry == 1 then

            equip(sets.precast.RA.Flurry1)

        end

    elseif spell.type == 'WeaponSkill' then

        -- Replace TP-bonus gear if not needed.

        if spell.english == 'Leaden Salute' or spell.english == 'Aeolian Edge' and player.tp > 2900 then

            equip(sets.FullTP)

        end

        if spell.type == 'WeaponSkill' and (spell.english == 'Leaden Salute' or spell.english == 'Wildfire') then

            -- Matching double weather (w/o day conflict).

            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then

                equip({waist="Hachirin-no-Obi"})

            -- Target distance under 1.7 yalms.

            elseif spell.target.distance < (1.7 + spell.target.model_size) then

                equip({waist="Orpheus's Sash"})

            -- Matching day and weather.

            elseif spell.element == world.day_element and spell.element == world.weather_element then

                equip({waist="Hachirin-no-Obi"})

            -- Target distance under 7 yalms.

            elseif spell.target.distance < (7 + spell.target.model_size) then

                equip({waist="Orpheus's Sash"})

            -- Match day or weather.

            elseif spell.element == world.day_element or spell.element == world.weather_element then

                equip({waist="Hachirin-no-Obi"})

            end

        end

    end

end



function job_post_midcast(spell, action, spellMap, eventArgs)

    if spell.type == 'CorsairShot' then

        if (spell.english ~= 'Light Shot' and spell.english ~= 'Dark Shot') then

            -- Matching double weather (w/o day conflict).

            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then

                equip({waist="Hachirin-no-Obi"})

            -- Target distance under 1.7 yalms.

            elseif spell.target.distance < (1.7 + spell.target.model_size) then

               equip({waist="Orpheus's Sash"})

            -- Matching day and weather.

            elseif spell.element == world.day_element and spell.element == world.weather_element then

                equip({waist="Hachirin-no-Obi"})

            -- Target distance under 7 yalms.

            elseif spell.target.distance < (7 + spell.target.model_size) then

                equip({waist="Orpheus's Sash"})

            -- Match day or weather.

            elseif spell.element == world.day_element or spell.element == world.weather_element then

                equip({waist="Hachirin-no-Obi"})

            end

            if state.QDMode.value == 'Enhance' then

                equip(sets.midcast.CorsairShot.Enhance)

            elseif state.QDMode.value == 'TH' then

                equip(sets.midcast.CorsairShot)

                equip(sets.TreasureHunter)

            elseif state.QDMode.value == 'STP' then

                equip(sets.midcast.CorsairShot.STP)

            end

        end

    elseif spell.action_type == 'Ranged Attack' then

        if buffactive['Triple Shot'] then

            equip(sets.TripleShot)

            if buffactive['Aftermath: Lv.3'] and player.equipment.ranged == "Armageddon" then

                equip(sets.TripleShotCritical)

            end

        elseif buffactive['Aftermath: Lv.3'] and player.equipment.ranged == "Armageddon" then

            equip(sets.midcast.RA.Critical)

        end

    end

end



-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.

function job_aftercast(spell, action, spellMap, eventArgs)

    equip(sets[state.WeaponSet.current])

    if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") and not spell.interrupted then

        display_roll_info(spell)

    end

    if spell.english == "Light Shot" then

        send_command('@timers c "Light Shot ['..spell.target.name..']" 60 down abilities/00195.png')

    end
	
	if spell.english == "Crooked Cards" and rotation == 0 then 
	
			send_command('wait 600; input /t Foeteni <<<--- CROOKED CARDS~!! --->>> <<<--- TIME TO ROLL~!! --->>> <<<--- CROOKED CARDS~!! --->>> <<<--- TIME TO ROLL~!! --->>>')
			send_command('wait 605; input /t Foeteni <<<--- CROOKED CARDS~!! --->>> <<<--- TIME TO ROLL~!! --->>> <<<--- CROOKED CARDS~!! --->>> <<<--- TIME TO ROLL~!! --->>>')
			
			rotation=1

		end	 

end



function job_buff_change(buff,gain)

-- If we gain or lose any flurry buffs, adjust gear.

    if S{'flurry'}:contains(buff:lower()) then

        if not gain then

            flurry = nil

            --add_to_chat(122, "Flurry status cleared.")

        end

        if not midaction() then

            handle_equipping_gear(player.status)

        end

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



-- Handle notifications of general user state change.

function job_state_change(stateField, newValue, oldValue)

    if state.WeaponLock.value == true then

        disable('waist')

    else

        enable('waist')

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



-- Modify the default idle set after it was constructed.

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



-- Handle auto-targetting based on local setup.

function job_auto_change_target(spell, action, spellMap, eventArgs)

    if spell.type == 'CorsairShot' then

        if state.IgnoreTargetting.value == true then

            state.IgnoreTargetting:reset()

            eventArgs.handled = true

        end



        eventArgs.SelectNPCTargets = state.SelectqdTarget.value

    end

end



-- Set eventArgs.handled to true if we don't want the automatic display to be run.

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



    local qd_msg = '(' ..string.sub(state.QDMode.value,1,1).. ')'



    local e_msg = state.Mainqd.current

    if state.UseAltqd.value == true then

        e_msg = e_msg .. '/'..state.Altqd.current

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

        ..string.char(31,060).. ' QD' ..qd_msg.. ': '  ..string.char(31,001)..e_msg.. string.char(31,002)..  ' |'

        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'

        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'

        ..string.char(31,002)..msg)



    eventArgs.handled = true

end



-------------------------------------------------------------------------------------------------------------------

-- Utility functions specific to this job.

-------------------------------------------------------------------------------------------------------------------



--Read incoming packet to differentiate between Haste/Flurry I and II

windower.register_event('action',

    function(act)

        --check if you are a target of spell

        local actionTargets = act.targets

        playerId = windower.ffxi.get_player().id

        isTarget = false

        for _, target in ipairs(actionTargets) do

            if playerId == target.id then

                isTarget = true

            end

        end

        if isTarget == true then

            if act.category == 4 then

                local param = act.param

                if param == 845 and flurry ~= 2 then

                    --add_to_chat(122, 'Flurry Status: Flurry I')

                    flurry = 1

                elseif param == 846 then

                    --add_to_chat(122, 'Flurry Status: Flurry II')

                    flurry = 2

              end

            end

        end

    end)



function determine_haste_group()

    classes.CustomMeleeGroups:clear()

    if DW == true then

        if DW_needed <= 11 then

            classes.CustomMeleeGroups:append('MaxHaste')

        elseif DW_needed > 11 and DW_needed <= 21 then

            classes.CustomMeleeGroups:append('MaxHastePlus')

        elseif DW_needed > 21 and DW_needed <= 27 then

            classes.CustomMeleeGroups:append('HighHaste')

        elseif DW_needed > 27 and DW_needed <= 31 then

            classes.CustomMeleeGroups:append('MidHaste')

        elseif DW_needed > 31 and DW_needed <= 42 then

            classes.CustomMeleeGroups:append('LowHaste')

        elseif DW_needed > 42 then

            classes.CustomMeleeGroups:append('')

        end

    end

end



function job_self_command(cmdParams, eventArgs)

    if cmdParams[1] == 'qd' then

        if cmdParams[2] == 't' then

            state.IgnoreTargetting:set()

        end



        local doqd = ''

        if state.UseAltqd.value == true then

            doqd = state[state.Currentqd.current..'qd'].current

            state.Currentqd:cycle()

        else

            doqd = state.Mainqd.current

        end



        send_command('@input /ja "'..doqd..'" <t>')

    end



    gearinfo(cmdParams, eventArgs)

end


function define_roll_values()

    rolls = {

        ["Corsair's Roll"] =    {lucky=5, unlucky=9, bonus="Experience Points"},

        ["Ninja Roll"] =        {lucky=4, unlucky=8, bonus="Evasion"},

        ["Hunter's Roll"] =     {lucky=4, unlucky=8, bonus="Accuracy"},

        ["Chaos Roll"] =        {lucky=4, unlucky=8, bonus="Attack"},

        ["Magus's Roll"] =      {lucky=2, unlucky=6, bonus="Magic Defense"},

        ["Healer's Roll"] =     {lucky=3, unlucky=7, bonus="Cure Potency Received"},

        ["Drachen Roll"] =      {lucky=4, unlucky=8, bonus="Pet Magic Accuracy/Attack"},

        ["Choral Roll"] =       {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},

        ["Monk's Roll"] =       {lucky=3, unlucky=7, bonus="Subtle Blow"},

        ["Beast Roll"] =        {lucky=4, unlucky=8, bonus="Pet Attack"},

        ["Samurai Roll"] =      {lucky=2, unlucky=6, bonus="Store TP"},

        ["Evoker's Roll"] =     {lucky=5, unlucky=9, bonus="Refresh"},

        ["Rogue's Roll"] =      {lucky=5, unlucky=9, bonus="Critical Hit Rate"},

        ["Warlock's Roll"] =    {lucky=4, unlucky=8, bonus="Magic Accuracy"},

        ["Fighter's Roll"] =    {lucky=5, unlucky=9, bonus="Double Attack Rate"},

        ["Puppet Roll"] =       {lucky=3, unlucky=7, bonus="Pet Magic Attack/Accuracy"},

        ["Gallant's Roll"] =    {lucky=3, unlucky=7, bonus="Defense"},

        ["Wizard's Roll"] =     {lucky=5, unlucky=9, bonus="Magic Attack"},

        ["Dancer's Roll"] =     {lucky=3, unlucky=7, bonus="Regen"},

        ["Scholar's Roll"] =    {lucky=2, unlucky=6, bonus="Conserve MP"},

        ["Naturalist's Roll"] = {lucky=3, unlucky=7, bonus="Enh. Magic Duration"},

        ["Runeist's Roll"] =    {lucky=4, unlucky=8, bonus="Magic Evasion"},

        ["Bolter's Roll"] =     {lucky=3, unlucky=9, bonus="Movement Speed"},

        ["Caster's Roll"] =     {lucky=2, unlucky=7, bonus="Fast Cast"},

        ["Courser's Roll"] =    {lucky=3, unlucky=9, bonus="Snapshot"},

        ["Blitzer's Roll"] =    {lucky=4, unlucky=9, bonus="Attack Delay"},

        ["Tactician's Roll"] =  {lucky=5, unlucky=8, bonus="Regain"},

        ["Allies' Roll"] =      {lucky=3, unlucky=10, bonus="Skillchain Damage"},

        ["Miser's Roll"] =      {lucky=5, unlucky=7, bonus="Save TP"},

        ["Companion's Roll"] =  {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},

        ["Avenger's Roll"] =    {lucky=4, unlucky=8, bonus="Counter Rate"},

    }

end



function display_roll_info(spell)

    rollinfo = rolls[spell.english]

    local rollsize = (state.LuzafRing.value and string.char(129,157)) or ''



    if rollinfo then

        add_to_chat(001, string.char(129,115).. '  ' ..string.char(31,210)..spell.english..string.char(31,001)..

            ' : '..rollinfo.bonus.. ' ' ..string.char(129,116).. ' ' ..string.char(129,195)..

            '  Lucky: ' ..string.char(31,204).. tostring(rollinfo.lucky)..string.char(31,001).. ' /' ..

            ' Unlucky: ' ..string.char(31,167).. tostring(rollinfo.unlucky)..string.char(31,002)..

            '  ' ..rollsize)

    end

end





-- Determine whether we have sufficient ammo for the action being attempted.

function do_bullet_checks(spell, spellMap, eventArgs)

    local bullet_name

    local bullet_min_count = 0



    if spell.type == 'WeaponSkill' then

        if spell.skill == "Marksmanship" then

            if spell.english == 'Wildfire' or spell.english == 'Leaden Salute' then

                -- magical weaponskills

                bullet_name = gear.MAbullet

            else

                -- physical weaponskills

                bullet_name = gear.WSbullet

            end

        else

            -- Ignore non-ranged weaponskills

            return

        end

    elseif spell.type == 'CorsairShot' then

        bullet_name = gear.QDbullet

    elseif spell.action_type == 'Ranged Attack' then

        bullet_name = gear.RAbullet

        if buffactive['Triple Shot'] then

            bullet_min_count = 3

        end

    end



    local available_bullets = player.inventory[bullet_name] or player.wardrobe[bullet_name]



    -- If no ammo is available, give appropriate warning and end.

    if not available_bullets then

        if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then

            add_to_chat(104, 'No Quick Draw ammo left.  Using what\'s currently equipped ('..player.equipment.ammo..').')

            return

        elseif spell.type == 'WeaponSkill' and player.equipment.ammo == gear.RAbullet then

            add_to_chat(104, 'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: '..player.equipment.ammo..').')

            return

        else

            add_to_chat(104, 'No ammo ('..tostring(bullet_name)..') available for that action.')

            eventArgs.cancel = false

            return

        end

    end



    -- Don't allow shooting or weaponskilling with ammo reserved for quick draw.

   --[[ if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and available_bullets.count <= bullet_min_count then

        add_to_chat(104, 'No ammo will be left for Quick Draw.  Cancelling.')

        eventArgs.cancel = true

        return

    end  ]]



    -- Low ammo warning.

    if spell.type ~= 'CorsairShot' and state.warned.value == false

        and available_bullets.count > 1 and available_bullets.count <= options.ammo_warning_limit then

        local msg = '*****  LOW AMMO WARNING: '..bullet_name..' *****'

        --local border = string.repeat("*", #msg)

        local border = ""

        for i = 1, #msg do

            border = border .. "*"

        end



        add_to_chat(104, border)

        add_to_chat(104, msg)

        add_to_chat(104, border)



        state.warned:set()

    elseif available_bullets.count > options.ammo_warning_limit and state.warned then

        state.warned:reset()

    end

end



windower.register_event('zone change',

    function()

        if player.sub_job == 'NIN' or player.sub_job == 'DNC' then

            send_command('gi ugs true')

        end

    end

)



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



function check_moving()

    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then

        if state.Auto_Kite.value == false and moving then

            state.Auto_Kite:set(true)

        elseif state.Auto_Kite.value == true and moving == false then

            state.Auto_Kite:set(false)

        end

    end

end



-- Select default macro book on initial load or subjob change.

function select_default_macro_book()

    if player.sub_job == 'DNC' then

        set_macro_page(1, 6)

    else

        set_macro_page(1, 6)

    end

end



function set_lockstyle()

    send_command('wait 8; input /lockstyleset ' .. lockstyleset)

end

