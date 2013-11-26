(defmodule abstraccion
	(import MAIN ?ALL)
	(export ?ALL)
)

(defrule pregunta-nombre "Preguntar el nombre al cliente"
	(not (Cliente))
	=>
	(assert (Cliente (nombre (pregunta-general "¿Cuál es su nombre?"))))
	(assert (Preferencias))
)

(defrule pregunta-tipo "Preguntar el tipo de comida preferida"
	?prefs <- (Preferencias (tipos desconocido))
	=>
	(bind ?tipos (create$ Tradicional Moderno))
	(bind ?respuesta (pregunta-multi "¿Qué tipo(s) de menú prefiere?" ?tipos))
	(modify ?prefs (tipos ?respuesta))
	(focus asociacion)
)
