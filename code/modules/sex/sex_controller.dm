/datum/sex_controller
    var/arousal = 0
    var/mob/living/carbon/human/parent

/datum/sex_controller/Initialize(mob/living/carbon/human/new_parent)
    . = ..()
    parent = new_parent

/datum/sex_controller/proc/adjust_arousal_manual(amount)
    if(!parent || !istype(parent))
        return

    // Check if parent has deny_orgasm trait from a collar master
    var/list/collar_masters = list()
    for(var/datum/antagonist/collar_master/CM in GLOB.antagonists)
        if(parent in CM.my_pets && CM.deny_orgasm)
            collar_masters += CM

    // If denied, cap at 96
    if(length(collar_masters) && amount > 96)
        amount = 96

    arousal = clamp(amount, 0, 100)

    // Update screen effects based on arousal level
    if(arousal >= 80)
        parent.overlay_fullscreen("arousal", /atom/movable/screen/fullscreen/arousal, 3)
    else if(arousal >= 50)
        parent.overlay_fullscreen("arousal", /atom/movable/screen/fullscreen/arousal, 2)
    else if(arousal >= 20)
        parent.overlay_fullscreen("arousal", /atom/movable/screen/fullscreen/arousal, 1)
    else
        parent.clear_fullscreen("arousal")

    // Try climax if arousal hits 100
    if(arousal >= 100)
        try_climax()

/datum/sex_controller/proc/try_climax()
    if(!parent || !istype(parent, /mob/living/carbon/human))
        return

    // Send signal first - if it returns COMPONENT_CANCEL_CLIMAX, stop here
    if(SEND_SIGNAL(parent, COMSIG_SEXCONTROLLER_CLIMAX) & COMPONENT_CANCEL_CLIMAX)
        return

    // Actual climax effects
    to_chat(parent, span_love("You reach climax!"))
    parent.do_jitter_animation(30)
    parent.emote("moan")
    adjust_arousal_manual(0)  // Reset arousal
    playsound(parent, 'sound/misc/mat/segso.ogg', 50, TRUE)
