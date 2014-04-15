/obj/item/weapon/powerarmor/weapon
	proc/pattack(var/atom/A, var/mob/living/carbon/user)
		return 0

/obj/item/weapon/powerarmor/weapon/meele

/obj/item/weapon/powerarmor/weapon/ranged
	proc/load(var/obj/item/I, var/mob/user)
		return 0

	proc/chamber_shot()
		return null

	proc/fire_proj(var/atom/A, var/mob/living/carbon/user, var/obj/item/projectile/in_chamber)
		var/turf/curloc = get_turf(user)
		var/turf/targloc = get_turf(A)
		if (!istype(targloc) || !istype(curloc))
			return
		if(!in_chamber)	return

		in_chamber.firer = user
		in_chamber.def_zone = user.zone_sel.selecting
		if(targloc == curloc)
			user.bullet_act(in_chamber)
			del(in_chamber)
			return

		user.visible_message("<span class='warning'>[user] fires [src]!</span>", \
		"<span class='warning'>You fire [src]!</span>", \
		"You hear a [istype(in_chamber, /obj/item/projectile/beam) ? "laser blast" : "gunshot"]!")

		in_chamber.original = A
		in_chamber.loc = get_turf(user)
		in_chamber.starting = get_turf(user)
		in_chamber.shot_from = src
		user.next_move = world.time + 4
		in_chamber.current = curloc
		in_chamber.yo = targloc.y - curloc.y
		in_chamber.xo = targloc.x - curloc.x

		spawn()
			if(in_chamber)
				in_chamber.process()
		sleep(1)
		in_chamber = null

// MEELE
/obj/item/weapon/powerarmor/weapon/meele/multiplier
	name = "punch repeater"
	desc = "Repeats your hand's movements with a set of servos."

	pattack(var/atom/A, var/mob/living/carbon/user)
		if(ismob(A) && parent.use_power(60))
			A.attack_hand(user)
			A.attack_hand(user)
			A.attack_hand(user)
			return 1
		return 0

/obj/item/weapon/powerarmor/weapon/meele/hydraulic
	name = "hydraulic punch amplifier"
	desc = "Smashing skulls never was so fun!"

	pattack(var/atom/A, var/mob/living/carbon/user)
		if(ismob(A) && parent.use_power(100))
			A.attack_hand(user)
			var/mob/M = A
			var/throwdir = get_dir(user,M)
			M.throw_at(get_edge_target_turf(M, throwdir),5,4)
			return 1
		return 0


// RANGED
/obj/item/weapon/powerarmor/weapon/ranged/energy
	name = "energy bolt driver"
	var/proj_type = /obj/item/projectile/forcebolt
	var/shot_cost = 400

	pattack(var/atom/A, var/mob/living/carbon/user)
		fire_proj(A, user, chamber_shot())
		return 1

	chamber_shot()
		if(parent.use_power(shot_cost))
			return new proj_type(src)
		return ..()

/obj/item/weapon/powerarmor/weapon/ranged/proj
	name = "minirocket launcher"
	icon_state = "missile_mini"

	var/list/ammo = list()
	var/max_ammo = 6
	var/caliber = ".75"
	var/ammo_type = /obj/item/ammo_casing/a75

	pattack(var/atom/A, var/mob/living/carbon/user)
		fire_proj(A, user, chamber_shot())
		return 1

	chamber_shot()
		var/obj/item/ammo_casing/AC = ammo[1] //Find chambered round
		if(isnull(AC) || !istype(AC))
			return ..()
		AC.on_fired()

		if(AC.BB)
			var/obj/item/projectile/in_chamber = AC.BB
			del(AC)
			return in_chamber
		del(AC)
		return ..()

	New()
		..()
		while(ammo.len < max_ammo)
			ammo.Add(new ammo_type(src))