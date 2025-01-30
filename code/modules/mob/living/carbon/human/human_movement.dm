/mob/living/carbon/human/get_movespeed_modifiers()
	var/list/considering = ..()
	. = considering
	if(HAS_TRAIT(src, TRAIT_IGNORESLOWDOWN))
		for(var/id in .)
			var/list/data = .[id]
			if(data[MOVESPEED_DATA_INDEX_FLAGS] & IGNORE_NOSLOW)
				.[id] = data

/mob/living/carbon/human/slip(knockdown_amount, obj/O, lube, paralyze, forcedrop)
	if(HAS_TRAIT(src, TRAIT_NOSLIPALL))
		return 0
	if (!(lube&GALOSHES_DONT_HELP))
		if(HAS_TRAIT(src, TRAIT_NOSLIPWATER))
			return 0
		if(shoes && istype(shoes, /obj/item/clothing))
			var/obj/item/clothing/CS = shoes
			if (CS.clothing_flags & NOSLIP)
				return 0
	return ..()

/mob/living/carbon/human/experience_pressure_difference()
	playsound(src, 'sound/blank.ogg', 50, TRUE)
	if(shoes && istype(shoes, /obj/item/clothing))
		var/obj/item/clothing/S = shoes
		if (S.clothing_flags & NOSLIP)
			return 0
	return ..()

/mob/living/carbon/human/mob_has_gravity()
	. = ..()
	if(!.)
		if(mob_negates_gravity())
			. = 1

/mob/living/carbon/human/mob_negates_gravity()
	return ((shoes && shoes.negates_gravity()) || (dna.species.negates_gravity(src)))

/mob/living/carbon/human/Move(NewLoc, direct)
/*	if(fixedeye || tempfixeye)
		switch(dir)
			if(NORTH)
				if(direct == WEST|EAST)
					OffBalance(30)
			if(SOUTH)
				if(direct == WEST|EAST)
					OffBalance(30)
			if(EAST)
				if(direct == NORTH|SOUTH)
					OffBalance(30)
			if(WEST)
				if(direct == NORTH|SOUTH)
					OffBalance(30)*/

	. = ..()
	if(loc == NewLoc)
		if(!has_gravity(loc))
			return

		if(wear_armor)
			if(mobility_flags & MOBILITY_STAND)
				var/obj/item/clothing/C = wear_armor
				C.step_action()

		if(wear_shirt)
			if(mobility_flags & MOBILITY_STAND)
				var/obj/item/clothing/C = wear_shirt
				C.step_action()

		if(cloak)
			if(mobility_flags & MOBILITY_STAND)
				var/obj/item/clothing/C = cloak
				C.step_action()

		if(shoes)
			if(mobility_flags & MOBILITY_STAND)
				var/obj/item/clothing/shoes/S = shoes

				//Bloody footprints
				var/turf/T = get_turf(src)
				if(S.bloody_shoes && S.bloody_shoes[S.blood_state])
					for(var/obj/effect/decal/cleanable/blood/footprints/oldFP in T)
						if (oldFP.blood_state == S.blood_state)
							return
					//No oldFP or they're all a different kind of blood
					S.bloody_shoes[S.blood_state] = max(0, S.bloody_shoes[S.blood_state] - BLOOD_LOSS_PER_STEP)
					if (S.bloody_shoes[S.blood_state] > BLOOD_LOSS_IN_SPREAD)
						var/obj/effect/decal/cleanable/blood/footprints/FP = new /obj/effect/decal/cleanable/blood/footprints(T)
						FP.blood_state = S.blood_state
						FP.entered_dirs |= dir
						FP.bloodiness = S.bloody_shoes[S.blood_state] - BLOOD_LOSS_IN_SPREAD
						FP.add_blood_DNA(S.return_blood_DNA())
						FP.update_icon()
					update_inv_shoes()
				//End bloody footprints
				S.step_action()
		if(mouth)
			if(mouth.spitoutmouth && prob(5))
				visible_message(span_warning("[src] spits out [mouth]."))
				dropItemToGround(mouth, silent = FALSE)
		if(held_items.len)
			for(var/obj/item/I in held_items)
				if(I.minstr)
					var/effective = I.minstr
					if(I.wielded)
						effective = max(I.minstr / 2, 1)
					if(effective > STASTR)
						if(prob(effective))
							dropItemToGround(I, silent = FALSE)

/mob/living/carbon/human/Process_Spacemove(movement_dir = 0) //Temporary laziness thing. Will change to handles by species reee.
	if(dna.species.space_move(src))
		return TRUE
	return ..()

/mob/living/carbon/human
	var/pony_sprint = 0
	var/pony_sprint_cooldown = 0
	var/pony_max_sprint = 50
	var/spurred = FALSE
	var/last_damage_data = null  // to track damage

