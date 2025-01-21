/mob/proc/collar_master_control_menu()
    set name = "Collar Control"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM)
        return

    var/list/valid_pets = list()
    for(var/mob/living/carbon/human/pet in CM.my_pets)
        if(!pet || !pet.mind || !pet.client)
            continue
        valid_pets[pet.real_name] = pet

    if(!length(valid_pets))
        to_chat(src, span_warning("No valid pets available!"))
        return

    var/list/selected = input(src, "Select pets to command:", "Pet Selection") as null|anything in valid_pets
    if(!selected || !CM)
        return

    CM.temp_selected_pets = list(valid_pets[selected])

    var/list/options = list(
		"Select pets" = /mob/proc/collar_master_select_pets,
        "Scry on Pets" = /mob/proc/collar_master_scry,
        "Listen to Pets" = /mob/proc/collar_master_listen,
        "Shock Pets" = /mob/proc/collar_master_shock,
        "Send Message" = /mob/proc/collar_master_send_message,
        "Force Surrender" = /mob/proc/collar_master_force_surrender,
        "Force Strip" = /mob/proc/collar_master_force_strip,
        "Permit Clothing" = /mob/proc/collar_master_permit_clothing,
        "Toggle Pet Speech" = /mob/proc/collar_master_toggle_speech,
        "Force Action" = /mob/proc/collar_master_force_action,
        "Pass Wounds" = /mob/proc/collar_master_pass_wounds,
        "Dominate Pet" = /mob/proc/collar_master_dominate,
        "Force Love" = /mob/proc/collar_master_force_love,
        "Toggle Arousal" = /mob/proc/collar_master_force_arousal,
        "Toggle Orgasm Denial" = /mob/proc/collar_master_toggle_denial,
        "Toggle Pet Hallucinations" = /mob/proc/collar_master_toggle_hallucinate,
        "Impose Will" = /mob/proc/collar_master_illusion,
        "Free Pet" = /mob/proc/collar_master_release_pet,
    )

    var/choice = input(src, "Choose a command:", "Collar Control") as null|anything in options
    if(!choice || !CM || !length(CM.temp_selected_pets))
        return

    var/proc_path = options[choice]
    call(src, proc_path)()

/mob/proc/collar_master_scry()
    set name = "Scry Pet"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar's scrying crystal is still recharging!"))
        return

    var/mob/living/carbon/human/pet = CM.temp_selected_pets[1]  // Use first selected pet
    if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
        to_chat(src, span_warning("Invalid pet selected!"))
        return

    if(pet.stat >= UNCONSCIOUS)
        to_chat(src, span_warning("[pet] must be conscious to establish a scrying link!"))
        return

    to_chat(src, span_notice("You establish a scrying link through [pet]'s collar..."))

    reset_perspective(pet)
    playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
    addtimer(CALLBACK(src, PROC_REF(end_scrying)), 05 SECONDS)

    CM.last_command_time = world.time

/mob/proc/end_scrying()
    reset_perspective()
    to_chat(src, span_notice("The vision fades..."))

/mob/proc/collar_master_listen()
    set name = "Listen to Pets"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar is still cooling down!"))
        return

    var/mob/living/carbon/human/pet = CM.temp_selected_pets[1]  // Use first selected pet
    if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
        to_chat(src, span_warning("Invalid pet selected!"))
        return

    if(pet.stat >= UNCONSCIOUS)
        to_chat(src, span_warning("[pet] must be conscious to establish a listening link!"))
        return

    to_chat(src, span_notice("You establish a listening link through [pet]'s collar..."))
    to_chat(pet, span_warning("Your collar tingles as your master listens through your ears!"))

    CM.toggle_listening(pet)
    CM.last_command_time = world.time

