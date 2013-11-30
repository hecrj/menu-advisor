(defmodule seleccion
	(import MAIN ?ALL)
	(export ?ALL)
)

(defrule ir-a-presentar "Empieza a presentar resultados"
  (declare (salience -10000))
  (Cliente)
  (Preferencias)
  =>
  (focus presentacion)
)
