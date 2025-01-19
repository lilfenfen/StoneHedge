/datum/job/roguetown/merchant
	title = "Merchant Prince" // "merged" with Appraiser now, apparently, so they've been overhauled to both not be an utter mess AND be able to actually do that job.
	flag = MERCHANT
	department_flag = YEOMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = JCOLOR_YEOMAN
	allowed_races = RACES_ALL_KINDSPLUS
	tutorial = "You have curried enough favor, or perhaps disfavor, with the council of the merchant's guild to earn a posting in these lands. Rich in treasure and danger in equal measure, it's your job to make sure the coin never stops flowing -- and the local Adventurer's Guild doesn't go broke. As a numermancer, you have access to arcanye magicks to help defend your treasures. You should probably hire a bodyguard anyway, though. "

	display_order = JDO_MERCHANT

	outfit = /datum/outfit/job/roguetown/merchant
	give_bank_account = 800
	min_pq = 1
	max_pq = null
	required = TRUE

	cmode_music = 'sound/music/combat2.ogg'

/datum/outfit/job/roguetown/merchant/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		H.virginity = TRUE
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen
		pants = /obj/item/clothing/under/roguetown/tights/stockings/silk/random
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	else
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
		pants = /obj/item/clothing/under/roguetown/tights/random
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	ADD_TRAIT(H, TRAIT_SEEPRICES, type)
	ADD_TRAIT(H, TRAIT_LEARNMAGIC, TRAIT_GENERIC)
	neck = /obj/item/clothing/neck/roguetown/horus
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	beltl = /obj/item/rogueweapon/huntingknife/idagger/silver
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/roguekey/vault =1, /obj/item/storage/keyring/steward =1, /obj/item/storage/keyring/merchant =1, )

	if(H.mind)
		H.mind.adjust_skillrank_up_to(/datum/skill/combat/swords, 3, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/combat/polearms, 2, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/combat/knives, 5, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/labor/mathematics, 4, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/misc/reading, 5, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/misc/alchemy, 4, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/misc/sneaking, 3, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/craft/cooking, 3, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/misc/riding, 3, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/misc/medicine, 3, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/magic/arcane, 4, TRUE)
		H.mind.adjust_spellpoints(2) // you're rich, buy some scrolls if you want more
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/projectile/magic_missile)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/forcewall)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fetch)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		H.change_stat("strength", -1)
		H.change_stat("intelligence", 4)
		H.change_stat("perception", 2)
		H.change_stat("endurance", 1) // Pity point for being enduring bullying by other nerds for studying the nerdiest magic.
		H.verbs += list(/mob/living/carbon/human/proc/magicreport, /mob/living/carbon/human/proc/magiclearn)

	if(isseelie(H))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/seelie_dust)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/summon_rat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/strip)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/seelie_kiss)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/splash)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/roustame)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/animate_object)
