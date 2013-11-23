(defmodule presentacion
	(import MAIN ?ALL)
	(export ?ALL)
)

(defrule summary "Imprime un pequeño resumen"
	(Cliente (nombre ?nombre))
	(Preferencias (tipos $?tipos))
	=>
	(printout t "Nombre del cliente: " ?nombre crlf)
	(printout t "Tipos escogidos:" crlf)
	(progn$ (?tipo $?tipos)
		(printout t "    " ?tipo crlf)
	)
)