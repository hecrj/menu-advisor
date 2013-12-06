(defmodule menus-filtracion
    (import MAIN ?ALL)
    (export ?ALL)
)

(defrule generar-menus "Genera todos los menús posibles en función de las recomendaciones disponibles"
    (declare (salience 10000))
    (Recomendaciones (primeros $?primeros) (segundos $?segundos) (postres $?postres))
    =>
    (progn$ (?primero $?primeros)
        (progn$ (?segundo $?segundos)
            (if (neq ?primero ?segundo) then
                (progn$ (?postre $?postres)
                    (if (and (neq ?primero ?postre) (neq ?segundo ?postre)) then
                        (bind ?precio
                            (+
                                (+
                                    (send (plato ?primero) get-precio)
                                    (send (plato ?segundo) get-precio)
                                )
                                (send (plato ?postre) get-precio)
                            )
                        )
                        (make-instance (gensym) of Menu (primero ?primero) (segundo ?segundo)
                            (postre ?postre) (precio ?precio))
                    )
                )
            )
        )
    )
)

(defrule ir-a-puntuar "Empieza a puntuar menús"
    (declare (salience -10000))
    =>
    (focus menus-puntuacion)
)
