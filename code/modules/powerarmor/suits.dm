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

/obj/item/clothing/suit/powered/spawnable/hev


//SYNDIE
/obj/item/clothing/head/powered/spawnable/syndie
	icon_state = "powered0-syndie"
	item_color = "syndie"

/obj/item/clothing/suit/powered/spawnable/full/syndie
	icon_state = "powered-syndie"


//DEATHSQUAD
/obj/item/clothing/head/powered/spawnable/deathsquad
	icon_state = "powered0-deathsquad"
	item_color = "deathsquad"

/obj/item/clothing/suit/powered/spawnable/full/deathsquad
	icon_state = "powered-deathsquad"