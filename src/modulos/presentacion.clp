(defmodule presentacion
	(import MAIN ?ALL)
	(export ?ALL)
)

(defrule summary "Imprime un pequeño resumen"
	(Preferencias (tipos-menu $?tipos))
	=>
	(printout t "Tipos escogidos:" crlf)
	(progn$ (?tipo $?tipos)
		(printout t "    " ?tipo crlf)
	)
	(printout t "Recomendaciones candidatas" crlf)
	(assert (imprimir-recomendaciones))
)

(defrule imprimir-recomendaciones "Imprime la lista completa de recomendaciones candidatas"
	(imprimir-recomendaciones)
	?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
	(not (rec-impresa ?rec))
	=>
	(printout t "Plato: " (send ?plato get-nombre) crlf)
	(printout t "   Puntuación: " ?punt crlf)
	(printout t "   Justificaciones:" crlf)
	(progn$ (?j $?just)
		(printout t "        " ?j crlf)
	)
	(assert (rec-impresa ?rec))
)
