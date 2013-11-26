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
	?menu <- (MenuAbstracto (tipo desconocido))
	(Preferencias (tipo ?tipo))
	=>
	(modify ?menu (tipo ?tipo))
)
