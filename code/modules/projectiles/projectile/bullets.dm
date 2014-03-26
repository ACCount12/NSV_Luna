/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	damage = 60
	damage_type = BRUTE
	nodamage = 0
	flag = "bullet"
	embed = 1

	on_hit(var/atom/target, var/blocked = 0)
		if (..(target, blocked))
			var/mob/living/L = target
			shake_camera(L, 3, 2)

/obj/item/projectile/bullet/weakbullet
	damage = 10
	stun = 8
	weaken = 8
	embed = 0


/obj/item/projectile/bullet/midbullet
	damage = 40
	stun = 5
	weaken = 5

/obj/item/projectile/bullet/midbullet2
	damage = 50

/obj/item/projectile/bullet/suffocationbullet//How does this even work?
	name = "co bullet"
	damage = 20
	damage_type = OXY


/obj/item/projectile/bullet/cyanideround
	name = "poison bullet"
	damage = 40
	damage_type = TOX


/obj/item/projectile/bullet/burstbullet//I think this one needs something for the on hit
	name = "exploding bullet"
	damage = 20
	embed = 0

	on_hit(var/atom/target, var/blocked = 0)
		if (..(target, blocked))
			var/obj/O = target
			O.ex_act(3)

/obj/item/projectile/bullet/stunshot
	name = "stunshot"
	damage = 5
	stun = 15
	weaken = 10
	stutter = 10
	embed = 0

/obj/item/projectile/bullet/SW
	damage = 35
	stun = 15
	weaken = 15

/obj/item/projectile/bullet/a762
	damage = 25

/obj/item/projectile/bullet/beretta
	damage = 27
