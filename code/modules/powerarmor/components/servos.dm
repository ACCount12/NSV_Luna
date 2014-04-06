/obj/item/weapon/powerarmor/servos
	name = "power armor movement servos"
	desc = ""
	icon = 'icons/obj/module.dmi'
	icon_state = "servo"
	var/toggleslowdown = 4

	toggle(sudden = 0)
		switch(parent.active)
			if(1)
				if(!sudden)
					usr << "\blue Movement assist servos disengaged."
				parent.slowdown += toggleslowdown
			if(0)
				usr << "\blue Movement assist servos engaged."
				parent.slowdown -= toggleslowdown

	is_subsystem()
		return 1