/obj/item/clothing/neck
	name = "necklace"
	icon = 'icons/obj/clothing/neck.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	strip_delay = 40
	equip_delay_other = 40
	bloody_icon_state = "bodyblood"

/obj/item/clothing/neck/worn_overlays(isinhands = FALSE)
	. = list()
//	if(!isinhands)
//		if(body_parts_covered & HEAD)
//			if(damaged_clothes)
//				. += mutable_appearance('icons/effects/item_damage.dmi', "damagedmask")
//			if(HAS_BLOOD_DNA(src))
//				. += mutable_appearance('icons/effects/blood.dmi', "maskblood")

/obj/item/clothing/neck/tie
	name = "tie"
	desc = ""
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bluetie"
	item_state = ""	//no inhands
	w_class = WEIGHT_CLASS_SMALL
	custom_price = 15

/obj/item/clothing/neck/tie/blue
	name = "blue tie"
	icon_state = "bluetie"

/obj/item/clothing/neck/tie/red
	name = "red tie"
	icon_state = "redtie"

/obj/item/clothing/neck/tie/black
	name = "black tie"
	icon_state = "blacktie"

/obj/item/clothing/neck/tie/horrible
	name = "horrible tie"
	desc = ""
	icon_state = "horribletie"

/obj/item/clothing/neck/tie/detective
	name = "loose tie"
	desc = ""
	icon_state = "detective"

/obj/item/clothing/neck/stethoscope
	name = "stethoscope"
	desc = ""
	icon_state = "stethoscope"

/obj/item/clothing/neck/stethoscope/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] puts \the [src] to [user.p_their()] chest! It looks like [user.p_they()] wont hear much!"))
	return OXYLOSS

/obj/item/clothing/neck/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user))
		if(user.used_intent.type == INTENT_HELP)
			var/body_part = parse_zone(user.zone_selected)

			var/heart_strength = span_danger("no")
			var/lung_strength = span_danger("no")

			var/obj/item/organ/heart/heart = M.getorganslot(ORGAN_SLOT_HEART)
			var/obj/item/organ/lungs/lungs = M.getorganslot(ORGAN_SLOT_LUNGS)

			if(!(M.stat == DEAD || (HAS_TRAIT(M, TRAIT_FAKEDEATH))))
				if(heart && istype(heart))
					heart_strength = span_danger("an unstable")
					if(heart.beating)
						heart_strength = "a healthy"
				if(lungs && istype(lungs))
					lung_strength = span_danger("strained")
					if(!(M.failed_last_breath || M.losebreath))
						lung_strength = "healthy"

			if(M.stat == DEAD && heart && world.time - M.timeofdeath < DEFIB_TIME_LIMIT * 10)
				heart_strength = span_boldannounce("a faint, fluttery")

			var/diagnosis = (body_part == BODY_ZONE_CHEST ? "You hear [heart_strength] pulse and [lung_strength] respiration." : "You faintly hear [heart_strength] pulse.")
			user.visible_message(span_notice("[user] places [src] against [M]'s [body_part] and listens attentively."), span_notice("I place [src] against [M]'s [body_part]. [diagnosis]"))
			return
	return ..(M,user)

///////////
//SCARVES//
///////////

/obj/item/clothing/neck/scarf //Default white color, same functionality as beanies.
	name = "white scarf"
	icon_state = "scarf"
	desc = ""
	dog_fashion = /datum/dog_fashion/head
	custom_price = 10

/obj/item/clothing/neck/scarf/black
	name = "black scarf"
	icon_state = "scarf"
	color = "#4A4A4B" //Grey but it looks black

/obj/item/clothing/neck/scarf/pink
	name = "pink scarf"
	icon_state = "scarf"
	color = "#F699CD" //Pink

/obj/item/clothing/neck/scarf/red
	name = "red scarf"
	icon_state = "scarf"
	color = "#D91414" //Red

/obj/item/clothing/neck/scarf/green
	name = "green scarf"
	icon_state = "scarf"
	color = "#5C9E54" //Green

/obj/item/clothing/neck/scarf/darkblue
	name = "dark blue scarf"
	icon_state = "scarf"
	color = "#1E85BC" //Blue

/obj/item/clothing/neck/scarf/purple
	name = "purple scarf"
	icon_state = "scarf"
	color = "#9557C5" //Purple

/obj/item/clothing/neck/scarf/yellow
	name = "yellow scarf"
	icon_state = "scarf"
	color = "#E0C14F" //Yellow

/obj/item/clothing/neck/scarf/orange
	name = "orange scarf"
	icon_state = "scarf"
	color = "#C67A4B" //Orange

/obj/item/clothing/neck/scarf/cyan
	name = "cyan scarf"
	icon_state = "scarf"
	color = "#54A3CE" //Cyan


//Striped scarves get their own icons

/obj/item/clothing/neck/scarf/zebra
	name = "zebra scarf"
	icon_state = "zebrascarf"

/obj/item/clothing/neck/scarf/christmas
	name = "christmas scarf"
	icon_state = "christmasscarf"

//The three following scarves don't have the scarf subtype
//This is because Ian can equip anything from that subtype
//However, these 3 don't have corgi versions of their sprites
/obj/item/clothing/neck/stripedredscarf
	name = "striped red scarf"
	icon_state = "stripedredscarf"
	custom_price = 10

/obj/item/clothing/neck/stripedgreenscarf
	name = "striped green scarf"
	icon_state = "stripedgreenscarf"
	custom_price = 10

/obj/item/clothing/neck/stripedbluescarf
	name = "striped blue scarf"
	icon_state = "stripedbluescarf"
	custom_price = 10

/obj/item/clothing/neck/petcollar
	name = "pet collar"
	desc = ""
	icon_state = "petcollar"
	var/tagname = null

