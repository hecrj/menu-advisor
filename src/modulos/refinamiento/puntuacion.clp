(defmodule puntuacion
	(import MAIN ?ALL)
	(export ?ALL)
)

(defrule puntuar-tipos "Puntúa los tipos de plato que coinciden con el tipo de menú abstracto"
	(Preferencias (tipos ?tipo_menu))
	(object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt))
	=>
	(bind ?tipo_plato (send ?plato get-tipo))
	(if (eq ?tipo_plato ?tipo_menu) then
		
	)
)
