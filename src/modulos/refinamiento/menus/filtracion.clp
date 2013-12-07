(defmodule menus-filtracion
    (import MAIN ?ALL)
    (export ?ALL)
)

(defrule generar-menus "Genera todos los menús posibles en función de las recomendaciones disponibles"
    (declare (salience 9900))
    (Recomendaciones (primeros $?primeros) (segundos $?segundos) (postres $?postres))
    (Preferencias (colores-vino $?colores-vino) (vino ?cantidad-vino))
    ;(FranjasPrecio (caro ?caro))
    (not (menus-generados))
    =>
    (progn$ (?primero $?primeros)
        (progn$ (?segundo $?segundos)
            (if (neq ?primero ?segundo) then
                (progn$ (?postre $?postres)
                    (if (and (neq ?primero ?postre) (neq ?segundo ?postre)) then
                        (switch ?cantidad-vino
                            (case 0 then
                                (make-instance (gensym) of MenuAbstracto (primero ?primero) (segundo ?segundo)
                                    (postre ?postre) (color-vinos (create$))))
                            (case 1 then
                                (progn$ (?color-vino $?colores-vino)
                                    (make-instance (gensym) of MenuAbstracto (primero ?primero) (segundo ?segundo)
                                        (postre ?postre) (color-vinos (create$ ?color-vino)))))
                            (case 2 then
                                (progn$ (?color-vino1 $?colores-vino)
                                    (progn$ (?color-vino2 $?colores-vino)
                                        (make-instance (gensym) of MenuAbstracto (primero ?primero) (segundo ?segundo)
                                            (postre ?postre) (color-vinos (create$ ?color-vino1 ?color-vino2))))))
                        )
                    )
                )
            )
        )
    )
    (assert (menus-generados))
)

(defrule ir-a-puntuar "Empieza a puntuar menús"
    (declare (salience -10000))
    =>
    (estado "Ponderando menús...")
    (focus menus-puntuacion)
)
