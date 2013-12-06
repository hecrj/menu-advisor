(defmodule menus-filtracion
    (import MAIN ?ALL)
    (export ?ALL)
)

(defrule filtrar-vinos "Filtra los vinos que no son del tipo preferido por el cliente"
    (declare (salience 10000))
    (Preferencias (colores-vino $?colores-vino))
    ?vino <- (object (is-a Vino) (color ?color))
    (test (not (member$ (send (instance-address * ?color) get-nombre) $?colores-vino)))
    =>
    (send ?vino delete)
)

(defrule generar-menus "Genera todos los menús posibles en función de las recomendaciones disponibles"
    (declare (salience 9900))
    (Recomendaciones (primeros $?primeros) (segundos $?segundos) (postres $?postres))
    (Preferencias (vino ?cantidad-vino))
    =>
    (bind $?todos-vinos (find-all-instances ((?inst Vino)) TRUE))
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
                        
                        (switch ?cantidad-vino
                            (case 0 then
                                (make-instance (gensym) of Menu (primero ?primero) (segundo ?segundo)
                                    (postre ?postre) (precio ?precio) (vinos (create$))))
                            (case 1 then
                                (progn$ (?vino $?todos-vinos)
                                    (make-instance (gensym) of Menu (primero ?primero) (segundo ?segundo)
                                        (postre ?postre) (precio ?precio) (vinos (create$ ?vino)))))
                            (case 2 then
                                (progn$ (?vino1 $?todos-vinos)
                                    (progn$ (?vino2 $?todos-vinos)
                                        (if (neq ?vino1 ?vino2) then
                                            (make-instance (gensym) of Menu (primero ?primero) (segundo ?segundo)
                                                (postre ?postre) (precio ?precio) (vinos (create$ ?vino1 ?vino2)))))))
                        )
                    )
                )
            )
        )
    )
)

(defrule ir-a-puntuar "Empieza a puntuar menús"
    (declare (salience -10000))
    =>
    (printout t "A puntuar" crlf)
    (focus menus-puntuacion)
)
