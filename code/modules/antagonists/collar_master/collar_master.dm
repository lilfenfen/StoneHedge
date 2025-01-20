#define COLLAR_TRAIT "collar_master"
#define EMOTE_MESSAGE "emote_message"
#define ANTAGONIST_PREVIEW_ICON_SIZE 96
#define COMSIG_LIVING_SURRENDER "living_surrender"
#define COLLAR_SURRENDER_TIME 10 SECONDS
#define COMSIG_MOB_CLICK_SHIFT "mob_click_shift"
#define COMPONENT_INTERRUPT_CLICK "interrupt_click"

/datum/status_effect/surrender/collar
    id = "collar_surrender"
    duration = COLLAR_SURRENDER_TIME
    alert_type = /atom/movable/screen/alert/status_effect/collar_surrender

/atom/movable/screen/alert/status_effect/collar_surrender
    name = "Forced Surrender"
    desc = "Your collar forces you to submit!"
    icon_state = "surrender"

/datum/antagonist/collar_master
    name = "Collar Master"
    roundend_category = "collar masters"
    antagpanel_category = "Collar Master"
    var/list/my_pets = list()
    var/list/temp_selected_pets = list()
    var/listening = FALSE
    var/deny_orgasm = FALSE
    var/dominating = FALSE
    var/silenced = FALSE
    var/scrying = FALSE
    var/last_command_time = 0
    var/command_cooldown = 2 SECONDS
    var/static/list/pet_sounds = list(
        "*lets out a soft whimper",
        "*whines quietly",
        "*makes a needy sound",
        "*lets out a submissive mewl",
        "*makes a pathetic noise",
        "*whimpers needily",
        "*mewls submissively",
        "*pants heavily",
        "*lets out a desperate whine",
        "*makes a pleading sound"
    )
    var/list/registered_pets = list()
    var/speech_altered = FALSE
    var/mob/living/carbon/human/original_pet_body
    var/mob/living/carbon/human/original_master_body

/datum/antagonist/collar_master/proc/add_pet(mob/living/carbon/human/pet)
    if(!pet || (pet in my_pets))
        return FALSE

    // Add to lists
    my_pets += pet
    registered_pets += pet

    // Register all signals including attack signals
    RegisterSignal(pet, COMSIG_MOB_SAY, PROC_REF(on_pet_say))
    RegisterSignal(pet, COMSIG_MOB_DEATH, PROC_REF(on_pet_death))
    RegisterSignal(pet, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_pet_attack))
    RegisterSignal(pet, COMSIG_MOB_ATTACK_HAND, PROC_REF(on_pet_attack))
    RegisterSignal(pet, COMSIG_ITEM_ATTACK, PROC_REF(on_pet_attack))
    RegisterSignal(pet, COMSIG_MOVABLE_MOVED, PROC_REF(on_pet_move))

    return TRUE

/datum/antagonist/collar_master/proc/on_pet_say(datum/source, list/speech_args)
    SIGNAL_HANDLER
    var/mob/living/carbon/human/pet = source
    if(!pet || !(pet in my_pets))
        return

    if(speech_altered)
        var/chosen_sound = pick(pet_sounds)
        pet.say(chosen_sound)  // This will make the pet "say" the full string including *
        return COMPONENT_CANCEL_SAY

/datum/antagonist/collar_master/proc/do_pet_emote(mob/living/carbon/human/pet)
    if(!pet || !(pet in my_pets))
        return
    pet.emote("me", EMOTE_VISIBLE, pick(pet_sounds))

/datum/antagonist/collar_master/proc/on_pet_death(datum/source)
    SIGNAL_HANDLER
    var/mob/living/carbon/human/pet = source
    if(!pet || !(pet in my_pets))
        return
    addtimer(CALLBACK(src, PROC_REF(cleanup_pet), pet), 0.1 SECONDS)

