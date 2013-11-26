(defmodule asociacion
	(import MAIN ?ALL)
	(export ?ALL)
)

(defrule crear-solucion-abstracta "Crea la solución abstracta"
	(not (MenuAbstracto))
	=>
	(assert (MenuAbstracto))
)

(defrule abstraer-tipo "Abstrae el tipo de menú"
	?menu <- (MenuAbstracto (tipos desconocido))
	(Preferencias (tipos $?tipos))
	=>
	(modify ?menu (tipos $?tipos))
	(focus filtracion)
)
