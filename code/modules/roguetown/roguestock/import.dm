/datum/roguestock/import
	import_only = TRUE
	stable_price = TRUE

/datum/roguestock/import/crackers
	name = "Bin of Rations"
	desc = "Low moisture bread that keeps well."
	item_type = /obj/item/roguebin/crackers
	export_price = 100
	importexport_amt = 1

/obj/item/roguebin/crackers/Initialize()
	. = ..()
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)

/obj/structure/closet/crate/chest/steward
	lockid = "steward"
	locked = TRUE
	masterkey = TRUE

/datum/roguestock/import/potion/health
	name = "Crate of Health Potions"
	desc = "Red that keeps men alive."
	item_type = /obj/structure/closet/crate/chest/steward/potion/health
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/potion/health/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)

/datum/roguestock/import/potion/majorhealth
	name = "Crate of Major Health Potions"
	desc = "Red that keeps men alive."
	item_type = /obj/structure/closet/crate/chest/steward/potion/majorhealth
	export_price = 200
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/potion/majorhealth/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/majorhealthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/majorhealthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/majorhealthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/majorhealthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/majorhealthpot(src)

/datum/roguestock/import/potion/ambrosia
	name = "Crate of Sublime Ambrosia"
	desc = "Red that brings men back to life."
	item_type = /obj/structure/closet/crate/chest/steward/potion/ambrosia
	export_price = 500
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/potion/ambrosia/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/sublimeambrosia(src)

/datum/roguestock/import/potion/fortitude
	name = "Crate of fortitude potions."
	desc = "A potion to enhance strength."
	item_type = /obj/structure/closet/crate/chest/steward/potion/fortitude
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/potion/fortitude/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/fortitudepot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/fortitudepot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/fortitudepot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/fortitudepot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/fortitudepot(src)

/datum/roguestock/import/potion/swiftness
	name = "Crate of swiftness potions."
	desc = "A potion to enhance speed."
	item_type = /obj/structure/closet/crate/chest/steward/potion/swiftness
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/potion/swiftness/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/swiftnesspot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/swiftnesspot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/swiftnesspot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/swiftnesspot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/swiftnesspot(src)

/datum/roguestock/import/potion/alacrity
	name = "Crate of alacrity potions."
	desc = "A potion to enhance perception."
	item_type = /obj/structure/closet/crate/chest/steward/potion/alacrity
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/potion/alacrity/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/alacritypot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/alacritypot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/alacritypot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/alacritypot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/alacritypot(src)

/datum/roguestock/import/potion/luck
	name = "Crate of luck potions."
	desc = "A potion to enhance fortune."
	item_type = /obj/structure/closet/crate/chest/steward/potion/luck
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/potion/luck/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/luckpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/luckpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/luckpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/luckpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/luckpot(src)

/datum/roguestock/import/potion/endurance
	name = "Crate of endurance potions."
	desc = "A potion to enhance endurance."
	item_type = /obj/structure/closet/crate/chest/steward/potion/endurance
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/potion/endurance/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/endurancepot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/endurancepot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/endurancepot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/endurancepot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/endurancepot(src)

/datum/roguestock/import/potion/constitution
	name = "Crate of constitution potions."
	desc = "A potion to enhance constitution."
	item_type = /obj/structure/closet/crate/chest/steward/potion/constitution
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/potion/constitution/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/constitutionpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/constitutionpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/constitutionpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/constitutionpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/constitutionpot(src)

/datum/roguestock/import/potion/intellect
	name = "Crate of intellect potions."
	desc = "A potion to enhance intelligence."
	item_type = /obj/structure/closet/crate/chest/steward/potion/intellect
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/potion/intellect/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/intellectpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/intellectpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/intellectpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/intellectpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/intellectpot(src)

/datum/roguestock/import/potion/nullmagic
	name = "Crate of nullmagic potions."
	desc = "A potion to protect against magic."
	item_type = /obj/structure/closet/crate/chest/steward/potion/nullmagic
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/potion/nullmagic/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/nullmagicpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/nullmagicpot(src)

