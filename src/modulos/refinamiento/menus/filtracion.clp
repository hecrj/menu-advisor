(defmodule menus-filtracion
    (import MAIN ?ALL)
    (export ?ALL)
)

(defrule ir-a-puntuar "Empieza a puntuar menús"
  (declare (salience -10000))
  =>
  (focus menus-puntuacion)
)