/mob/proc/collar_master_shock()
    set name = "Shock Pet"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar's power cell is still recharging!"))
        return

    var/intensity = 15  // Fixed intensity like the scepter
    CM.last_command_time = world.time
    var/shocked_count = 0

    for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
        if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
            continue

        if(pet.stat >= UNCONSCIOUS)
            to_chat(src, span_warning("[pet] must be conscious to be disciplined!"))
            continue

        if(CM.shock_pet(pet, intensity))
            shocked_count++

    if(shocked_count > 0)
        to_chat(src, span_notice("You discipline [shocked_count > 1 ? "[shocked_count] pets" : "your pet"] with a shock."))
    else
        to_chat(src, span_warning("Failed to discipline any pets!"))

/mob/proc/collar_master_send_message()
    set name = "Send Message"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar's neural link is still recharging!"))
        return

    var/message = input(src, "What message should echo in your pet's mind?", "Mental Command") as text|null
    if(!message)
        return

    CM.last_command_time = world.time
    var/message_count = 0

    for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
        if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
            continue

        to_chat(pet, span_userdanger("<i>Your collar resonates with your master's voice:</i> [message]"))
        playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
        pet.do_jitter_animation(15)
        message_count++

    if(message_count > 0)
        to_chat(src, span_notice("You project your will into [message_count > 1 ? "[message_count] pets" : "your pet's"] mind."))
    else
        to_chat(src, span_warning("Failed to reach any pets!"))

/mob/proc/collar_master_force_surrender()
    set name = "Force Surrender"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar is still cooling down!"))
        return

    CM.last_command_time = world.time
    var/surrendered_count = 0

    for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
        if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
            continue

        if(pet.stat >= UNCONSCIOUS)
            to_chat(src, span_warning("[pet] must be conscious to force surrender!"))
            continue

        if(CM.force_surrender(pet))
            surrendered_count++

    to_chat(src, span_notice("Forced [surrendered_count] pets to surrender."))

/mob/proc/collar_master_force_strip()
    set name = "Force Strip"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar's command circuits are still cooling down!"))
        return

    CM.last_command_time = world.time
    var/stripped_count = 0

    for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
        if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
            continue

        // Drop held items
        pet.drop_all_held_items()

        // Remove all clothing except collar
        for(var/obj/item/I in pet.get_equipped_items())
            if(!(I.slot_flags & ITEM_SLOT_NECK))  // Don't remove collar
                pet.dropItemToGround(I, TRUE)

        to_chat(pet, span_userdanger("Your collar tingles as it forces you to remove your clothing!"))
        pet.visible_message(span_warning("[pet]'s collar pulses with light as they frantically strip their clothing!"))
        playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
        stripped_count++

    if(stripped_count > 0)
        to_chat(src, span_notice("You command [stripped_count > 1 ? "[stripped_count] pets" : "your pet"] to strip."))
    else
        to_chat(src, span_warning("Failed to make any pets strip!"))

/mob/proc/collar_master_permit_clothing()
    set name = "Permit Clothing"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar's behavioral circuits need time to recalibrate!"))
        return

    CM.last_command_time = world.time
    var/permitted_count = 0

    for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
        if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
            continue

        REMOVE_TRAIT(pet, TRAIT_NUDIST, COLLAR_TRAIT)
        to_chat(pet, span_notice("Your collar hums softly as your master grants you permission to wear clothing."))
        pet.visible_message(span_notice("[pet]'s collar glows briefly as they are permitted to dress."))
        playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
        permitted_count++

    if(permitted_count > 0)
        to_chat(src, span_notice("You grant [permitted_count > 1 ? "[permitted_count] pets" : "your pet"] permission to wear clothing."))
    else
        to_chat(src, span_warning("Failed to permit any pets to wear clothing!"))

/mob/proc/collar_master_toggle_speech()
    set name = "Toggle Speech"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar's vocal inhibitors need time to cycle!"))
        return

    CM.last_command_time = world.time
    var/toggled_count = 0

    for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
        if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
            continue

        if(CM.toggle_speech(pet))
            toggled_count++

    to_chat(src, span_notice("Toggled speech for [toggled_count] pets."))

/mob/proc/collar_master_force_action()
    set name = "Force Action"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    var/message = input(src, "What action should your pets perform?", "Command Performance") as text|null
    if(!message || !CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar's control matrix is still recharging!"))
        return

    CM.last_command_time = world.time
    var/action_count = 0

    for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
        if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
            continue

        to_chat(pet, span_userdanger("Your collar compels you to perform an action!"))
        pet.visible_message(span_warning("[pet]'s collar pulses as they are forced to act!"))
        pet.say(message) // The game will automatically handle * for emotes
        pet.do_jitter_animation(15)
        playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
        action_count++

    if(action_count > 0)
        to_chat(src, span_notice("You compel [action_count > 1 ? "[action_count] pets" : "your pet"] to perform your commanded action."))
    else
        to_chat(src, span_warning("Failed to make any pets perform the action!"))

/mob/proc/collar_master_pass_wounds()
    set name = "Pass Wounds"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(!ishuman(src))
        to_chat(src, span_warning("You must be human to pass wounds!"))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar is still cooling down!"))
        return

    var/mob/living/carbon/human/master = src
    CM.last_command_time = world.time

    for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
        if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
            continue

        // Pass all damage types
        pet.adjustBruteLoss(master.getBruteLoss() * 0.5)
        pet.adjustFireLoss(master.getFireLoss() * 0.5)
        pet.adjustOxyLoss(master.getOxyLoss() * 0.5)

        // Pass blood level if it exists
        if(pet.blood_volume && master.blood_volume)
            pet.blood_volume = max(BLOOD_VOLUME_SAFE, pet.blood_volume - (BLOOD_VOLUME_NORMAL - master.blood_volume) * 0.5)

        // Pass organ damage
        for(var/obj/item/organ/organ in master.internal_organs)
            var/obj/item/organ/matching_organ = pet.getorganslot(organ.slot)
            if(matching_organ && organ.damage > 0)
                matching_organ.applyOrganDamage(organ.damage * 0.5)

        pet.updatehealth()
        playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
        to_chat(pet, span_userdanger("Your collar burns as your master's suffering flows into you!"))

    // Heal the master slightly
    master.adjustBruteLoss(-10)
    master.adjustFireLoss(-10)
    master.adjustOxyLoss(-10)

    to_chat(src, span_notice("You pass your wounds and suffering to [length(CM.temp_selected_pets)] pets."))

/mob/proc/collar_master_dominate()
    set name = "Dominate Pet"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar is still cooling down!"))
        return

    CM.last_command_time = world.time
    var/mob/living/carbon/human/pet = CM.temp_selected_pets[1]

    if(pet.stat >= UNCONSCIOUS)
        to_chat(src, span_warning("Your pet must be conscious!"))
        return

    if(CM.dominating)
        to_chat(src, span_warning("You are already dominating a pet!"))
        return

    CM.start_domination(pet, src)

/mob/proc/collar_master_force_love()
    set name = "Force Love"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar is still cooling down!"))
        return

    CM.last_command_time = world.time

    for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
        if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
            continue

        // Toggle love status
        if(pet.has_status_effect(/datum/status_effect/in_love))
            pet.remove_status_effect(/datum/status_effect/in_love)
            REMOVE_TRAIT(pet, TRAIT_LOVESTRUCK, COLLAR_TRAIT)
            to_chat(pet, span_notice("The overwhelming attraction fades away..."))
        else
            pet.apply_status_effect(/datum/status_effect/in_love, src)
            ADD_TRAIT(pet, TRAIT_LOVESTRUCK, COLLAR_TRAIT)
            to_chat(pet, span_love("You feel an overwhelming attraction to [src]!"))
        playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)

    to_chat(src, span_notice("You toggle love status for [length(CM.temp_selected_pets)] pets."))

/mob/proc/collar_master_force_arousal()
    set name = "Toggle Arousal"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar is still cooling down!"))
        return

    CM.last_command_time = world.time
    var/affected_pets = 0

    for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
        if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
            continue

        if(CM.toggle_arousal(pet))
            affected_pets++

    to_chat(src, span_notice("Toggled arousal for [affected_pets] pets."))

/mob/proc/collar_master_toggle_denial()
    set name = "Toggle Orgasm Denial"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar is still cooling down!"))
        return

    CM.last_command_time = world.time
    CM.deny_orgasm = !CM.deny_orgasm
    var/toggle_count = 0

    for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
        if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
            continue

        if(CM.toggle_denial(pet))
            toggle_count++

    to_chat(src, span_notice("Toggled orgasm restriction for [toggle_count] pets."))

/mob/proc/collar_master_toggle_hallucinate()
    set name = "Toggle Pet Hallucinations"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar is still cooling down!"))
        return

    CM.last_command_time = world.time

    for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
        if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
            continue

        if(pet.has_trauma_type(/datum/brain_trauma/mild/hallucinations))
            pet.cure_trauma_type(/datum/brain_trauma/mild/hallucinations, TRAUMA_RESILIENCE_BASIC)
            to_chat(pet, span_notice("Your collar pulses and the world becomes clearer."))
        else
            pet.gain_trauma(/datum/brain_trauma/mild/hallucinations, TRAUMA_RESILIENCE_BASIC)
            to_chat(pet, span_warning("Your collar pulses and the world begins to shift and warp!"))
        playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)

    to_chat(src, span_notice("You toggle hallucinations for [length(CM.temp_selected_pets)] pets."))

/mob/proc/collar_master_illusion()
    set name = "Create Illusion"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    var/message = input(src, "What should your pet, see, or feel?", "Impose will") as message|null
    if(!message || !CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar is still cooling down!"))
        return

    CM.last_command_time = world.time

    for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
        if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
            continue

        // Send message directly to pet's chat
        to_chat(pet, message)
        playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)

    to_chat(src, span_notice("You create an illusion for [length(CM.temp_selected_pets)] pets."))

/mob/proc/collar_master_share_damage()
    set name = "Share Damage"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(!ishuman(src))
        to_chat(src, span_warning("You must be human to share damage!"))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar is still cooling down!"))
        return

    var/mob/living/carbon/human/master = src
    CM.last_command_time = world.time
    var/shared_count = 0

    // Calculate total damage to share
    var/total_brute = master.getBruteLoss()
    var/total_burn = master.getFireLoss()
    var/total_oxy = master.getOxyLoss()
    var/blood_diff = 0
    if(master.blood_volume)
        blood_diff = BLOOD_VOLUME_NORMAL - master.blood_volume

    // Only proceed if there's damage to share
    if(total_brute <= 0 && total_burn <= 0 && total_oxy <= 0 && blood_diff <= 0)
        to_chat(src, span_warning("You have no damage to share!"))
        return

    for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
        if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
            continue

        if(pet.stat >= UNCONSCIOUS)
            to_chat(src, span_warning("[pet] must be conscious to share damage!"))
            continue

        // Share damage evenly
        if(total_brute > 0)
            pet.adjustBruteLoss(total_brute * 0.5)
            master.adjustBruteLoss(-(total_brute * 0.5))
        if(total_burn > 0)
            pet.adjustFireLoss(total_burn * 0.5)
            master.adjustFireLoss(-(total_burn * 0.5))
        if(total_oxy > 0)
            pet.adjustOxyLoss(total_oxy * 0.5)
            master.adjustOxyLoss(-(total_oxy * 0.5))

        // Share blood level if applicable
        if(blood_diff > 0 && pet.blood_volume)
            var/blood_share = min(blood_diff * 0.5, pet.blood_volume - BLOOD_VOLUME_SAFE)
            if(blood_share > 0)
                pet.blood_volume -= blood_share
                master.blood_volume += blood_share

        to_chat(pet, span_warning("You feel your master's pain transfer to you!"))
        shared_count++

    if(shared_count > 0)
        to_chat(src, span_notice("Shared damage with [shared_count] pets."))
    else
        to_chat(src, span_warning("Failed to share damage with any pets!"))

/mob/proc/collar_master_select_pets()
    set name = "Select Pets"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM)
        return

    if(!length(CM.my_pets))
        to_chat(src, span_warning("You have no pets to select!"))
        return

    var/list/pet_options = list()
    for(var/mob/living/carbon/human/pet in CM.my_pets)
        if(!pet || pet.stat == DEAD)
            continue
        pet_options[pet.name] = pet

    if(!length(pet_options))
        to_chat(src, span_warning("No valid pets available!"))
        return

    var/list/selected = input(src, "Select pets to command:", "Pet Selection") as null|anything in pet_options
    if(!selected)
        return

    CM.temp_selected_pets.Cut()
    if(islist(selected))
        for(var/name in selected)
            CM.temp_selected_pets += pet_options[name]
    else
        CM.temp_selected_pets += pet_options[selected]

    to_chat(src, span_notice("Selected [length(CM.temp_selected_pets)] pets."))

