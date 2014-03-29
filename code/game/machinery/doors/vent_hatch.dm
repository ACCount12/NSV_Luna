/obj/machinery/door/venthatch
	name = "vent"
	icon = 'icons/obj/structures.dmi'
	icon_state = "vent_base"
	var/bolted = 0
	var/welded = 0
	var/obj/structure/vent_cover/cover = null

	New(loc)
		cover = new(src.loc, src)
		check_cover()
		..()

	proc/check_cover()
		if(!istype(cover))
			del(src)


	open()
		if(bolted || welded) return 0
		check_cover()
		..()
		cover.loc = get_step(src,src.dir)

	close()
		check_cover()
		..()
		cover.loc = src.loc

	do_animate(animation)
		return

	update_icon()
		return


	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(air_group) return 1
		return ..()


/obj/structure/vent_cover
	name = "vent"
	icon_state = "vent_cover"
	anchored = 1
	density = 0
	layer = 4.1
	var/obj/machinery/door/venthatch/parent = null

	New(loc, source)
		parent = source
		check_parent()
		..()

	proc/check_parent()
		if(!istype(parent))
			del(src)


	attackby(obj/item/I as obj, mob/user as mob)
		check_parent()
		return parent.attackby(I, user)

	blob_act()
		check_parent()
		return parent.blob_act()

	ex_act(severity)
		check_parent()
		return parent.ex_act(severity)

	attack_hand(user)
		check_parent()
		return parent.attack_hand(user)