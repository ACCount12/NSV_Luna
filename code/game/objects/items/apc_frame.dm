// APC HULL
/obj/item/wallframe
	flags = FPRINT| CONDUCT

/obj/item/wallframe/proc/try_build(turf/on_wall)
	if (get_dist(on_wall,usr)>1)
		return
	var/ndir = get_dir(usr,on_wall)
	if (!(ndir in cardinal))
		return

	return 1

/obj/item/wallframe/apc
	name = "APC frame"
	desc = "Used for repairing or building APCs"
	icon = 'icons/obj/apc.dmi'
	icon_state = "apc_frame"

/obj/item/wallframe/apc/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/stack/sheet/metal( get_turf(src.loc), 2 )
		del(src)

/obj/item/wallframe/apc/try_build(turf/on_wall)
	if(!..())
		return

	var/ndir = get_dir(usr,on_wall)
	var/turf/loc = get_turf(usr)
	var/area/A = loc.loc
	if (!istype(loc, /turf/simulated/floor))
		usr << "\red APC cannot be placed on this spot."
		return
	if (A.requires_power == 0 || A.name == "Space")
		usr << "\red APC cannot be placed in this area."
		return
	if (A.get_apc())
		usr << "\red This area already has APC."
		return //only one APC per area
	for(var/obj/machinery/power/terminal/T in loc)
		if (T.master)
			usr << "\red There is another network terminal here."
			return
		else
			var/obj/item/weapon/cable_coil/C = new /obj/item/weapon/cable_coil(loc)
			C.amount = 10
			usr << "You cut the cables and disassemble the unused power terminal."
			del(T)
	new /obj/machinery/power/apc(loc, ndir, 1)
	del(src)