/mob/proc/collar_master_toggle_orgasm()
    set name = "Toggle Orgasm Denial"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar is still cooling down!"))
        return

    CM.last_command_time = world.time
    CM.deny_orgasm = !CM.deny_orgasm
    var/toggle_count = 0

    for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
        if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
            continue

        if(CM.toggle_denial(pet))
            toggle_count++

    to_chat(src, span_notice("Toggled orgasm restriction for [toggle_count] pets."))

/mob/proc/collar_master_release_pet()
    set name = "Release Pet"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM || !length(CM.temp_selected_pets))
        return

    if(world.time < CM.last_command_time + CM.command_cooldown)
        to_chat(src, span_warning("The collar is still cooling down!"))
        return

    var/confirm = alert("Are you sure you want to release the selected pets?", "Release Confirmation", "Yes", "No")
    if(confirm != "Yes")
        return

    CM.last_command_time = world.time
    var/released_count = 0

    for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
        if(!pet || !pet.mind || !(pet in CM.my_pets))
            continue

        // Handle collar removal properly
        var/obj/item/clothing/neck/roguetown/cursed_collar/collar = pet.get_item_by_slot(SLOT_NECK)
        if(istype(collar))
            REMOVE_TRAIT(collar, TRAIT_NODROP, CURSED_ITEM_TRAIT)
            pet.dropItemToGround(collar, force = TRUE)

        // Let cleanup_pet handle trait removal and slavebourne stats
        CM.cleanup_pet(pet)
        CM.temp_selected_pets -= pet

        to_chat(pet, span_notice("You have been released from your collar's control!"))
        released_count++

    if(released_count > 0)
        to_chat(src, span_notice("Released [released_count] pets from your control."))
    else
        to_chat(src, span_warning("Failed to release any pets!"))

