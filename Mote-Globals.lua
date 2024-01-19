-------------------------------------------------------------------------------------------------------------------
-- Tables and functions for commonly-referenced gear that job files may need, but
-- doesn't belong in the global Mote-Include file since they'd get clobbered on each
-- update.
-- Creates the 'gear' table for reference in other files.
--
-- Note: Function and table definitions should be added to user, but references to
-- the contained tables via functions (such as for the obi function, below) use only
-- the 'gear' table.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Modify the sets table.  Any gear sets that are added to the sets table need to
-- be defined within this function, because sets isn't available until after the
-- include is complete.  It is called at the end of basic initialization in Mote-Include.
-------------------------------------------------------------------------------------------------------------------
function define_global_sets()
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)", "Liv. Bul. Pouch", "Chr. Bul. Pouch"}
	-- Special gear info that may be useful across jobs.
-- Merling gear --
	gear.Merlinic = {}
		--FastCast
			gear.Merlinic.Head_FC = { name="Merlinic Hood", augments={'Mag. Acc.+21','"Fast Cast"+7',}}
			gear.Merlinic.Feet_FC = { name="Merlinic Crackows", augments={'"Fast Cast"+6','INT+5','Mag. Acc.+12','"Mag.Atk.Bns."+13',}}
			gear.Merlinic.Head_HRTLSS_FC = { name="Merlinic Hood", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','"Fast Cast"+7','MND+2','Mag. Acc.+8',}}
			gear.Merlinic.Body_HRTLSS_FC = { name="Merlinic Jubbah", augments={'"Mag.Atk.Bns."+10','"Fast Cast"+6','MND+9',}}
			gear.Merlinic.Hands_HRTLSS_FC = { name="Merlinic Dastanas", augments={'"Fast Cast"+7','MND+1','Mag. Acc.+4',}}
			gear.Merlinic.Feet_HRTLSS_FC = { name="Merlinic Crackows", augments={'Pet: Attack+16 Pet: Rng.Atk.+16','CHR+8','"Fast Cast"+7','Accuracy+14 Attack+14','Mag. Acc.+10 "Mag.Atk.Bns."+10',}}
		
		--MagicBurst
			gear.Merlinic.Feet_Burst = { name="Merlinic Crackows", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','Magic burst dmg.+9%','CHR+8','Mag. Acc.+3','"Mag.Atk.Bns."+12',}}
		--MAB
			gear.Merlinic.Body_MAB = { name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Occult Acumen"+7','INT+12','Mag. Acc.+4','"Mag.Atk.Bns."+13',}}
		--MACC 
			gear.Merlinic.Body_MACC = { name="Merlinic Jubbah", augments={'Mag. Acc.+23 "Mag.Atk.Bns."+23','Mag. crit. hit dmg. +9%','Mag. Acc.+14','"Mag.Atk.Bns."+13',}}
			gear.Merlinic.Legs_MACC = { name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Mag. crit. hit dmg. +10%','INT+3','Mag. Acc.+14','"Mag.Atk.Bns."+6',}}
			gear.Merlinic.Legs_MACCHRT = { name="Merlinic Shalwar", augments={'Mag. Acc.+23 "Mag.Atk.Bns."+23','"Fast Cast"+2','INT+7','Mag. Acc.+15','"Mag.Atk.Bns."+8',}}
			gear.Merlinic.Feet_ACC = { name="Merlinic Crackows", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Magic burst dmg.+10%','MND+2','Mag. Acc.+14','"Mag.Atk.Bns."+5',}}
		--Occult Acumen 
			gear.Merlinic.Body_Occult = { name="Merlinic Jubbah", augments={'Mag. Acc.+12','"Occult Acumen"+10','CHR+3','"Mag.Atk.Bns."+1',}}
			gear.Merlinic.Hands_Occult = { name="Merlinic Dastanas", augments={'"Occult Acumen"+10','Mag. Acc.+6',}}
			gear.Merlinic.Feet_Occult = { name="Merlinic Crackows", augments={'"Occult Acumen"+10','CHR+8','"Mag.Atk.Bns."+14',}}
		--Drain Sets
			gear.Merlinic.Body_ASPIR = { name="Merlinic Jubbah", augments={'Mag. Acc.+28','"Drain" and "Aspir" potency +10','MND+8','"Mag.Atk.Bns."+14',}}
			gear.Merlinic.Legs_ASPIR = { name="Merlinic Shalwar", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Drain" and "Aspir" potency +10','INT+7','"Mag.Atk.Bns."+10',}}
		--Phalanx sets
			gear.Merlinic.Head_HRTLSS_PHLX = { name="Merlinic Hood", augments={'Mag. Acc.+13','VIT+7','Phalanx +4',}}
			gear.Merlinic.Hands_HRTLSS_PHLX = { name="Merlinic Dastanas", augments={'STR+2','Pet: Mag. Acc.+11','Phalanx +3','Accuracy+9 Attack+9','Mag. Acc.+20 "Mag.Atk.Bns."+20',}}
			gear.Merlinic.Feet_HRTLSS_PHLX = { name="Merlinic Crackows", augments={'Pet: INT+2','Pet: Haste+1','Phalanx +3','Accuracy+20 Attack+20','Mag. Acc.+7 "Mag.Atk.Bns."+7',}}
		--TH Sets	
			gear.Merlinic.Hands_TH = { name="Merlinic Dastanas", augments={'Mag. Acc.+1','"Treasure Hunter"+1','Accuracy+19 Attack+19',}}
			gear.Merlinic.Feet_TH = { name="Merlinic Crackows", augments={'Pet: Attack+2 Pet: Rng.Atk.+2','Potency of "Cure" effect received+3%','"Treasure Hunter"+2','Accuracy+12 Attack+12','Mag. Acc.+20 "Mag.Atk.Bns."+20',}}
		--Refresh Sets--
			gear.Merlinic.Hands_Ref = { name="Merlinic Dastanas", augments={'Pet: Haste+3','Pet: Phys. dmg. taken -4%','"Refresh"+2',}}
			gear.Merlinic.Feet_Ref = { name="Merlinic Crackows", augments={'VIT+1','"Cure" spellcasting time -9%','"Refresh"+2','Accuracy+17 Attack+17','Mag. Acc.+8 "Mag.Atk.Bns."+8',}}
			gear.Merlinic.Legs_Ref = { name="Merlinic Shalwar", augments={'Accuracy+21','DEX+1','"Refresh"+2','Mag. Acc.+15 "Mag.Atk.Bns."+15',}}

-- Chironic gear --
	gear.Chironic = {}
		--MACC
			gear.Chironic.Head_MACC_INT = { name="Chironic Hat", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','"Cure" spellcasting time -2%','INT+9','Mag. Acc.+9','"Mag.Atk.Bns."+13',}}
			gear.Chironic.Hands_MACC_MND = { name="Chironic Gloves", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+10','Mag. Acc.+7',}}
			gear.Chironic.Legs_MACC_INT = { name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Haste+1','CHR+9','Mag. Acc.+14','"Mag.Atk.Bns."+15',}}
			gear.Chironic.Feet_MACC_INT = { name="Chironic Slippers", augments={'Mag. Acc.+30','"Fast Cast"+6','INT+11','"Mag.Atk.Bns."+4',}}
			gear.Chironic.Hands_HRTLSS_FC = { name="Chironic Gloves", augments={'"Fast Cast"+6','INT+3',}}
			gear.Chironic.Legs_HRTLSS_MACC = { name="Chironic Hose", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','"Fast Cast"+1','INT+2','Mag. Acc.+15','"Mag.Atk.Bns."+11',}}
			gear.Chironic.Feet_HRTLSS_FC = { name="Chironic Slippers", augments={'Magic burst dmg.+2%','"Mag.Atk.Bns."+23','"Fast Cast"+6','Accuracy+5 Attack+5',}}
			
--Telchine gear --
	gear.Telchine = {}
		--ENH duration--
			gear.Telchine.Head_dur = { name="Telchine Cap", augments={'"Elemental Siphon"+25','Enh. Mag. eff. dur. +10',}}
			gear.Telchine.Head_durHRT = { name="Telchine Cap", augments={'Enh. Mag. eff. dur. +10',}}
			gear.Telchine.Body_dur = { name="Telchine Chas.", augments={'"Conserve MP"+3','Enh. Mag. eff. dur. +10',}}
			gear.Telchine.Body_durHRT = { name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}}
			gear.Telchine.Hands_dur = { name="Telchine Gloves", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}}
			gear.Telchine.Hands_durHRT = { name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +10',}}
			gear.Telchine.Legs_dur = { name="Telchine Braconi", augments={'Rng.Acc.+3','"Elemental Siphon"+35','Enh. Mag. eff. dur. +10',}}
			gear.Telchine.Legs_durHRT = { name="Telchine Braconi", augments={'Enh. Mag. eff. dur. +10',}}
			gear.Telchine.Feet_dur = { name="Telchine Pigaches", augments={'Pet: "Regen"+2','Enh. Mag. eff. dur. +10',}}
			gear.Telchine.Feet_durHRT = { name="Telchine Pigaches", augments={'Enh. Mag. eff. dur. +10',}}
		--Pet DT/Regen--
			gear.Telchine.Head_petHRT = { name="Telchine Cap", augments={'Pet: Mag. Acc.+20','Pet: "Regen"+3','Pet: Damage taken -4%',}}
			gear.Telchine.Body_pet = { name="Telchine Chas.", augments={'Mag. Evasion+16','Pet: "Regen"+3','Pet: Damage taken -3%',}}
			gear.Telchine.Legs_pet = { name="Telchine Braconi", augments={'Accuracy+9','Pet: "Regen"+3','Pet: Damage taken -4%',}}
			gear.Telchine.Legs_petHRT = { name="Telchine Braconi", augments={'Pet: Attack+15 Pet: Rng.Atk.+15','Pet: "Regen"+2','Pet: Damage taken -2%',}}
			gear.Telchine.Feet_pet = { name="Telchine Pigaches", augments={'Pet: "Regen"+2','Pet: Damage taken -2%',}}
			gear.Telchine.Feet_petHRT = { name="Telchine Pigaches", augments={'Pet: "Regen"+3','Pet: Damage taken -4%',}} 
		--BRD DD
			gear.Telchine.Legs_STP = { name="Telchine Braconi", augments={'Accuracy+19','"Store TP"+5','DEX+8',}}
--Taeon gear --
	gear.Taeon = {}
			--PHalanx
			gear.Taeon.Head_PHLX = { name="Taeon Chapeau", augments={'Phalanx +3',}}
			gear.Taeon.Body_PHLX = { name="Taeon Tabard", augments={'"Snapshot"+5','Phalanx +3',}}
			gear.Taeon.Hands_PHLX = { name="Taeon Gloves", augments={'"Snapshot"+5','Phalanx +3',}}
			gear.Taeon.Legs_PHLX = { name="Taeon Tights", augments={'Phalanx +3',}}
			gear.Taeon.Feet_PHLX = { name="Taeon Boots", augments={'Phalanx +3',}}
			
			--DW
			gear.Taeon.Feet_DW = { name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','DEX+10',}}
			
			--Snapshot
			gear.Taeon.Head_Snp = { name="Taeon Chapeau", augments={'"Snapshot"+5','"Snapshot"+5',}}
			

-- Valorous gear --
	gear.Valorous = {}
		-- Self WS --
			gear.Valorous.Head_STP = { name="Valorous Mask", augments={'Accuracy+18','"Store TP"+8','INT+4','Attack+13',}}
			gear.Valorous.Head_ACC = { name="Valorous Mask", augments={'Accuracy+25 Attack+25','"Store TP"+2','VIT+10','Accuracy+12',}}
			gear.Valorous.Head_WSD = { name="Valorous Mask", augments={'Accuracy+19','Weapon skill damage +4%','AGI+8','Attack+13',}}
			gear.Valorous.Body_ACC = { name="Valorous Mail", augments={'Accuracy+23 Attack+23','"Store TP"+4','DEX+15',}}
			gear.Valorous.Body_WSD = { name="Valorous Mail", augments={'Attack+30','Weapon skill damage +4%','STR+8',}}
			gear.Valorous.Hands_ACC = { name="Valorous Mitts", augments={'Accuracy+21 Attack+21','Sklchn.dmg.+3%','VIT+7','Accuracy+9','Attack+13',}}
			gear.Valorous.Hands_WSD = { name="Valorous Mitts", augments={'Accuracy+17 Attack+17','Weapon skill damage +3%',}}
			gear.Valorous.Legs_ACC = { name="Valor. Hose", augments={'Accuracy+23 Attack+23','VIT+9','Accuracy+15','Attack+9',}}
			gear.Valorous.Feet_ACC = { name="Valorous Greaves", augments={'Accuracy+19 Attack+19','STR+10','Accuracy+15','Attack+12',}}
			gear.Valorous.Feet_WSD = { name="Valorous Greaves", augments={'Attack+29','Weapon skill damage +3%','VIT+2','Accuracy+13',}}
		-- Pet ACC --
			gear.Valorous.Head_PetACC = { name="Valorous Mask", augments={'Pet: Accuracy+27 Pet: Rng. Acc.+27','Pet: "Subtle Blow"+4','Pet: STR+6',}}
			gear.Valorous.Body_PetACC = { name="Valorous Mail", augments={'Pet: Attack+14 Pet: Rng.Atk.+14','Pet: Phys. dmg. taken -3%','Pet: Accuracy+14 Pet: Rng. Acc.+14',}}
			gear.Valorous.Hands_PetACC = { name="Valorous Mitts", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','Pet: "Dbl. Atk."+1',}}
			gear.Valorous.Legs_PetACC = { name="Valor. Hose", augments={'Pet: Accuracy+27 Pet: Rng. Acc.+27','"Dbl.Atk."+1','Pet: VIT+10',}}
			gear.Valorous.Feet_PetACC = { name="Valorous Greaves", augments={'Pet: Accuracy+20 Pet: Rng. Acc.+20','Pet: VIT+3','Pet: Attack+15 Pet: Rng.Atk.+15',}}
		-- STP --
		    gear.Valorous.Body_STP = { name="Valorous Mail", augments={'Accuracy+27','"Store TP"+7','VIT+1','Attack+12',}}
		--Quad Atk--
			gear.Valorous.Hands_Quad = { name="Valorous Mitts", augments={'MND+11','Pet: "Regen"+2','Quadruple Attack +2','Accuracy+18 Attack+18','Mag. Acc.+16 "Mag.Atk.Bns."+16',}}
			gear.Valorous.Feet_Quad = { name="Valorous Greaves", augments={'Attack+17','AGI+9','Quadruple Attack +1','Accuracy+15 Attack+15',}}
		-- Idle --
			gear.Valorous.Head_idle = { name="Valorous Mask", augments={'"Store TP"+5','Rng.Atk.+5','"Refresh"+2','Mag. Acc.+18 "Mag.Atk.Bns."+18',}}
		-- TH --
			gear.Valorous.Head_TH = { name="Valorous Mask", augments={'DEX+5','Pet: VIT+5','"Treasure Hunter"+1','Accuracy+17 Attack+17',}}
			gear.Valorous.Feet_TH = { name="Valorous Greaves", augments={'Pet: Accuracy+11 Pet: Rng. Acc.+11','"Drain" and "Aspir" potency +8','"Treasure Hunter"+2','Accuracy+1 Attack+1',}}
-- Odyssean gear --
	gear.Odyssean = {}
		-- STP --
			gear.Odyssean.Legs_STP = { name="Odyssean Cuisses", augments={'Accuracy+25','"Store TP"+7','DEX+9',}}
		-- ACC --
			gear.Odyssean.Legs_ACCdblatk = { name="Odyssean Cuisses", augments={'Accuracy+21 Attack+21','"Dbl.Atk."+3','DEX+3','Accuracy+12','Attack+15',}}
		-- WSD  --
			gear.Odyssean.Head_WSD = { name="Odyssean Helm", augments={'Accuracy+25','Weapon skill damage +4%','Attack+9',}}
			gear.Odyssean.Hands_WSD = { name="Odyssean Gauntlets", augments={'Weapon skill damage +4%','VIT+10','Accuracy+14','Attack+8',}}
			gear.Odyssean.Hands_WSD2 = { name="Odyssean Gauntlets", augments={'Attack+30','Weapon skill damage +5%',}}
			gear.Odyssean.Legs_WSD = { name="Odyssean Cuisses", augments={'Accuracy+25 Attack+25','Weapon skill damage +3%','CHR+4','Accuracy+6',}}
			
			
--Herculean Sets--
	gear.Herculean = {}
	--Magic--
			gear.Herculean.Head_FC = { name="Herculean Helm", augments={'Mag. Acc.+5','"Fast Cast"+5','STR+8',}}
	--PHLX--
			gear.Herculean.Body_PHLX = { name="Herculean Vest", augments={'Pet: Mag. Acc.+13 Pet: "Mag.Atk.Bns."+13','DEX+6','Phalanx +4','Accuracy+9 Attack+9',}}
			gear.Herculean.Hands_PHLX = { name="Herculean Gloves", augments={'Attack+5','"Mag.Atk.Bns."+13','Phalanx +4','Accuracy+10 Attack+10','Mag. Acc.+5 "Mag.Atk.Bns."+5',}}
	--STR--
			gear.Herculean.Head_STR = { name="Herculean Helm", augments={'Accuracy+25 Attack+25','STR+10',}}
			gear.Herculean.Body_STR = { name="Herculean Vest", augments={'Accuracy+27','"Triple Atk."+3','STR+12','Attack+4',}}
			gear.Herculean.Hands_STR = { name="Herculean Gloves", augments={'STR+11','Attack+29','Accuracy+19 Attack+19',}}
	--ACC--		
			gear.Herculean.Head_ACC = { name="Herculean Helm", augments={'Accuracy+23 Attack+23','"Triple Atk."+2','DEX+8','Accuracy+15','Attack+3',}}
			gear.Herculean.Body_ACC = { name="Herculean Vest", augments={'Mag. Acc.+20','Accuracy+18','"Store TP"+10','Accuracy+19 Attack+19',}}
			gear.Herculean.Hands_ACC = { name="Herculean Gloves", augments={ '"Mag.Atk.Bns."+7','Accuracy+26','"Fast Cast"+5','Accuracy+20 Attack+20','Mag. Acc.+16 "Mag.Atk.Bns."+16',}}
			gear.Herculean.Legs_ACCstp = { name="Herculean Trousers", augments={'Accuracy+24 Attack+24','"Store TP"+6','AGI+9','Accuracy+10','Attack+9',}}
			gear.Herculean.Legs_ACC = { name="Herculean Trousers", augments={'Accuracy+21 Attack+21','Weapon skill damage +2%','DEX+11','Accuracy+15','Attack+1',}}
			gear.Herculean.Feet_ACC = { name="Herculean Boots", augments={'Accuracy+22 Attack+22','Magic dmg. taken -1%','DEX+10','Accuracy+14','Attack+12',}}
	--WSD--
			gear.Herculean.Head_WSDdex = { name="Herculean Helm", augments={'Accuracy+21 Attack+21','Weapon skill damage +4%','DEX+10','Attack+14',}}
			gear.Herculean.Body_STR = { name="Herculean Vest", augments={'Accuracy+27','"Triple Atk."+3','STR+12','Attack+4',}}
			gear.Herculean.Hands_WSD = { name="Herculean Gloves", augments={'Accuracy+22 Attack+22','Weapon skill damage +3%','STR+3','Accuracy+12','Attack+1',}}
			gear.Herculean.Legs_WSD = { name="Herculean Trousers", augments={'Attack+28','Weapon skill damage +5%','Accuracy+9',}}
			gear.Herculean.Legs_WSDdex = { name="Herculean Trousers", augments={'Accuracy+20','Weapon skill damage +4%','DEX+8','Attack+7',}}
			gear.Herculean.Feet_WSD = { name="Herculean Boots", augments={'STR+1','Accuracy+19','Weapon skill damage +6%','Accuracy+17 Attack+17',}}
			gear.Herculean.Feet_WSD2 = { name="Herculean Boots", augments={'Pet: "Mag.Atk.Bns."+1','STR+4','Weapon skill damage +8%','Accuracy+10 Attack+10',}}
			gear.Herculean.Legs_WSDMND = { name="Herculean Trousers", augments={'"Blood Pact" ability delay -6','MND+15','Weapon skill damage +9%','Mag. Acc.+9 "Mag.Atk.Bns."+9',}}
	--WSD/MAB--
			gear.Herculean.Head_WSDMAB = { name="Herculean Helm", augments={'Magic dmg. taken -2%','Pet: Phys. dmg. taken -2%','Weapon skill damage +5%','Accuracy+12 Attack+12','Mag. Acc.+19 "Mag.Atk.Bns."+19',}}
			gear.Herculean.Legs_WSDMAB = { name="Herculean Trousers", augments={'"Mag.Atk.Bns."+25','Weapon skill damage +5%',}}
			gear.Herculean.Feet_WSDMAB = { name="Herculean Boots", augments={'"Mag.Atk.Bns."+22','Weapon skill damage +4%',}}
			gear.Herculean.Body_Magic = { name="Herculean Vest", augments={'"Mag.Atk.Bns."+25','Mag. Acc.+21','Crit.hit rate+5','Mag. Acc.+19 "Mag.Atk.Bns."+19',}}
	--CRIT DMG --
			gear.Herculean.Feet_CRITDMG = { name="Herculean Boots", augments={'Accuracy+16 Attack+16','Crit. hit damage +4%','DEX+14','Accuracy+8',}}
			gear.Herculean.HAnds_CRTIDMG = { name="Herculean Gloves", augments={'Attack+23','Crit. hit damage +3%','DEX+15','Accuracy+12',}}
	--DT --
			gear.Herculean.Hands_DT = { name="Herculean Gloves", augments={'Attack+19','Damage taken-4%','Accuracy+6',}}
			gear.Herculean.Legs_DT = { name="Herculean Trousers", augments={'Attack+27','Damage taken-4%','STR+5','Accuracy+9',}}
			--gear.Herculean.Feet_DT = { name="Herculean Boots", augments={'Attack+12','Damage taken-3%','AGI+4',}}
	--TRIPLE --
			gear.Herculean.Hands_TRPL = { name="Herculean Gloves", augments={'Accuracy+26','"Triple Atk."+3','DEX+2',}}
			gear.Herculean.Feet_TRPL = { name="Herculean Boots", augments={'Accuracy+15 Attack+15','"Triple Atk."+4','STR+9','Attack+9',}}
			gear.Herculean.Feet_TRPLacc = { name="Herculean Boots", augments={'Accuracy+30','"Triple Atk."+3','DEX+7','Attack+15',}}
	--REFRESH --
			gear.Herculean.Head_REF = { name="Herculean Helm", augments={'Spell interruption rate down -7%','STR+8','"Refresh"+2','Accuracy+18 Attack+18','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}
			gear.Herculean.Hands_REF = { name="Herculean Gloves", augments={'"Mag.Atk.Bns."+23','Pet: "Dbl. Atk."+4','"Refresh"+1','Mag. Acc.+3 "Mag.Atk.Bns."+3',}}
			gear.Herculean.Feet_REF = { name="Herculean Boots", augments={'Pet: DEX+6','"Triple Atk."+1','"Refresh"+1','Accuracy+19 Attack+19',}}
	--Ranged --
			gear.Herculean.Legs_RAwsd = { name="Herculean Trousers", augments={'Rng.Acc.+20 Rng.Atk.+20','Weapon skill damage +5%','AGI+1','Rng.Acc.+6','Rng.Atk.+2',}}
	--Treasure Hunter --
			gear.Herculean.Body_TH = { name="Herculean Vest", augments={'Chance of successful block +3','"Fast Cast"+5','"Treasure Hunter"+2','Accuracy+4 Attack+4',}}
			gear.Herculean.Hands_TH = { name="Herculean Gloves", augments={'Rng.Acc.+23','Pet: INT+1','"Treasure Hunter"+1','Accuracy+18 Attack+18',}}
	
--BLU capes--
	gear.Rosmerta = {}
			gear.Rosmerta_CDC = { name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Damage taken-5%',}}
			gear.Rosmerta_STP = { name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}}
			gear.Rosmerta_DBL = { name="Rosmerta's Cape", augments={'MND+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}}
			gear.Rosmerta_MA = { name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}}
			gear.Rosmerta_WSD = { name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
			gear.Rosmerta_EVA = { name="Rosmerta's Cape", augments={'AGI+20','Eva.+20 /Mag. Eva.+20','Evasion+10','"Fast Cast"+10','Evasion+15',}}
	
--NIN capes--
	gear.NINcape = {}
			gear.NINcape_WS1 = { name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Damage taken-5%',}}
			gear.NINcape_WS2 = { name="Andartia's Mantle", augments={'AGI+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Damage taken-5%',}}
			gear.NINcape_STP = { name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+9','"Dbl.Atk."+10','Damage taken-5%',}}
			gear.NINcape_FC = { name="Andartia's Mantle", augments={'AGI+20','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Damage taken-5%',}}
			gear.NINcape_EVA = { name="Andartia's Mantle", augments={'Enmity+10',}}
	
--RUN capes--
	gear.RUNcape = {}
			gear.RUNcape_STP = { name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}}
			gear.RUNcape_WS1 = { name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
			gear.RUNcape_TANK = { name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Evasion+10','Enmity+10','DEF+50',}}
			gear.RUNcape_FC = { name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}}
			gear.RUNcape_SIR = { name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Spell interruption rate down-10%',}}
			gear.RUNcape_WS2 = { name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
--DRG Capes--
	gear.DRGcape = {}
			gear.DRGcape_STP = { name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10',}}
			gear.DRGcape_WSD = { name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
			gear.DRGcape_DBLatk = { name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
-- GEO Capes --
	gear.GEOcape ={}
			gear.GEOcape.HRTLSS_MEVA = { name="Nantosuelta's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+5','Pet: "Regen"+10','Mag. Evasion+15',}}
			gear.GEOcape.HRTLSS_MACCDMG = { name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}}
--BRD capes --
	gear.BRDcape = {}
			gear.BRDcape_HRTLSS_FC = { name="Intarabus's Cape", augments={'CHR+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}
			gear.BRDcape_HRTLSS_WSDdex = { name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
			gear.BRDcape_HRTLSS_STP = { name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}}
			gear.BRDcape_HRTLSS_MACC = { name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','Haste+10','Phys. dmg. taken-10%',}}
			gear.BRDcape_HRTLSS_WSDstr = { name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Damage taken-5%',}}
--THF Capes --
	gear.THFcape ={}
			gear.THFcape.WSD_dex = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}}
			gear.THFcape.STP = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}}

--DRK Capes --
	gear.DRKcape = {}
			gear.DRKcape_DBLATKdex = { name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}}
			gear.DRKcape_WSDstr = { name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
			gear.DRKcape_WSDvit = { name="Ankou's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}}
			gear.DRKcape_STP = { name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
			gear.DRKcape_WSint = { name="Ankou's Mantle", augments={'INT+20','Accuracy+20 Attack+20','INT+10','Weapon skill damage +10%',}}
			gear.DRKcape_DBLATKstr = { name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','"Regen"+5',}}
			gear.DRKcape_FstCst = { name="Ankou's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Fast Cast"+10',}}

--WAR Capes --
	gear.WARcape = {}
			gear.WARcape_WS1 = { name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
			gear.WARcape_WS2 = { name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
			gear.WARcape_WS3 = { name="Cichol's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
			gear.WARcape_STPdbl = { name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
			gear.WARcape_STP = { name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
			gear.WARcape_CloudSp = { name="Cichol's Mantle", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
			gear.WARcape_WSint = { name="Cichol's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
			
--RDM Capes --
	gear.RDMcape = {}
			gear.RDMcape_DW = { name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Damage taken-5%',}}
			gear.RDMcape_MND = { name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%','Damage taken-5%',}}
			gear.RDMcape_CDC = { name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Damage taken-5%',}}
			gear.RDMcape_STP = { name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}}
			gear.RDMcape_INT = { name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Damage taken-5%',}}
			gear.RDMcape_WSD = { name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Damage taken-5%',}}
			gear.RDMcape_WSDint = { name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','Weapon skill damage +10%','Damage taken-5%',}}
			gear.RDMcape_RACC = { name="Sucellos's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','Weapon skill damage +10%','Mag. Evasion+15',}}

--BLM Capes --
	gear.BLMcape = {}
			gear.BLMcape_mWS = { name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
			gear.BLMcape_STP = { name="Taranus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
			gear.BLMcape_MAB = { name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Damage taken-5%',}}
			gear.BLMcape_FC = { name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}}
			
--MNK Capes -- 
	gear.MNKcape = {}
			gear.MNKcape_dblAtkSTR = { name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Damage taken-5%',}}
			gear.MNKcape_dblAtkVIT = { name="Segomo's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','"Dbl.Atk."+10','Damage taken-5%',}}
			gear.MNKcape_dblAtkACC = { name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}}
			gear.MNKcape_WSDvit = { name="Segomo's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%','Damage taken-5%',}}
			gear.MNKcape_STP = { name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}}
			gear.MNKcape_WSmagic = { name="Segomo's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	
--COR Capes --
	gear.CORcape = {}
			gear.CORcape_Snp = { name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','"Snapshot"+10','Damage taken-5%',}}
			gear.CORcape_rSTP = { name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','"Store TP"+10','Damage taken-5%',}}
			gear.CORcape_MWSD = { name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%','Damage taken-5%',}}
			gear.CORcape_RWSD = { name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}}
			gear.CORcape_STP = { name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}}
			
			gear.CORcape_Savage = { name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Damage taken-5%',}}
--PLD capes -- 
	gear.PLDcape = {}
			gear.PLDcape_ENM = { name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Chance of successful block +5',}}

--SAM capes --
	gear.SAMcape = {}
			gear.SAMcape_TP = { name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
			gear.SAMcape_WSD = { name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}

--SCH capes --
	gear.SCHcape = {}
			gear.SCHcape_INT = { name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}}
			gear.SCHcape_FC = { name="Lugh's Cape", augments={'MP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}
			gear.SCHcape_Cure = { name="Lugh's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','MP+20','"Cure" potency +10%','Phys. dmg. taken-10%',}}
			gear.SCHcape_WSDint = { name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
			gear.SCHcape_STP = { name="Lugh's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}

--DNC capes --
	gear.DNCcape = {}
			gear.DNCcape_Dblatk = { name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
			gear.DNCcape_Waltz = { name="Senuna's Mantle", augments={'CHR+20','Eva.+20 /Mag. Eva.+20','CHR+10','"Waltz" potency +10%','Phys. dmg. taken-10%',}}
			gear.DNCcape_WSdex = { name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}

--Coladas --
	gear.colada = {}
			gear.colada_int = { name="Colada", augments={'Accuracy+13','INT+13','Mag. Acc.+18','"Mag.Atk.Bns."+10','DMG:+17',}}
			gear.colada_dex ={ name="Colada", augments={'DEX+11','Accuracy+20','Attack+19','DMG:+18',}}
	end
-------------------------------------------------------------------------------------------------------------------
-- Functions to set user-specified binds, generally on load and unload.
-- Kept separate from the main include so as to not get clobbered when the main is updated.
-------------------------------------------------------------------------------------------------------------------

-- Function to bind GearSwap binds when loading a GS script.
function global_on_load()
	send_command('bind @t gs c cycle treasuremode')
	send_command('bind f7 gs c cycle OffenseMode')
	send_command('bind f6 gs c cycleback OffenseMode')
	send_command('bind ^f7 gs c cycle HybridMode')
	send_command('bind !f9 gs c cycle RangedMode')
	send_command('bind @f7 gs c cycle WeaponskillMode')
	send_command('bind f10 gs c set DefenseMode Physical')
	send_command('bind ^f10 gs c cycleback CastingMode')
	send_command('bind !f10 gs c toggle Kiting')
	send_command('bind f11 gs c set DefenseMode Magical')
	send_command('bind ^f11 gs c cycle CastingMode')
	send_command('bind f12 gs c update user')
	send_command('bind ^f12 gs c cycle IdleMode')
	send_command('bind !f12 gs c reset DefenseMode')
    send_command('bind @e gs c cycleback WeaponSet')
    send_command('bind @r gs c cycle WeaponSet')
	send_command('bind @w gs c cycle Weaponlock')
	send_command('bind ^- gs c toggle selectnpctargets')
	send_command('bind ^= gs c cycle pctargetmode')
end

-- Function to revert binds when unloading.
function global_on_unload()
	send_command('unbind @t')
	send_command('unbind f9')
	send_command('unbind f7')
	send_command('unbind ^f9')
	send_command('unbind !f9')
	send_command('unbind @f9')
	send_command('unbind f10')
	send_command('unbind ^f10')
	send_command('unbind !f10')
	send_command('unbind f11')
	send_command('unbind ^f11')
	send_command('unbind !f11')
	send_command('unbind f12')
	send_command('unbind ^f12')
	send_command('unbind !f12')

	send_command('unbind ^-')
	send_command('unbind ^=')
	
	send_command('unbind @e')
	send_command('unbind @r')
	send_command('gs enable all')
end



-------------------------------------------------------------------------------------------------------------------

-- Global event-handling functions.

-------------------------------------------------------------------------------------------------------------------



-- Global intercept on precast.

function user_precast(spell, action, spellMap, eventArgs)

    cancel_conflicting_buffs(spell, action, spellMap, eventArgs)

    refine_waltz(spell, action, spellMap, eventArgs)

end



-- Global intercept on midcast.

function user_midcast(spell, action, spellMap, eventArgs)

	-- Default base equipment layer of fast recast.

	if spell.action_type == 'Magic' and sets.midcast and sets.midcast.FastRecast then

		equip(sets.midcast.FastRecast)

	end

end



-- Global intercept on buff change.

function user_buff_change(buff, gain, eventArgs)

	-- Create a timer when we gain weakness.  Remove it when weakness is gone.

	if buff:lower() == 'weakness' then

		if gain then

			send_command('timers create "Weakness" 300 up abilities/00255.png')

		else

			send_command('timers delete "Weakness"')

		end

	end

end

function gearinfo(cmdParams, eventArgs)

    if cmdParams[1] == 'gearinfo' then

        if type(tonumber(cmdParams[2])) == 'number' then

            if tonumber(cmdParams[2]) ~= DW_needed then

            DW_needed = tonumber(cmdParams[2])

            DW = true

            end

        elseif type(cmdParams[2]) == 'string' then

            if cmdParams[2] == 'false' then

                DW_needed = 0

                DW = false

            end

        end

        if type(tonumber(cmdParams[3])) == 'number' then

            if tonumber(cmdParams[3]) ~= Haste then

                Haste = tonumber(cmdParams[3])

            end

        end

        if type(cmdParams[4]) == 'string' then

            if cmdParams[4] == 'true' then

                moving = true

            elseif cmdParams[4] == 'false' then

                moving = false

            end

        end

        if not midaction() then

            job_update()

        end

    end

end

windower.register_event('zone change', 
    function()
            send_command('gi ugs true')
    end

)


-- Function to get the current weather intensity: 0 for none, 1 for single weather, 2 for double weather.
function get_weather_intensity()
    return gearswap.res.weather[world.weather_id].intensity
end


--Function Kohh's Run spell thing
fixed_pos = ''
fixed_ts = os.time()

local no_interruptions = true

windower.raw_register_event('outgoing chunk',function(id,original,modified,injected,blocked)
    if no_interruptions and (not blocked) then
        if id == 0x15 then
            if (gearswap.cued_packet or midaction()) and fixed_pos ~= '' and os.time()-fixed_ts < 5 then
                return original:sub(1,4)..fixed_pos..original:sub(17)
            else
                fixed_pos = original:sub(5,16)
                fixed_ts = os.time()
            end
        end
    end
end)

register_unhandled_command(function (...)
    local commands = {...}
    if commands[1] and commands[1]:lower() == 'interrupts' then
        if (no_interruptions) then
            windower.add_to_chat(160, "%s : Disabling \30\2no_interruptions\30\43":format(_addon.name))
            no_interruptions = false
        else
            windower.add_to_chat(160, "%s : Enabling \30\2no_interruptions\30\43":format(_addon.name))
            no_interruptions = true
        end
        return true
    end
    return false
end)

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
    if no_swap_gear:contains(player.equipment.waist) then
        disable("waist")
    else
        enable("waist")
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
        if no_swap_gear:contains(player.equipment.waist) then
            enable("waist")
            equip(sets.idle)
        end
    end
)

