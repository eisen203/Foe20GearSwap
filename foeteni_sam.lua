
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
    state.Buff['Meikyo Shisui'] = buffactive['Meikyo Shisui'] or false
	state.Buff['Hasso'] = buffactive['Hasso'] or false
	state.Buff['Doom'] = buffactive['Doom'] or false
	state.Buff['Curse'] = buffactive['Curse'] or false
	state.Buff['Seigan'] = buffactive['Seigan'] or false


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

    state.OffenseMode:options('Zanshin', 'Normal')

    state.WeaponskillMode:options('Normal', 'cap')
	--'Proc')

    state.HybridMode:options('Normal', 'DT')

    state.IdleMode:options('Normal', 'DT')
	
	state.WeaponLock = M(false, 'Weapon Lock')

	state.WeaponSet = M{['description']='Weapon Set', 'Empy', 'Aeonic', 'Soboro', 'Lance'}
	
	send_command('bind @w gs c toggle WeaponLock')
	
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
    state.AutoWSList = M{['description']='Auto WS List', 'OFF', 'Fudo', 'Shoha', '3step1', '4step1', '5step1'}
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
	
	sets.precast.JA['Blade Bash'] = {hands="Sakonji Kote +2",}
	sets.precast.JA['Meikyo Shisui'] = {feet="Sak. Sune-Ate +1",}
	sets.precast.JA['Warding Circle'] = {head="Wakido Kabuto +3",}
	sets.precast.JA['Shikikoyo'] = {legs="Sakonji Haidate +1",}
	sets.precast.JA['Meditate'] = {
		head="Wakido Kabuto +3",
		hands="Sakonji Kote +3",
		back=gear.SAMcape_TP,
		}
	

    -- Fast cast sets for spells

    sets.precast.FC = {
		ammo="Sapience Orb",
		neck="Voltsurge Torque", --4
		left_ear="Etiolation Earring", --1
		right_ear="Loquac. Earring", --2
		left_ring="Kishar Ring", --4
		right_ring="Prolix Ring", --5
        }
		
     sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
          neck="Magoraga Beads",
          })

    sets.Enmity = {
		ammo="Sapience Orb",
		neck="Unmoving Collar +1",
		left_ear="Friomisi Earring",
		right_ear="Cryptic Earring",
		left_ring="Supershear Ring",
		right_ring="Eihwaz Ring",
		back="Reiki Cloak",
          }

    sets.precast.JA['Provoke'] = sets.Enmity
    sets.precast.JA['Warcry'] = sets.Enmity
	
sets.precast.JA['Jump'] = {
    ammo="Coiste Bodhar",
    head="Kasuga Kabuto +3",
    body="Kasuga Domaru +3",
    hands="Crusher Gauntlets",
	legs="Kasuga Haidate +3",
	feet="Tatena. Sune. +1",
    neck="Sam. Nodowa +2",
    waist="Ioskeha Belt +1",
    left_ear="Dedition Earring", 
    right_ear="Kasuga Earring +1",
    left_ring="Ilabrat Ring",
	--left_ring="Niqmaddu Ring",
    right_ring="Chirich Ring +1",
	back=gear.SAMcape_TP,
        }

sets.precast.JA['High Jump'] = set_combine(sets.precast.JA['Jump'], {
	})


    ------------------------------------------------------------------------------------------------

    ------------------------------------- Weapon Skill Sets ----------------------------------------

    ------------------------------------------------------------------------------------------------


-- general STR based ws
sets.precast.WS = {
	ammo="Knobkierrie",
    head="Nyame Helm", 
    body="Sakonji Domaru +3", 
    hands="Kasuga Kote +3", 
    legs="Nyame Flanchard",
    feet="Nyame Sollerets", 
    neck="Sam. Nodowa +2", 
    waist="Sailfi Belt +1", 
    left_ear="Moonshade Earring", 
    right_ear="Thrud Earring",
    left_ring="Epaminondas's Ring",
	right_ring="Ephramad's Ring",
   -- right_ring="Beithir Ring",
    back=gear.SAMcape_WSD,
        } -- default set
		
	sets.precast.WS.cap = set_combine(sets.precast.WS, {
		--legs="Mpaca's Hose",
		feet="Kas. Sune-Ate +3",
	})	
	
	sets.precast.WS.Proc = set_combine(sets.engaged, {
		hands = "Wakido Kote +3",
	})

sets.precast.WS_Hybrid = set_combine(sets.precast.WS, {
	body="Nyame Mail", 
	hands="Nyame Gauntlets",
	waist="Orpheus's Sash",
})

	sets.precast.WS['Tachi: Jinpu'] = sets.precast.WS_Hybrid 
		sets.precast.WS['Tachi: Jinpu'].Proc = sets.precast.WS.Proc
		sets.precast.WS['Tachi: Jinpu'].cap = sets.precast.WS_Hybrid 
	
	sets.precast.WS['Tachi: Kagero'] = sets.precast.WS_Hybrid 	
		sets.precast.WS['Tachi: Kagero'].Proc = sets.precast.WS.Proc
		sets.precast.WS['Tachi: Kagero'].cap = sets.precast.WS_Hybrid 	

	sets.precast.WS['Tachi: Goten'] = sets.precast.WS_Hybrid 	
		sets.precast.WS['Tachi: Goten'].Proc = sets.precast.WS.Proc 
		sets.precast.WS['Tachi: Goten'].cap = sets.precast.WS_Hybrid 

	sets.precast.WS['Tachi: Koki'] = sets.precast.WS_Hybrid 
		sets.precast.WS['Tachi: Koki'].Proc = sets.precast.WS.Proc
		sets.precast.WS['Tachi: Koki'].cap = sets.precast.WS_Hybrid 
	
sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {
	body="Sakonji Domaru +3", 
	})
	
	sets.precast.WS['Impulse Drive'].cap = set_combine(sets.precast.WS.cap, {
	body="Sakonji Domaru +3", 
	})
	
    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Midcast Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------
    sets.Enmity = {
		ammo="Sapience Orb",
		neck="Unmoving Collar +1",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Supershear Ring",
		right_ring="Eihwaz Ring",
		back="Reiki Cloak",
          }

    sets.precast.JA['Provoke'] = sets.Enmity
    ------------------------------------------------------------------------------------------------

    ----------------------------------------- Idle Sets --------------------------------------------

    ------------------------------------------------------------------------------------------------



sets.idle = {
    ammo="Staunch Tathlum",
	head="Nyame Helm",
	body="Sacro Breastplate",
	hands="Nyame Gauntlets",
	legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Sanctity Necklace",
    waist="Flume Belt",
    left_ear="Odnowa Earring +1", 
	right_ear="Infused Earring",
    left_ring="Defending Ring",
    right_ring="Shneddick Ring",
	back=gear.SAMcape_TP,
}

sets.idle.DT = set_combine(sets.idle, {
	head="Nyame Helm",
	body="Nyame Mail",
	hands="Nyame Gauntlets",
	legs="Nyame Flanchard",
	feet="Nyame Sollerets",
	neck="Bathy Choker +1",
	right_ear="Odnowa Earring",
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
    head="Kasuga Kabuto +3",
    body="Kasuga Domaru +3",
    hands="Tatena. Gote +1",
	legs="Kasuga Haidate +3",
	feet="Tatena. Sune. +1",
    neck="Sam. Nodowa +2",
    waist="Ioskeha Belt +1",
    left_ear="Dedition Earring", 
    right_ear="Kasuga Earring +1",
    left_ring="Ilabrat Ring",
	--left_ring="Niqmaddu Ring",
    right_ring="Chirich Ring +1",
	back=gear.SAMcape_TP,
}
 --55zanshin as SAM 
sets.engaged.Zanshin = set_combine(sets.engaged, {
	--head="Kasuga Kabuto +3",
	--body="Kasuga Domaru +3", --16
	body="Tatena. Harama. +1", --8
	hands="Tatena. Gote +1", --6
	legs="Tatena. Haidate +1", --6
	feet="Tatena. Sune. +1", --6
	--neck="Moonlight Nodowa", --10
	--right_ear="Unkai Mimikazari",
	
})  --81 zanshin total

    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Hybrid Sets -------------------------------------------

    ------------------------------------------------------------------------------------------------

sets.engaged.DT = {
    ammo="Coiste Bodhar",
    head="Kasuga Kabuto +3",
    body="Kasuga Domaru +3",
    hands="Wakido Kote +3",
    legs="Kasuga Haidate +3",
    feet="Mpaca's Boots", 
    neck="Sam. Nodowa +2",
    waist="Ioskeha Belt +1",
	left_ear="Dedition Earring", 
    right_ear="Kasuga Earring +1",
    left_ring="Defending Ring",
    right_ring="Chirich Ring +1",
	back=gear.SAMcape_TP,
	}

sets.engaged.Zanshin.DT = set_combine(sets.engaged.DT, {
	head="Kasuga Kabuto +3",
	body="Kasuga Domaru +3",
	hands="Tatena. Gote +1",
	--legs="Tatena. Haidate +1",
	feet="Tatena. Sune. +1",
	--neck="Moonlight Nodowa",
	--left_ear="Odnowa Earring +1",
})



    ------------------------------------------------------------------------------------------------

    ---------------------------------------- Special Sets ------------------------------------------

    ------------------------------------------------------------------------------------------------

	

    sets.buff.Doom = {

        }
		
	sets.Hasso = {
		hands = "Wakido Kote +3",
	}
		
	sets.TPbonus = {
		head = "Mpaca's Cap",
		}

	sets.maxTP = {
		head="Nyame Helm", 
		right_ear="Lugra Earring +1",
		}
		
	sets.Meikyo = {
		head="Nyame Helm", 
		--feet="Sak. Sune-Ate +3",
		right_ear="Lugra Earring +1",	
	}

    sets.TreasureHunter = {
		head=gear.Valorous.Head_TH,
		feet=gear.Valorous.Feet_TH,
		waist="Chaac Belt",
	}
	
	sets.Empy = {
		main="Masamune",
		sub="Utu Grip",
	}	

	sets.Aeonic = {
		main="Dojikiri Yasutsuna",
		sub="Utu Grip",
	}	

	sets.Soboro = {
		main="Soboro Sukehiro",
		sub="Utu Grip",
	}		
	
	sets.Lance = {
		main="Shining One",
		sub="Utu Grip",
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
		elseif spell.type == "WeaponSkill" and spell.target.distance > 5 and player.status == 'Engaged' then -- Cancel WS If You Are Out Of Range --
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
        if player.tp > 2750 then
            equip(sets.maxTP)
		elseif player.tp < 1750 then 
			equip(sets.TPbonus)
		else

			-- use Lugra + moonshade
		--[[if world.time >= (17*60) or world.time <= (7*60) then
			equip(sets.Lugra)
			
		else
			-- do nothing.
	]]
        end
    end
	
	if state.Buff['Meikyo Shisui'] and spell.type:lower() == 'weaponskill' then 
		equip(sets.Meikyo)
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
    --[[if state.Buff['Hundred Fists'] then 
		meleeSet = set_combine(meleeSet, sets['Hundred Fists'])
    end]]
    --if state.Buff['Impetus'] and state.WeaponSet.value~='Spharai' then 
--[[	if state.Buff['Hasso'] then 
		--add_to_chat(100,'> > > > Should swap to Hasso mode')
        meleeSet = set_combine(meleeSet, sets.Hasso)
    end]]
	if not state.Buff['Hasso'] and not state.Buff['Seigan'] then 
		send_command('@input /ja Hasso')
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

        disable('main', 'range', 'ammo' )

    else

        enable('main', 'range', 'ammo')

    end

end

function update_melee_groups()

end



-- Select default macro book on initial load or subjob change.

function select_default_macro_book()

    -- Default macro set/book: (set, book)

    --if player.sub_job == 'SAM' then

        set_macro_page(1, 5)

    --else

        set_macro_page(1, 5)

    --end

end



function set_lockstyle()

    send_command('wait 8; input /lockstyleset 54')

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

			if state.AutoWSList.value == 'Shoha' and player.tp >= 1000 and wsnum == 0 then
                    send_command('input /ws Tachi: Shoha <t>')
                    wsnum = 0
			end	

			if state.AutoWSList.value == 'Fudo' and player.tp >= 1000 and wsnum == 0 then
                    send_command('input /ws Tachi: Fudo <t>')
                    wsnum = 0
			end				

			if state.AutoWSList.value == '3step1' and player.tp >= 1000 and wsnum == 0 then
                    send_command('input /ws Tachi:Shoha <t>')
                    wsnum = wsnum + 1
 
                elseif state.AutoWSList.value == '3step1' and player.tp >= 1000 and wsnum == 1 then 
                    send_command('input /ws Tachi: Kasha <t>')
                    wsnum = wsnum + 1
 
                elseif state.AutoWSList.value == '3step1' and player.tp >= 1000 and wsnum == 2 then
                    send_command('input /ws Tachi: Fudo <t>')
                    wsnum = 0
					add_to_chat(100," WS #0 nigga")
			end
			
			if state.AutoWSList.value == '4step1' and player.tp >= 1000 and wsnum == 0 then
                    send_command('input /ws Tachi: Fudo <t>')
                    wsnum = wsnum + 1
 
                elseif state.AutoWSList.value == '4step1' and player.tp >= 1000 and wsnum == 1 then 
                    send_command('input /ws Tachi: Kasha <t>')
                    wsnum = wsnum + 1
 
                elseif state.AutoWSList.value == '4step1' and player.tp >= 1000 and wsnum == 2 then
                    send_command('input /ws Tachi: Shoha <t>')
                    wsnum = wsnum + 1
 
                elseif state.AutoWSList.value == '4step1' and player.tp >= 1000 and wsnum == 3 then
                    send_command('input /ws Tachi: Fudo  <t>')
                    wsnum = 0
					add_to_chat(100," WS #0 nigga")
			end
			
			if state.AutoWSList.value == '5step1' and player.tp >= 1000 and wsnum == 0 then
                    send_command('input /ws Tachi: Shoha <t>')
                    wsnum = wsnum + 1
 
                elseif state.AutoWSList.value == '5step1' and player.tp >= 1000 and wsnum == 1 then 
                    send_command('input /ws Tachi: Fudo <t>')
                    wsnum = wsnum + 1
 
                elseif state.AutoWSList.value == '5step1' and player.tp >= 1000 and wsnum == 2 then
                    send_command('input /ws Tachi: Kasha <t>')
                    wsnum = wsnum + 1
 
                elseif state.AutoWSList.value == '5step1' and player.tp >= 1000 and wsnum == 3 then
                    send_command('input /ws Tachi: Shoha  <t>')
                    wsnum = wsnum +1
                elseif state.AutoWSList.value == '5step1' and player.tp >= 1000 and wsnum == 4 then
                    send_command('input /ws Tachi: Fudo  <t>')
                    wsnum = 0
					add_to_chat(100," WS #0 nigga")
			end
				
				end
			end
		end)