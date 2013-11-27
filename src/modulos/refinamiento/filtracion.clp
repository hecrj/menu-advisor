(defmodule filtracion
	(import MAIN ?ALL)
	(export ?ALL)
)

(defrule crear-recomendaciones-iniciales "Crea las recomendaciones iniciales en función de los tipos del menú abstracto"
	(Preferencias (tipos $?tipos))
	=>
	(bind $?platos (find-all-instances ((?inst Plato)) TRUE))
	(progn$ (?plato $?platos)
		(bind ?tipo_plato (send ?plato get-tipo))
		(if (or (eq (length ?tipos) 0) (or (member$ ?tipo_plato ?tipos) (eq ?tipo_plato INDEFINIDO))) then
			(make-instance (gensym) of Recomendacion (plato ?plato))
			(bind ?nombre (send ?plato get-nombre))
			(printout t ?nombre crlf)
		)
	)

	(focus puntuacion)
)
