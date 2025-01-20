// Mob signals
#define COMSIG_MOB_ATTACK "mob_attack"
#define COMSIG_MOB_SAY "mob_say"
#define COMSIG_MOB_CLICKON "mob_clickon"
#define COMSIG_LIVING_TRY_ATTACK "living_try_attack"
#define COMSIG_MOB_EMOTE "mob_emote"

// Item signals
#define COMSIG_ITEM_PRE_UNEQUIP "item_pre_unequip"

// Return flags
#define COMPONENT_CANCEL_ATTACK (1<<0)
#define COMPONENT_CANCEL_SAY (1<<0)
#define COMPONENT_ITEM_BLOCK_UNEQUIP (1<<0)
#define COMPONENT_CANCEL_EMOTE (1<<1)

// Collar signals
#define COMSIG_CARBON_GAIN_COLLAR "carbon_gain_collar"
#define COMSIG_CARBON_LOSE_COLLAR "carbon_lose_collar"

// Living death signal
#define COMSIG_LIVING_DEATH "mob_death"

// Living revive signal
#define COMSIG_LIVING_REVIVE "mob_revive"

// Sex Controller Signals
#define COMSIG_SEXCONTROLLER_CLIMAX "sex_controller_climax"
#define COMSIG_SEXCONTROLLER_AROUSAL_CHANGE "sex_controller_arousal_change"

// Sex Controller Return Values
#define COMPONENT_CANCEL_CLIMAX (1<<0)

// Emote return values
#define COMPONENT_EMOTE_MESSAGE_CHANGED (1<<0)