/mob/proc/collar_master_help()
    set name = "Collar Help"
    set category = "Collar Tab"

    var/datum/antagonist/collar_master/CM = mind?.has_antag_datum(/datum/antagonist/collar_master)
    if(!CM)
        return

    var/help_text = {"<span class='notice'><b>Collar Master Commands:</b>
    - Select Pets: Choose which pets to affect with commands
    - Send Message: Send a message through the collar
    - Force Surrender: Force pets to submit
    - Shock Pet: Punish pets with varying intensity
    - Share Damage: Transfer your injuries to pets
    - Scry on Pet: See through your pets' eyes
    - Dominate Pet: Take direct control of a pet
    - Release Pet: Free pets from your control
    - Listen to pet: Hear what your pet hears
    - Shock Pets: To punish your pet
    - Force Strip: Strip your pet and forbid them from wearing clothes
    - Permit Clothing: Remove nudist
    - Toggle Pet Speech: Shuts the pet up, they can only make animal noises
    - Force Action: They are forced to say or emote what you type
    - Pass Wounds: Tranfer your injuries to your pet
    - Force Love: They are forced to love you
    - Toggle Arousal: Toggles their arousal
    - Toggle Orgasm Denial: Deny orgasms
    - Toggle Pet Hallucinations: They will hear things that are not there
    - Impose Will: Send an unfiltered message to your pet, this could be something they see, feel, etc
    - Free Pet: Collar will fall to the ground

    Note: Most commands have a [CM.command_cooldown/10] second cooldown.
    Currently controlling [length(CM.my_pets)] pets with [length(CM.temp_selected_pets)] selected.</span>"}

    to_chat(src, help_text)