/datum/roguestock/import/antipregger
	name = "Crate of Anti Pregnancy Potions"
	desc = "Pink that fixes mistakes."
	item_type = /obj/structure/closet/crate/chest/steward/redpotion
	export_price = 70
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/redpotion/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/antipregnancy(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/antipregnancy(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/antipregnancy(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/antipregnancy(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/antipregnancy(src)

/datum/roguestock/import/perfume
	name = "Crate of perfumes"
	desc = "To keep the stench away."
	item_type = /obj/structure/closet/crate/chest/steward/perfume
	export_price = 60
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/perfume/Initialize()
	. = ..()
	new /obj/item/perfume/random(src)
	new /obj/item/perfume/random(src)
	new /obj/item/perfume/random(src)
	new /obj/item/perfume/random(src)
	new /obj/item/perfume/random(src)

/datum/roguestock/import/mediumarmor
	name = "Fragment of the Old Guard"
	desc = "A magic crystal that gifts the skills needed to wear medium armor."
	item_type = /obj/structure/closet/crate/chest/steward/mediumarmor
	export_price = 150
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/mediumarmor/Initialize()
	. = ..()
	new /obj/item/book/granter/trait/defense/mediumarmor(src)

/datum/roguestock/import/heavyarmor
	name = "Fragment of the Forgotten Knight"
	desc = "A magic crystal that gifts the skills needed to wear heavy armor."
	item_type = /obj/structure/closet/crate/chest/steward/heavyarmor
	export_price = 250
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/heavyarmor/Initialize()
	. = ..()
	new /obj/item/book/granter/trait/defense/heavyarmor(src)

/datum/roguestock/import/acrobat
	name = "Fragment of the Acrobat"
	desc = "A magic crystal that makes one more nimble."
	item_type = /obj/structure/closet/crate/chest/steward/acrobat
	export_price = 200
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/acrobat/Initialize()
	. = ..()
	new /obj/item/book/granter/trait/acrobat(src)

/datum/roguestock/import/bogtrek
	name = "Fragment of the Swamp"
	desc = "A magic crystal that helps in quickly navigating muddy terrain."
	item_type = /obj/structure/closet/crate/chest/steward/bogtrek
	export_price = 150
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/bogtrek/Initialize()
	. = ..()
	new /obj/item/book/granter/trait/mobility/bogtrek(src)

/datum/roguestock/import/knight
	name = "Knight Equipment Crate"
	desc = "Kit for a Knight."
	item_type = /obj/structure/closet/crate/chest/steward/knight
	export_price = 400
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/knight/Initialize()
	. = ..()
	new /obj/item/clothing/head/roguetown/helmet/heavy/knight(src)
	new /obj/item/clothing/gloves/roguetown/plate(src)
	new /obj/item/clothing/under/roguetown/platelegs(src)
	new /obj/item/clothing/cloak/tabard/knight/guard(src)
	new /obj/item/clothing/neck/roguetown/bervor(src)
	new /obj/item/clothing/suit/roguetown/armor/chainmail(src)
	new /obj/item/clothing/suit/roguetown/armor/plate/full(src)
	new /obj/item/clothing/shoes/roguetown/boots/armor(src)
	new /obj/item/storage/belt/rogue/leather/hand(src)
	new /obj/item/rogueweapon/sword/long(src)

/datum/roguestock/import/dragonring
	name = "Dragonring Equipment Crate"
	desc = "A powerful artifact ring to enhance strength, constitution, and endurance."
	item_type = /obj/structure/closet/crate/chest/steward/knight
	export_price = 1000
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/knight/Initialize()
	. = ..()
	new /obj/item/clothing/ring/dragon_ring(src)

/datum/roguestock/import/manatarms
	name = "Man at Arms Equipment Crate"
	desc = "Kit for a Man at Arms."
	item_type = /obj/structure/closet/crate/chest/steward/manatarms
	export_price = 150
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/manatarms/Initialize()
	. = ..()
	new /obj/item/clothing/head/roguetown/helmet/bascinet(src)
	new /obj/item/clothing/under/roguetown/chainlegs(src)
	new /obj/item/clothing/cloak/stabard/surcoat/guard(src)
	new /obj/item/clothing/gloves/roguetown/plate(src)
	new /obj/item/clothing/neck/roguetown/gorget(src)
	new /obj/item/clothing/suit/roguetown/armor/chainmail(src)
	new /obj/item/clothing/suit/roguetown/armor/plate/half(src)
	new /obj/item/clothing/shoes/roguetown/boots/armor(src)
	new /obj/item/storage/belt/rogue/leather/hand(src)
	new /obj/item/rogueweapon/spear(src)

/datum/roguestock/import/crossbow
	name = "Crossbows Crate"
	desc = "A crate with 3 crossbows with 3 full quivers."
	item_type = /obj/structure/closet/crate/chest/steward/crossbow
	export_price = 300
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/crossbow/Initialize()
	. = ..()
	new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(src)
	new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(src)
	new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(src)
	new /obj/item/quiver/bolts(src)
	new /obj/item/quiver/bolts(src)
	new /obj/item/quiver/bolts(src)

/datum/roguestock/import/saigabuck
	name = "Saigabuck"
	desc = "One Saigabuck tamed with a saddle from a far away land"
	item_type = /mob/living/simple_animal/hostile/retaliate/rogue/saigabuck/tame/saddled/saigabuck
	export_price = 100
	importexport_amt = 1

/mob/living/simple_animal/hostile/retaliate/rogue/saigabuck/tame/saddled/saigabuck/Initialize()
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/rogue/saigabuck/tame/saddled(src)


/datum/roguestock/import/farmequip
	name = "Farm Equipment Crate"
	desc = "A crate with a pitchfork, sickle , hoe and some seeds."
	item_type = /obj/structure/closet/crate/chest/steward/farmequip
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/farmequip/Initialize()
	. = ..()
	new /obj/item/rogueweapon/hoe(src)
	new /obj/item/rogueweapon/pitchfork(src)
	new /obj/item/rogueweapon/sickle(src)
	new /obj/item/seeds/apple(src)
	new /obj/item/seeds/wheat(src)
	new /obj/item/seeds/berryrogue(src)
	new /obj/item/seeds/potato(src)

/datum/roguestock/import/blacksmith
	name = "Smith Crate"
	desc = "Stone, coal , iron ingot, wood bin, bucket with hammer and tongs."
	item_type = /obj/structure/closet/crate/chest/steward/blacksmith
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/blacksmith/Initialize()
	. = ..()
	new /obj/item/rogueweapon/hammer(src)
	new /obj/item/rogueweapon/tongs(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/rogueore/coal(src)
	new /obj/item/rogueore/coal(src)
	new /obj/item/ingot/iron(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/roguebin(src)
	new /obj/item/reagent_containers/glass/bucket/wooden(src)
