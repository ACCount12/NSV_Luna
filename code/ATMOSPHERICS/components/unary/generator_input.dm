/obj/machinery/atmospherics/unary/generator_input
	icon = 'icons/obj/teg.dmi'
	icon_state = "intact"
	density = 1

	name = "generator input"

	var/update_cycle

	update_icon()
		if(node)
			icon_state = "intact"
		else
			icon_state = "exposed"
		return

	proc
		return_exchange_air()
			return air_contents