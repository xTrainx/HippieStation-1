/obj/effect/proc_holder/changeling/revive
	name = "Revive"
	desc = "We regenerate, healing all damage from our form - assuming we're not on fire or dead."
	helptext = "Does not regrow lost organs or a missing head."
	req_stat = DEAD
	always_keep = TRUE
	ignores_fakedeath = TRUE

//Revive from revival stasis
/obj/effect/proc_holder/changeling/revive/sting_action(mob/living/carbon/user)
	if(user.stat == DEAD)
		to_chat(user, "<span class='danger'>Thought you were hot? Guess what, you're not. You are dead.</span>")
		return
	if(user.on_fire)
		to_chat(user, "<span class='notice'>We cannot regenerate while on fire.</span>")
		return
	user.cure_fakedeath("changeling")
	user.revive(full_heal = 1)
	var/list/missing = user.get_missing_limbs()
	missing -= "head" // headless changelings are funny
	if(missing.len)
		playsound(user, 'sound/magic/demon_consume.ogg', 50, 1)
		user.visible_message("<span class='warning'>[user]'s missing limbs \
			reform, making a loud, grotesque sound!</span>",
			"<span class='userdanger'>Your limbs regrow, making a \
			loud, crunchy sound and giving you great pain!</span>",
			"<span class='italics'>You hear organic matter ripping \
			and tearing!</span>")
		user.emote("scream")
		user.regenerate_limbs(0, list("head"))
	user.regenerate_organs()
	to_chat(user, "<span class='notice'>We have revived ourselves.</span>")
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	changeling.purchasedpowers -= src
	return TRUE

/obj/effect/proc_holder/changeling/revive/can_be_used_by(mob/living/user)
	if(!(user.has_trait(TRAIT_FAKEDEATH)))
		var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
		changeling.purchasedpowers -= src
		return 0
	. = ..()