/datum/antagonist/collar_master/proc/remove_pet(mob/living/carbon/human/pet)
    if(!pet || !(pet in registered_pets))
        return FALSE

    UnregisterSignal(pet, list(
        COMSIG_MOB_SAY,
        COMSIG_MOB_DEATH,
        COMSIG_HUMAN_MELEE_UNARMED_ATTACK,
        COMSIG_MOB_ATTACK_HAND,
        COMSIG_ITEM_ATTACK
    ))

    registered_pets -= pet
    cleanup_pet(pet)
    return TRUE

/datum/antagonist/collar_master/proc/on_pet_move()
    SIGNAL_HANDLER
    var/mob/living/carbon/human/pet = usr
    if(!pet || !(pet in my_pets))
        return

    addtimer(CALLBACK(src, PROC_REF(check_pet_distance), pet), 0.3 SECONDS, TIMER_UNIQUE)

/datum/antagonist/collar_master/proc/check_pet_distance(mob/living/carbon/human/pet)
    if(!pet || !(pet in my_pets))
        return
    if(get_dist(pet, owner?.current) > 7)
        step_towards(pet, owner.current)
        if(prob(50))
            pet.emote("me", EMOTE_VISIBLE, pick(pet_sounds))

/datum/antagonist/collar_master/proc/on_pet_attack(datum/source, atom/target)
    SIGNAL_HANDLER
    var/mob/living/carbon/human/pet = source
    if(!pet || !(pet in my_pets))
        return NONE

    if(target == owner?.current)
        addtimer(CALLBACK(src, PROC_REF(shock_pet), pet, 25), 0.1 SECONDS)
        return COMPONENT_CANCEL_ATTACK
    return NONE

/datum/antagonist/collar_master/proc/shock_pet(mob/living/carbon/human/pet, intensity = 10)
    if(!pet || !(pet in my_pets))
        return FALSE

    var/mob/living/carbon/human/master = owner?.current
    if(!master)
        return FALSE

    // Calculate damage based on intensity
    var/damage = intensity * 0.5

    // Apply damage and effects
    pet.adjustFireLoss(damage)
    pet.adjustStaminaLoss(intensity * 2)
    pet.Knockdown(intensity * 0.2 SECONDS)
    pet.do_jitter_animation(intensity)

    // Visual effects
    pet.visible_message(span_danger("[pet]'s collar crackles with electricity!"), \
                       span_userdanger("Your collar sends searing pain through your body!"))

    var/turf/T = get_turf(pet)
    if(T)
        new /obj/effect/temp_visual/cult/sparks(T)
        playsound(T, list('sound/items/stunmace_hit (1).ogg','sound/items/stunmace_hit (2).ogg'), 50, TRUE)
        do_sparks(2, FALSE, pet)

    // Add a temporary overlay effect
    pet.flash_fullscreen("redflash3")
    addtimer(CALLBACK(pet, TYPE_PROC_REF(/mob/living, clear_fullscreen), "pain"), 2 SECONDS)

    return TRUE

/datum/antagonist/collar_master/proc/start_domination(mob/living/carbon/human/pet, mob/living/carbon/human/master)
    if(!pet || !(pet in my_pets) || !master || dominating)
        return FALSE

    // Store original bodies for reference
    master.name_archive = master.real_name
    pet.name_archive = pet.real_name
    original_pet_body = pet
    original_master_body = master

    // Swap minds
    var/datum/mind/master_mind = master.mind
    var/datum/mind/pet_mind = pet.mind

    master_mind.transfer_to(pet)
    pet_mind.transfer_to(master)

    dominating = TRUE

    // Visual effects
    pet.visible_message(span_danger("[master] stares intently at [pet], [master.p_their()] eyes glowing with an otherworldly light!"))
    to_chat(pet, span_userdanger("You feel your control slipping as [master] dominates your mind!"))
    playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)

    // Set timer to end domination
    addtimer(CALLBACK(src, PROC_REF(end_domination)), 30 SECONDS)
    return TRUE

