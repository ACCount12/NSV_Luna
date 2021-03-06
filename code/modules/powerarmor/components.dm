/obj/item/weapon/powerarmor
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = "tesla"
	name = "power armor component"
	desc = "This is the base object, you should never see one."
	var/obj/item/clothing/suit/powered/parent //so the component knows which armor it belongs to.
	var/obj/effect/proc_holder/stat_button/button // for control panel
	slowdown = 0 //how much the component slows down the wearer

	proc/toggle()
		return
		//The child objects will use this proc

	proc/is_subsystem()
		return 0

	proc/add_to(var/obj/item/clothing/suit/powered/S)
		if(!istype(S))
			return

		if(loc != S)
			if(ismob(src.loc))
				var/mob/M = src.loc
				M.unEquip(src)
		src.loc = S
		src.parent = S

	proc/drop()
		if(!istype(loc, /obj/item/clothing/suit/powered))
			return
		src.loc = get_turf(src)

		if(src == parent.reactive)
			parent.reactive = null

		else if(src == parent.atmoseal)
			parent.atmoseal = null

		else if(src == parent.power)
			parent.power = null

		else if(src in parent.subsystems)
			parent.subsystems.Remove(src)

		src.parent = null