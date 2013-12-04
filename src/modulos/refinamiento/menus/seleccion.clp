(defmodule menus-seleccion
    (import MAIN ?ALL)
    (export ?ALL)
)

(defrule ir-a-presentar "Presentar los resultados"
  (declare (salience -10000))
  =>
  (focus presentacion)
)