/datum/antagonist/collar_master/proc/end_domination()
    if(!dominating || !original_pet_body || !original_master_body)
        return FALSE

    // Get the current minds in the swapped bodies
    var/datum/mind/mind_in_pet_body = original_pet_body.mind
    var/datum/mind/mind_in_master_body = original_master_body.mind

    if(!mind_in_pet_body || !mind_in_master_body)
        dominating = FALSE
        return FALSE

    // Transfer minds back to their original bodies
    mind_in_pet_body.transfer_to(original_master_body, force_key_move = TRUE)
    mind_in_master_body.transfer_to(original_pet_body, force_key_move = TRUE)

    // Restore original names
    original_master_body.real_name = original_master_body.name_archive
    original_pet_body.real_name = original_pet_body.name_archive
    original_master_body.name_archive = null
    original_pet_body.name_archive = null

    // Clear references
    original_master_body = null
    original_pet_body = null
    dominating = FALSE

    // Visual feedback
    to_chat(mind_in_master_body.current, span_notice("You return to your body, releasing control of your pet."))
    to_chat(mind_in_pet_body.current, span_notice("Your mind returns to your body as the domination ends!"))
    playsound(mind_in_pet_body.current, 'sound/misc/vampirespell.ogg', 50, TRUE)

    return TRUE

/datum/antagonist/collar_master/proc/select_pets(mob/user, action_name = "", allow_multiple = FALSE)
    var/list/valid_pets = list()
    for(var/mob/living/carbon/human/pet in my_pets)
        if(!pet || !pet.mind || !pet.client)
            continue
        valid_pets += pet

    if(!length(valid_pets))
        return list()

    if(allow_multiple)
        var/list/selected = input(user, "Choose pets to [action_name]:", "Pet Selection") as null|anything in valid_pets
        return selected ? selected : list()
    else
        var/mob/living/carbon/human/selected = input(user, "Choose a pet to [action_name]:", "Pet Selection") as null|anything in valid_pets
        return selected ? list(selected) : list()

/datum/antagonist/collar_master/proc/toggle_listening(mob/living/carbon/human/pet)
    if(!pet || !pet.mind || !pet.client || !(pet in my_pets))
        return FALSE

    listening = !listening
    if(listening)
        RegisterSignal(pet, COMSIG_MOB_SAY, PROC_REF(on_pet_say))
        RegisterSignal(pet, COMSIG_MOB_EMOTE, PROC_REF(on_pet_emote))
        RegisterSignal(pet, COMSIG_MOVABLE_HEAR, PROC_REF(on_pet_hear))
        to_chat(pet, span_warning("Your collar begins monitoring everything you hear and say!"))
        to_chat(owner.current, span_notice("You begin monitoring [pet]'s senses."))
    else
        UnregisterSignal(pet, list(
            COMSIG_MOB_SAY,
            COMSIG_MOB_EMOTE,
            COMSIG_MOVABLE_HEAR
        ))
        to_chat(pet, span_notice("Your collar stops monitoring you."))
        to_chat(owner.current, span_notice("You stop monitoring [pet]."))
    return TRUE

/datum/antagonist/collar_master/proc/on_pet_emote(datum/source, datum/emote/emote, mob/user, intentional)
    SIGNAL_HANDLER
    var/mob/living/carbon/human/pet = source
    if(!pet || !(pet in my_pets) || !listening || !owner?.current)
        return

    to_chat(owner.current, span_notice("<b>[pet]</b> [emote.message]"))

/datum/antagonist/collar_master/proc/on_pet_hear(datum/source, list/hearing_args)
    SIGNAL_HANDLER
    var/mob/living/carbon/human/pet = source
    if(!pet || !(pet in my_pets) || !listening || !owner?.current)
        return

    var/message = hearing_args["message"]
    var/speaker = hearing_args["speaker"]
    var/datum/language/speaking_language = hearing_args["language"]

    // Don't relay what the master says to avoid feedback loops
    if(speaker == owner.current)
        return

    to_chat(owner.current, span_notice("Through [pet]'s collar, you hear: \"[message]\""))