/obj/item/clothing/neck/petcollar/mob_can_equip(mob/M, mob/equipper, slot, disable_warning = 0)
	if(ishuman(M))
		return FALSE
	return ..()

/obj/item/clothing/neck/petcollar/attack_self(mob/user)
	tagname = copytext(sanitize(input(user, "Would you like to change the name on the tag?", "Name your new pet", "Spot") as null|text),1,MAX_NAME_LEN)
	name = "[initial(name)] - [tagname]"

//////////////
//DOPE BLING//
//////////////

/obj/item/clothing/neck/necklace/dope
	name = "gold necklace"
	desc = ""
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bling"

/obj/item/clothing/neck/neckerchief
	icon = 'icons/obj/clothing/masks.dmi' //In order to reuse the bandana sprite
	w_class = WEIGHT_CLASS_TINY
	var/sourceBandanaType

/obj/item/clothing/neck/neckerchief/worn_overlays(isinhands)
	. = ..()
	if(!isinhands)
		var/mutable_appearance/realOverlay = mutable_appearance('icons/mob/clothing/mask.dmi', icon_state)
		realOverlay.pixel_y = -3
		. += realOverlay

/obj/item/clothing/neck/neckerchief/AltClick(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.get_item_by_slot(SLOT_NECK) == src)
			to_chat(user, span_warning("I can't untie [src] while wearing it!"))
			return
		if(user.is_holding(src))
			var/obj/item/clothing/mask/bandana/newBand = new sourceBandanaType(user)
			var/currentHandIndex = user.get_held_index_of_item(src)
			var/oldName = src.name
			qdel(src)
			user.put_in_hand(newBand, currentHandIndex)
			user.visible_message(span_notice("I untie [oldName] back into a [newBand.name]."), span_notice("[user] unties [oldName] back into a [newBand.name]."))
		else
			to_chat(user, span_warning("I must be holding [src] in order to untie it!"))

/obj/item/clothing/neck/roguetown/cursed_collar
	name = "cursed collar"
	desc = "A sinister looking collar with emerald studs. It seems to radiate a dark energy."
	icon_state = "listenstone"
	item_state = "listenstone"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NECK
	resistance_flags = INDESTRUCTIBLE
	var/mob/living/carbon/human/victim = null
	var/mob/living/carbon/human/collar_master = null
	var/silenced = FALSE
	var/applying = FALSE

/obj/item/clothing/neck/roguetown/cursed_collar/attack(mob/living/carbon/C, mob/living/user)
	if(!istype(C))
		return ..()

	if(!C.mind)
		to_chat(user, span_warning("[C] is too simple-minded to be collared!"))
		return

	if(C == user && HAS_TRAIT(user, TRAIT_SLAVEBOURNE))
		to_chat(user, span_warning("No, I want someone else to collar me!"))
		return

	if(C.get_item_by_slot(SLOT_NECK))
		to_chat(user, span_warning("[C] is already wearing something around their neck!"))
		return

	if(applying)
		return

	applying = TRUE
	var/surrender_mod = 1
	if(C.surrendering)
		surrender_mod = 0.5

	C.visible_message(span_danger("[user] begins locking the cursed collar around [C]'s neck!"), \
							 span_userdanger("[user] begins locking the cursed collar around your neck!"))
	playsound(loc, 'sound/foley/equip/equip_armor_plate.ogg', 30, TRUE, -2)

	if(do_mob(user, C, 50 * surrender_mod))
		if(!user.mind)
			to_chat(user, span_warning("You need a mind to control the collar!"))
			applying = FALSE
			return

		// Try to equip first
		if(!C.equip_to_slot_if_possible(src, SLOT_NECK, TRUE, TRUE))
			to_chat(user, span_warning("You fail to lock the collar around [C]'s neck!"))
			applying = FALSE
			return

		// Get or create collar master datum
		var/datum/antagonist/collar_master/CM = user.mind.has_antag_datum(/datum/antagonist/collar_master)
		if(!CM)
			CM = new()
			user.mind.add_antag_datum(CM)

		// Add pet to the master's list
		CM.add_pet(C)

		log_combat(user, C, "collared", addition="with [src]")
		ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
		SEND_SIGNAL(C, COMSIG_CARBON_GAIN_COLLAR, src)

		C.visible_message(span_warning("[user] locks the cursed collar around [C]'s neck!"), \
							 span_userdanger("[user] locks the cursed collar around your neck!"))
		playsound(loc, 'sound/foley/equip/equip_armor_plate.ogg', 30, TRUE, -2)
	else
		to_chat(user, span_warning("You fail to lock the collar around [C]'s neck!"))
	applying = FALSE

/obj/item/clothing/neck/roguetown/cursed_collar/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_NECK && victim == user)
		user.visible_message(span_warning("[user] is bound by the collar's dark magic."), \
			span_warning("The collar's magic binds you to your new master's will!"))
		to_chat(user, span_alert("You must now obey your master's commands."))

/obj/item/clothing/neck/roguetown/cursed_collar/dropped(mob/living/carbon/human/user)
	. = ..()
	if(!user)
		return
	SEND_SIGNAL(user, COMSIG_CARBON_LOSE_COLLAR)

	// Find and remove from any collar master's pet list
	for(var/datum/mind/M in SSticker.minds)
		var/datum/antagonist/collar_master/CM = M.has_antag_datum(/datum/antagonist/collar_master)
		if(CM && (user in CM.my_pets))
			CM.remove_pet(user)
			break

	REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/neck/roguetown/cursed_collar/canStrip(mob/living/carbon/human/stripper, mob/living/carbon/human/owner)
	if(stripper == collar_master)
		REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
		SEND_SIGNAL(owner, COMSIG_CARBON_LOSE_COLLAR)
		return TRUE
	return FALSE
