/obj/item/clothing/suit/powered
	name = "powered armor"
	desc = "Not for rookies."
	icon_state = "powered-riot"
	item_state = "swat"
	w_class = 4//bulky item

	flags = FPRINT
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	armor = list(melee = 40, bullet = 30, laser = 20,energy = 15, bomb = 25, bio = 10, rad = 10)
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/gun, /obj/item/weapon/handcuffs, /obj/item/weapon/tank)
	slowdown = 9

	var/list/togglearmor = list(melee = 90, bullet = 70, laser = 60,energy = 40, bomb = 75, bio = 75, rad = 75)
	var/active = 0

	var/helmrequired = 0
	var/obj/item/clothing/head/powered/helm
	var/glovesrequired = 1
	var/obj/item/clothing/gloves/powered/gloves
	var/shoesrequired = 0
	var/obj/item/clothing/shoes/powered/shoes

	var/obj/effect/proc_holder/stat_button/button

	var/list/subsystems = list()

	var/obj/item/weapon/powerarmor/reactive/reactive
	var/obj/item/weapon/powerarmor/atmoseal/atmoseal
	var/obj/item/weapon/powerarmor/power/power

	var/obj/item/weapon/powerarmor/weapon/meele/meele
	var/obj/item/weapon/powerarmor/weapon/ranged/ranged

	var/obj/item/weapon/cell/powercell

	New()
		button = new(null, src, "Toggle armor")
		powercell = new /obj/item/weapon/cell/high(src)

	proc/get_power()
		if(!powercell)		return 0
		return powercell.charge

	proc/use_power(var/amount)
		if(!get_power())	return 0
		. = powercell.use(amount)
		if(!get_power())
			powerdown(1)
		return .

	process()
		if(!active)
			processing_objects.Remove(src)
			return
		for(var/obj/item/weapon/powerarmor/I in src)
			I.process()

		if(helm)		helm.process()

	proc/poweron()
		var/mob/living/carbon/human/user = usr

		if(user.wear_suit != src)	return
		if(active)					return

		if(!get_power())
			user << "\red Power source missing or depleted."
			return

		powerup()

	proc/powerup() // separated for powerarmor-wearing corpses
		var/mob/living/carbon/human/user = src.loc
		if(helmrequired && !istype(user.head, /obj/item/clothing/head/powered))
			user << "\red Helmet missing, unable to initiate power-on procedure."
			return

		if(glovesrequired && !istype(user.gloves, /obj/item/clothing/gloves/powered))
			user << "\red Gloves missing, unable to initiate power-on procedure."
			return

		if(shoesrequired && !istype(user.shoes, /obj/item/clothing/shoes/powered))
			user << "\red Shoes missing, unable to initiate power-on procedure."
			return

		verbs -= /obj/item/clothing/suit/powered/proc/poweron
		user << "\blue Suit interlocks engaged."
		if(helmrequired)
			helm = user.head
			helm.canremove = 0
		if(glovesrequired)
			gloves = user.gloves
			gloves.canremove = 0
		if(shoesrequired)
			shoes = user.shoes
			shoes.canremove = 0
		canremove = 0
		sleep(20)

		if(atmoseal)
			atmoseal.toggle()
			sleep(20)

		if(reactive)
			reactive.toggle()
			sleep(20)

		if(subsystems.len)
			user << "\blue Engaging subsystems..."
			for(var/obj/item/weapon/powerarmor/I in subsystems)
				I.toggle()
				sleep(5)

		user << "\blue All systems online."
		active = 1
		processing_objects.Add(src)

	proc/powerdown(sudden = 0)
		var/delay = sudden?0:20
		var/mob/living/carbon/human/user = usr
		if(!istype(user)) 			return
		if(user.wear_suit != src)	return
		if(!active)					return

		if(atmoseal)
			if(istype(atmoseal, /obj/item/weapon/powerarmor/atmoseal/optional) && helm)
				atmoseal:helmtoggle(sudden)
			atmoseal.toggle(sudden)
			sleep(delay)

		if(subsystems.len)
			if(!sudden)
				user << "\blue Disengaging subsystems..."
			for(var/obj/item/weapon/powerarmor/I in subsystems)
				I.toggle()
				sleep(delay/4)

		if(helm && helm.on)
			helm.on = 0
			helm.update_icon()
			user.SetLuminosity(user.luminosity - helm.brightness_on)

		if(!sudden)
			usr << "\blue Suit interlocks disengaged."
			if(helm)
				helm.canremove = 1
				helm = null
			if(gloves)
				gloves.canremove = 1
				gloves = null
			if(shoes)
				shoes.canremove = 1
				gloves = null
			canremove = 1
			//Not a tabbing error, the thing only unlocks if you intentionally power-down the armor. --NEO
		sleep(delay)

		if(sudden)
			user << "\red Your armor loses power!"
		else
			user << "\blue All systems disengaged."

		active = 0

	Stat()
		if(!(src in usr))	return
		if(!active)
			statpanel("Power Armor", button)
			return

		statpanel("Power Armor", "Control Panel", button)
		if(powercell)
			statpanel("Power Armor", "Power:", "[powercell.charge]/[powercell.maxcharge]")
		else
			statpanel("Power Armor", "Power:", "\[MISSING\]")
		statpanel("Power Armor", "", " ")

		var/i = ""
		for(var/obj/item/weapon/powerarmor/I in src)
			i += "  "
			I.Stat()


	stat_button(var/name)
		if(name == "Toggle armor")
			if(active)
				powerdown()
			else
				poweron()

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(powercell)
			if(isscrewdriver(W))
				user << "\red You remove [src]'s power cell!"
				powercell.loc = get_turf(src)
				powercell = null
				return
		else if(!active)
			if(istype(W, /obj/item/weapon/cell))
				user << "\blue You insert power cell into [src]."
				user.unEquip(W)
				powercell = W
				powercell.loc = src
				return

			if(iscrowbar(W))
				if(subsystems.len)
					for(var/obj/item/weapon/powerarmor/I in subsystems)
						I.drop()
					user << "\red You remove [src]'s subsystems!"

				else if(meele)
					user << "\red You remove [meele] from [src]!"
					meele.drop()

				else if(ranged)
					user << "\red You remove [ranged] from [src]!"
					ranged.drop()

				else if(power)
					user << "\red You remove [src]'s power generator!"
					power.drop()
				return

			if(istype(W, /obj/item/weapon/powerarmor))
				var/obj/item/weapon/powerarmor/C = W
				var/installed = 0
				if(C.is_subsystem())
					subsystems.Add(C)
					installed = 1

				else if(istype(C, /obj/item/weapon/powerarmor/power) && !power)
					power = C
					installed = 1

				else if(istype(C, /obj/item/weapon/powerarmor/weapon/meele) && !meele)
					meele = C
					installed = 1

				else if(istype(C, /obj/item/weapon/powerarmor/weapon/ranged) && !ranged)
					ranged = C
					installed = 1

				if(installed)
					C.add_to(src)
					user << "\blue You insert [C] into [src]."

		if(istype(power) && power.fuel(W, user))
			return

		if(istype(ranged) && ranged.load(W, user))
			return
		..()