/datum/antagonist/collar_master/proc/force_strip(mob/living/carbon/human/pet)
    if(!pet || !(pet in my_pets))
        return FALSE

    pet.drop_all_held_items()
    // Additional stripping logic can be added here
    return TRUE

/datum/antagonist/collar_master/proc/toggle_hallucinations(mob/living/carbon/human/pet)
    if(!pet || !(pet in my_pets))
        return FALSE

    if(pet.has_trauma_type(/datum/brain_trauma/mild/hallucinations))
        pet.cure_trauma_type(/datum/brain_trauma/mild/hallucinations, TRAUMA_RESILIENCE_BASIC)
        to_chat(pet, span_notice("Your collar pulses and the world becomes clearer."))
    else
        pet.gain_trauma(/datum/brain_trauma/mild/hallucinations, TRAUMA_RESILIENCE_BASIC)
        to_chat(pet, span_warning("Your collar pulses and the world begins to shift and warp!"))
        pet.do_jitter_animation(20)
    playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
    return TRUE

/datum/antagonist/collar_master/proc/create_illusion(mob/living/carbon/human/pet, message)
    if(!pet || !(pet in my_pets))
        return FALSE

    to_chat(pet, span_warning("<b>Collar Illusion:</b> [message]"))
    pet.do_jitter_animation(20)
    playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
    return TRUE

/datum/antagonist/collar_master/proc/force_emote(mob/living/carbon/human/pet, emote_text)
    if(!pet || !(pet in my_pets))
        return FALSE

    pet.emote("me", EMOTE_VISIBLE, emote_text)
    return TRUE

/datum/antagonist/collar_master/proc/share_damage(mob/living/carbon/human/pet, mob/living/carbon/human/master)
    if(!pet || !(pet in my_pets) || !master)
        return FALSE

    var/total_damage = master.getBruteLoss() + master.getFireLoss() + master.getOxyLoss()
    if(total_damage <= 0)
        return FALSE

    var/damage_share = total_damage * 0.5
    pet.adjustBruteLoss(damage_share)
    master.adjustBruteLoss(-damage_share)

    // Share blood if applicable
    if(master.blood_volume && pet.blood_volume)
        var/blood_diff = BLOOD_VOLUME_NORMAL - master.blood_volume
        if(blood_diff > 0)
            var/blood_share = min(blood_diff * 0.5, pet.blood_volume - BLOOD_VOLUME_SAFE)
            if(blood_share > 0)
                pet.blood_volume -= blood_share
                master.blood_volume += blood_share

    return TRUE

/datum/antagonist/collar_master/proc/force_surrender(mob/living/carbon/human/pet)
    if(!pet || !(pet in my_pets))
        return FALSE

    if(pet.stat >= UNCONSCIOUS)
        return FALSE

    if(pet.surrendering)
        return FALSE

    pet.surrendering = TRUE
    pet.toggle_cmode()
    pet.changeNext_move(CLICK_CD_EXHAUSTED)

    // Create and attach the surrender flag visual
    var/obj/effect/temp_visual/surrender/flaggy = new(pet)
    pet.vis_contents += flaggy

    // Apply stun and status effects
    pet.Stun(300)
    pet.Knockdown(300)
    pet.apply_status_effect(/datum/status_effect/debuff/breedable)
    pet.apply_status_effect(/datum/status_effect/debuff/submissive)

    // Visual and sound effects
    pet.visible_message(span_warning("[pet] is forced to surrender by their collar!"), \
                       span_userdanger("Your collar forces you to submit!"))
    playsound(pet, 'sound/misc/surrender.ogg', 100, FALSE, -1, ignore_walls=TRUE)

    pet.update_vision_cone()
    addtimer(CALLBACK(pet, TYPE_PROC_REF(/mob/living, end_submit)), 600)

    return TRUE