/mob/living/carbon/human/proc/handle_pony_riding()
	if(!HAS_TRAIT(src, TRAIT_PONYGIRL_RIDEABLE))
		return FALSE

	var/mob/living/carbon/human/rider = locate() in src.buckled_mobs
	if(!rider)
		return FALSE

	// Transfer damage from rider to ponygirl
	if(rider.getBruteLoss() > 0)
		var/damage = rider.getBruteLoss()
		adjustBruteLoss(damage)
		rider.adjustBruteLoss(-damage)

	// Also transfer burn damage
	if(rider.getFireLoss() > 0)
		var/damage = rider.getFireLoss()
		adjustFireLoss(damage)
		rider.adjustFireLoss(-damage)

	// Reset sprint if cooldown passed
	if(pony_sprint_cooldown && pony_sprint_cooldown < world.timeofday)
		pony_sprint = initial(pony_sprint)
		spurred = FALSE
		ADD_TRAIT(src, TRAIT_NOROGSTAM, TRAIT_GENERIC)

	// Handle spanking speed boost
	if(rider.a_intent == INTENT_HARM && rider.zone_selected == "groin" && !rider.incapacitated())
		rider.emote("slap", intentional = TRUE, targetted = TRUE)
		pony_sprint = min(pony_sprint + 5, pony_max_sprint)
		change_stat("speed", pony_sprint * 0.1)
		if(!spurred)
			spurred = TRUE
			REMOVE_TRAIT(src, TRAIT_NOROGSTAM, TRAIT_GENERIC)
		visible_message(span_notice("[rider] spurs [src], increasing their pace!"), \
					span_notice("The sharp sting drives you to move faster!"), \
					span_notice("You hear a sharp slap!"))
		pony_sprint_cooldown = world.timeofday + 50

	return TRUE

/mob/living/carbon/human/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)
	if(!force && !HAS_TRAIT(src, TRAIT_PONYGIRL_RIDEABLE))
		return FALSE

	if(..()) // If parent buckle succeeds
		var/datum/component/riding/human/riding_datum = LoadComponent(/datum/component/riding/human)
		riding_datum.vehicle_move_delay = 2 // Base movement delay

		// Apply riding skill modifiers
		if(M.mind)
			var/riding_skill = M.mind.get_skill_level(/datum/skill/misc/riding)
			if(riding_skill)
				riding_datum.vehicle_move_delay = max(1, 2 - (riding_skill * 0.2))

		// Set proper riding offsets
		riding_datum.set_riding_offsets(RIDING_OFFSET_ALL, list(
			TEXT_NORTH = list(0, 6),
			TEXT_SOUTH = list(0, 6),
			TEXT_EAST = list(-6, 4),
			TEXT_WEST = list(6, 4)
		))

		// Set proper layering
		riding_datum.set_vehicle_dir_layer(SOUTH, ABOVE_MOB_LAYER)
		riding_datum.set_vehicle_dir_layer(NORTH, OBJ_LAYER)
		riding_datum.set_vehicle_dir_layer(EAST, OBJ_LAYER)
		riding_datum.set_vehicle_dir_layer(WEST, OBJ_LAYER)

		return TRUE
	return FALSE

/mob/living/carbon/human/unbuckle_mob(mob/living/M, force = FALSE)
	. = ..()
	if(.)
		pony_sprint = initial(pony_sprint)
		spurred = FALSE
		ADD_TRAIT(src, TRAIT_NOROGSTAM, TRAIT_GENERIC)

/mob/living/carbon/human/MouseDrop(atom/over_object)
	if(HAS_TRAIT(src, TRAIT_PONYGIRL_RIDEABLE) && over_object == usr)
		var/mob/living/user = usr
		if(can_buckle && !buckled_mobs?.len)
			if(user.incapacitated() || user.lying || user.restrained())
				return
			user.visible_message(span_notice("[user] starts mounting [src]..."))
			if(do_after(user, 15, target = src))
				if(user.incapacitated() || user.lying || user.restrained())
					return
				if(buckle_mob(user, TRUE, FALSE))
					var/datum/component/riding/human/riding_datum = LoadComponent(/datum/component/riding/human)
					riding_datum.vehicle_move_delay = 2 // Base movement delay
					if(user.mind)
						var/riding_skill = user.mind.get_skill_level(/datum/skill/misc/riding)
						if(riding_skill)
							riding_datum.vehicle_move_delay = max(1, 2 - (riding_skill * 0.2))
					return TRUE
		return
	return ..()

/mob/living/carbon/human/relaymove(mob/user, direction)
	if(HAS_TRAIT(src, TRAIT_PONYGIRL_RIDEABLE))
		var/datum/component/riding/riding_datum = GetComponent(/datum/component/riding)
		if(riding_datum)
			return riding_datum.handle_ride(user, direction)
	return ..()
