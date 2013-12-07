(defmodule vinos-filtracion
    (import MAIN ?ALL)
    (export ?ALL)
)

(defrule crear-menus-con-vinos
    (declare (salience 10000))
    (not (menus-con-vinos))
    =>
    (estado "Refinando menús...")
    (bind $?abstractos (find-all-instances ((?inst MenuAbstracto)) TRUE))
    (bind $?vinos (find-all-instances ((?inst Vino)) TRUE))
    (progn$ (?abstracto $?abstractos)
        (bind ?primero (send ?abstracto get-primero))
        (bind ?segundo (send ?abstracto get-segundo))
        (bind ?postre (send ?abstracto get-postre))
        (bind ?puntuacion (send ?abstracto get-puntuacion))
        (bind $?just (send ?abstracto get-justificaciones))

        (bind $?color-vinos-menu (send ?abstracto get-color-vinos))
        (bind ?cantidad-vinos (length $?color-vinos-menu))

        (bind ?precio
            (+
                (+
                    (send (plato ?primero) get-precio)
                    (send (plato ?segundo) get-precio)
                )
                (send (plato ?postre) get-precio)
            )
        )

        (switch ?cantidad-vinos
          (case 0 then
            (make-instance (gensym) of Menu (primero ?primero) (segundo ?segundo)
              (postre ?postre) (vinos (create$)) (precio ?precio) (puntuacion ?puntuacion) (justificaciones $?just)))
          (case 1 then
            (progn$ (?vino $?vinos)
              (if (member$ (color-vino ?vino) $?color-vinos-menu)
                then
                  (bind ?precio1 (+ ?precio (/ (send ?vino get-precio) 4.0)))
                  (make-instance (gensym) of Menu (primero ?primero) (segundo ?segundo)
                    (postre ?postre) (vinos (create$ ?vino)) (precio ?precio1) (puntuacion ?puntuacion) (justificaciones $?just)))))
          (case 2 then
            (progn$ (?vino1 $?vinos)
              (if (eq (color-vino ?vino1) (nth 1 $?color-vinos-menu))
                then
                  (bind ?precio1 (+ ?precio (/ (send ?vino1 get-precio) 4.0)))
                  (progn$ (?vino2 $?vinos)
                    (if (and (eq (color-vino ?vino2) (nth 2 $?color-vinos-menu)) (neq ?vino1 ?vino2))
                      then
                        (bind ?precio2 (+ ?precio1 (/ (send ?vino2 get-precio) 4.0)))
                        (make-instance (gensym) of Menu (primero ?primero) (segundo ?segundo)
                          (postre ?postre) (vinos (create$ ?vino1 ?vino2)) (precio ?precio2) (puntuacion ?puntuacion) (justificaciones $?just))))))
        )
      )
      (send ?abstracto delete)
    )
    (assert (menus-con-vinos))
)

(defrule ir-a-puntuar "Empieza a puntuar vinos"
  (declare (salience -10000))
  =>
  (focus vinos-puntuacion)
)