/datum/antagonist/collar_master/proc/toggle_arousal(mob/living/carbon/human/pet, amount)
    if(!pet || !(pet in my_pets))
        return FALSE

    // Initialize sex_controller if needed
    if(!pet.sexcon)
        pet.sexcon = new /datum/sex_controller(pet)

    // Apply arousal through sexcon system
    pet.sexcon.adjust_arousal_manual(amount)

    // Visual feedback
    to_chat(pet, span_userdanger("Your collar sends waves of arousal through your body!"))
    pet.do_jitter_animation(20)
    playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)

    return TRUE

/datum/antagonist/collar_master/proc/check_arousal_effects(mob/living/carbon/human/pet)
    if(!pet?.sexcon)
        return

    var/arousal = pet.sexcon.arousal

    if(arousal >= 80)
        pet.overlay_fullscreen("arousal", /atom/movable/screen/fullscreen/arousal, 3)
    else if(arousal >= 50)
        pet.overlay_fullscreen("arousal", /atom/movable/screen/fullscreen/arousal, 2)
    else if(arousal >= 20)
        pet.overlay_fullscreen("arousal", /atom/movable/screen/fullscreen/arousal, 1)
    else
        pet.clear_fullscreen("arousal")

/datum/antagonist/collar_master/proc/force_arousal(mob/living/carbon/human/pet, amount)
    if(!pet || !(pet in my_pets))
        return FALSE

    // Initialize sex_controller if needed
    if(!pet.sexcon)
        pet.sexcon = new /datum/sex_controller(pet)

    // Apply arousal through sexcon system
    pet.sexcon.adjust_arousal_manual(amount)

    // Visual feedback
    to_chat(pet, span_userdanger("Your collar sends waves of arousal through your body!"))
    pet.do_jitter_animation(20)
    playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)

    // Check arousal effects after 5 seconds
    addtimer(CALLBACK(src, PROC_REF(check_arousal_effects), pet), 5 SECONDS)

    return TRUE

/datum/antagonist/collar_master/proc/force_love(mob/living/carbon/human/pet)
    if(!pet || !(pet in my_pets))
        return FALSE

    // Apply love effects
    pet.emote("blush")
    to_chat(pet, span_love("Your collar fills you with overwhelming affection!"))
    playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
    return TRUE

/datum/antagonist/collar_master/proc/permit_clothing(mob/living/carbon/human/pet, permitted = TRUE)
    if(!pet || !(pet in my_pets))
        return FALSE

    if(permitted)
        REMOVE_TRAIT(pet, TRAIT_NUDIST, COLLAR_TRAIT)
        to_chat(pet, span_notice("Your collar allows you to wear clothing again."))
    else
        ADD_TRAIT(pet, TRAIT_NUDIST, COLLAR_TRAIT)
        to_chat(pet, span_warning("Your collar prevents you from wearing clothing!"))
    playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
    return TRUE

/datum/antagonist/collar_master/proc/check_pet_status(mob/living/carbon/human/pet)
    if(!pet || !(pet in my_pets))
        return FALSE

    var/status_text = "<span class='notice'><b>[pet.real_name] Status:</b>\n"
    status_text += "Health: [pet.health]/[pet.maxHealth]\n"
    status_text += "Location: [get_area(pet)]\n"
    status_text += "Mental State: [pet.stat >= UNCONSCIOUS ? "Unconscious" : "Conscious"]\n"
    status_text += "Active Traits: "

    var/list/active_traits = list()
    if(speech_altered)
        active_traits += "Speech Altered"

    status_text += active_traits.len ? english_list(active_traits) : "None"
    status_text += "</span>"

    return status_text

