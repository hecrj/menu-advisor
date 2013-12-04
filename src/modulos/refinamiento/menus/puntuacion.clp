(defmodule menus-puntuacion
    (import MAIN ?ALL)
    (export ?ALL)
)

(defrule ir-a-seleccionar "Empieza a seleccionar menús"
  (declare (salience -10000))
  =>
  (focus menus-seleccion)
)
