/obj/item/clothing/suit/powered/spawnable/New()
	var/obj/item/weapon/powerarmor/C = new /obj/item/weapon/powerarmor/servos(src)
	C.add_to(src)
	subsystems.Add(C)

	reactive = new /obj/item/weapon/powerarmor/reactive/centcomm(src)
	reactive.add_to(src)
	..()


/obj/item/clothing/suit/powered/spawnable/full
	helmrequired = 1

	New()
		atmoseal = new /obj/item/weapon/powerarmor/atmoseal/optional/adminbus(src)
		atmoseal.add_to(src)
		..()


// HEV
/obj/item/clothing/suit/powered/spawnable/hev
	name = "HEV"
	icon_state = "HEVsuit"


// BATMAN
/obj/item/clothing/suit/powered/spawnable/full/batman
	name = "batsuit"
	icon_state = "batmansuit"

/obj/item/clothing/head/powered/spawnable/batman
	name = "batmask"
	icon_state = "batmask"
	brightness_on = 0


// orderly_riot
/obj/item/clothing/suit/powered/spawnable/full/orderly_riot
	icon_state = "orderly_riot"

/obj/item/clothing/head/powered/spawnable/orderly_riot
	icon_state = "orderly_riot"
	brightness_on = 0


// SYNDIE
/obj/item/clothing/head/powered/spawnable/syndie
	icon_state = "powered0-syndie"
	item_color = "syndie"

/obj/item/clothing/suit/powered/spawnable/full/syndie
	icon_state = "powered-syndie"


// DEATHSQUAD
/obj/item/clothing/head/powered/spawnable/deathsquad
	icon_state = "powered0-deathsquad"
	item_color = "deathsquad"

/obj/item/clothing/suit/powered/spawnable/full/deathsquad
	icon_state = "powered-deathsquad"