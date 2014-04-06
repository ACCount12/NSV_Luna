/obj/item/clothing/gloves/attackby(obj/item/weapon/W, mob/user)
	if(istype(src, /obj/item/clothing/gloves/boxing))	//quick fix for stunglove overlay not working nicely with boxing gloves.
		user << "<span class='notice'>That won't work.</span>"	//i'm not putting my lips on that!
		..()
		return
	if(istype(W, /obj/item/weapon/cable_coil))
		if(!("stunglove" in species_restricted))
			var/obj/item/weapon/cable_coil/C = W
			if(!wired)
				if(C.amount >= 2)
					C.use(2)
					wired = 1
					user << "<span class='notice'>You wrap some wires around [src].</span>"
					update_icon()
				else
					user << "<span class='notice'>There is not enough wire to cover [src].</span>"
			else
				user << "<span class='notice'>[src] are already wired.</span>"
		else
			user << "<span class='notice'[src] is not suitable for wiring.</span>"

	else if(istype(W, /obj/item/weapon/cell))
		if(!wired)
			user << "<span class='notice'>[src] need to be wired first.</span>"
		else if(!cell)
			user.drop_item()
			W.loc = src
			cell = W
			user << "<span class='notice'>You attach a cell to [src].</span>"
			update_icon()
		else
			user << "<span class='notice'>[src] already have a cell.</span>"

	else if(istype(W, /obj/item/weapon/wirecutters) || istype(W, /obj/item/weapon/scalpel))
		wired = null

		if(cell)
			cell.updateicon()
			cell.loc = get_turf(src.loc)
			cell = null
		if(clipped == 0)
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
			user.visible_message("\red [user] cut the fingertips off [src].","\red You cut the fingertips off [src].")
			clipped = 1
			if("exclude" in species_restricted)
				name = "mangled [name]"
				desc = "[desc] They have had the fingertips cut off of them."
				species_restricted -= "Unathi"
				species_restricted -= "Tajaran"
				species_restricted += "stunglove"
		else if(clipped == 1)
			user << "<span class='notice'>[src] have already been clipped!</span>"
			update_icon()

		return

		if(cell)
			cell.updateicon()
			cell.loc = get_turf(src.loc)
			cell = null
			user << "<span class='notice'>You cut the cell away from [src].</span>"
			update_icon()
			return
		if(wired) //wires disappear into the void because fuck that shit
			wired = 0
			user << "<span class='notice'>You cut the wires away from [src].</span>"
			update_icon()
		..()
	return

/obj/item/clothing/gloves/Touch(A, proximity, var/mob/living/carbon/user)
	if(!user)		return 0
	if(!proximity)	return 0
	if(!cell)		return 0

	if(iscarbon(A) && user.a_intent == "hurt")
		var/mob/living/carbon/M = A
		visible_message("\red <B>[A] has been touched with the stun gloves by [user]!</B>")
		if(cell.use(2500))
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Stungloved [M.name] ([M.ckey])</font>")
			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been stungloved by [user.name] ([user.ckey])</font>")
			msg_admin_attack("[user.name] ([user.ckey]) stungloved [M.name] ([M.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
			M.apply_effects(5,5,0,0,5,0,0,M.run_armor_check(user.zone_sel.selecting, "energy"))
			return 1
		else
			user << "\red Not enough charge!"
	/*
	else if(istype(A, /obj/machinery/power/apc) && user.a_intent == "grab")
		Maybe place stungloves charging code here?
	*/
	return 0



/obj/item/clothing/gloves/update_icon()
	..()
	overlays.Cut()
	if(wired)
		overlays += "gloves_wire"
	if(cell)
		overlays += "gloves_cell"