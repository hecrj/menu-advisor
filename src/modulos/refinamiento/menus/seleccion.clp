(defmodule menus-seleccion
    (import MAIN ?ALL)
    (export ?ALL)
)

(defrule crear-menus
  (declare (salience 2000))
  (not (menus-creados))
  =>
  (estado "Seleccionando menús...")
  (bind $?abstractos (find-all-instances ((?inst MenuAbstracto)) TRUE))
  (bind $?abstractos (sort puntuacion-descendente $?abstractos))
  (bind ?i 0)
  (progn$ (?abstracto $?abstractos)
    (if (> ?i 100) ; Seleccionar los 100 mejores menús abstractos
      then (send ?abstracto delete))
    (bind ?i (+ ?i 1))
  )
  (assert (menus-creados))
)


(defrule ir-a-filtrar-vinos "Ir a filtrar vinos"
  (declare (salience -10000))
  =>
  (focus vinos-filtracion)
)