/datum/antagonist/collar_master/proc/mass_command(command_type, list/targets, ...)
    if(!length(targets))
        return FALSE

    var/success_count = 0
    for(var/mob/living/carbon/human/pet in targets)
        if(!pet || !(pet in my_pets))
            continue

        switch(command_type)
            if("shock")
                var/intensity = args[1]
                if(shock_pet(pet, intensity))
                    success_count++
            if("surrender")
                if(force_surrender(pet))
                    success_count++
            if("strip")
                if(force_strip(pet))
                    success_count++
            if("arousal")
                if(toggle_arousal(pet))
                    success_count++
            if("love")
                if(force_love(pet))
                    success_count++
            if("hallucinate")
                if(toggle_hallucinations(pet))
                    success_count++

    return success_count

/datum/antagonist/collar_master/proc/on_pet_examine(mob/living/carbon/human/pet, mob/user)
    if(!pet || !(pet in my_pets))
        return

    if(user == owner?.current)
        to_chat(user, span_notice("\n[check_pet_status(pet)]"))
    else if(user != pet)
        to_chat(user, span_warning("\nThey wear a strange collar around their neck."))

/datum/antagonist/collar_master/proc/cleanup_pet(mob/living/carbon/human/pet)
    if(!pet || !(pet in my_pets))
        return FALSE

    // Remove all collar-related traits
    REMOVE_TRAIT(pet, TRAIT_NUDIST, COLLAR_TRAIT)

    // Remove from lists
    my_pets -= pet
    registered_pets -= pet

    // Handle collar removal
    var/obj/item/clothing/neck/roguetown/cursed_collar/collar = pet.get_item_by_slot(SLOT_NECK)
    if(istype(collar))
        pet.dropItemToGround(collar, force = TRUE)
        REMOVE_TRAIT(collar, TRAIT_NODROP, CURSED_ITEM_TRAIT)

    // Let the slavebourne trait handle its own debuff
    // Don't apply debuff here since on_uncollared will handle it

    // Feedback
    to_chat(pet, span_notice("Your mind clears as the collar's control fades!"))
    if(owner?.current)
        to_chat(owner.current, span_warning("[pet] is no longer under your control!"))

    return TRUE

/datum/antagonist/collar_master/on_gain()
    . = ..()
    if(owner?.current)
        owner.current.verbs += list(
            /mob/proc/collar_master_control_menu,
            /mob/proc/collar_master_help
        )

/datum/antagonist/collar_master/on_removal()
    if(owner?.current)
        owner.current.verbs -= list(
            /mob/proc/collar_master_control_menu,
            /mob/proc/collar_master_help
        )
    . = ..()

/datum/antagonist/collar_master/proc/pass_wounds(mob/living/carbon/human/pet)
    if(!pet || !(pet in my_pets))
        return FALSE

    var/mob/living/carbon/human/master = owner?.current
    if(!master)
        return FALSE

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
    pet.visible_message(span_warning("[pet] shudders as [master]'s wounds manifest on their body!"))
    pet.do_jitter_animation(20)

    // Heal the master slightly
    master.adjustBruteLoss(-10)
    master.adjustFireLoss(-10)
    master.adjustOxyLoss(-10)

    return TRUE

/datum/antagonist/collar_master/proc/toggle_speech(mob/living/carbon/human/pet)
    if(!pet || !(pet in my_pets))
        return FALSE

    speech_altered = !speech_altered
    if(speech_altered)
        to_chat(pet, span_warning("Your collar tingles, altering how you communicate!"))
        pet.visible_message(span_warning("[pet]'s collar glows brightly as their speech is altered!"))
        pet.emote("me", EMOTE_VISIBLE, pick(pet_sounds))
    else
        to_chat(pet, span_notice("Your collar allows you to speak normally again."))
        pet.visible_message(span_notice("[pet]'s collar dims as their voice is restored."))

    playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
    return TRUE
