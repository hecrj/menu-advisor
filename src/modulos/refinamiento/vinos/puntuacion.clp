(defmodule vinos-puntuacion
    (import MAIN ?ALL)
    (export ?ALL)
)

(deftemplate Pesos
    (slot vino-muy-caro
        (type INTEGER)
        (default 100))
    (slot vino-muy-barato
        (type INTEGER)
        (default 50))
    (slot caro-si
        (type FLOAT)
        (default 4.0)) ; 4 platos cuestan menos que el vino => vino caro
    (slot barato-si
        (type FLOAT)
        (default 0.3)) ; 0.3 platos cuestan más que el vino => vino barato
)

(defrule inicializa-Pesos "Define la ponderación de factores"
    (declare (salience 10000))
    (not (Pesos))
    =>
    (estado "Catando vinos...")
    (assert (Pesos))
)

(defrule penalizar-vinos-fuera-de-precio "Penaliza los vinos que tienen un precio poco acorde con el plato"
    (Pesos (vino-muy-caro ?caro) (vino-muy-barato ?barato) (caro-si ?caro-si) (barato-si ?barato-si))
    (Preferencias (vino ?nv))
    (test (> ?nv 0))
    =>
    (progn$ (?menu (find-all-instances ((?m Menu)) TRUE))
        (bind $?vinos (send ?menu get-vinos))
        (bind ?punt (send ?menu get-puntuacion))
        (bind $?just (send ?menu get-justificaciones))
        (bind ?precio-plato-1 (send (plato (send ?menu get-primero)) get-precio))
        (bind ?precio-vino-1 (send (nth 1 $?vinos) get-precio))
        (if (> ?precio-vino-1 (* ?caro-si ?precio-plato-1))
            then (send ?menu put-puntuacion (- ?punt ?caro))
                 (send ?menu put-justificaciones
                     (add$ (str-cat "El vino es demasiado caro para el primer plato -> -" ?caro) $?just))
            else (if (< ?precio-vino-1 (* ?barato-si ?precio-plato-1))
                     then (send ?menu put-puntuacion (- ?punt ?barato))
                          (send ?menu put-justificaciones
                              (add$ (str-cat "El vino es demasiado barato para el primer plato -> -" ?barato) $?just))))

        (bind ?punt (send ?menu get-puntuacion))
        (bind $?just (send ?menu get-justificaciones))
        (bind ?precio-plato-2 (send (plato (send ?menu get-segundo)) get-precio))
        (bind ?precio-vino-2 (send (nth (length $?vinos) $?vinos) get-precio))
        (if (> ?precio-vino-2 (* ?caro-si ?precio-plato-2))
            then (send ?menu put-puntuacion (- ?punt ?caro))
                 (send ?menu put-justificaciones
                     (add$ (str-cat "El vino es demasiado caro para el segundo plato -> -" ?caro) $?just))
            else (if (< ?precio-vino-2 (* ?barato-si ?precio-plato-2))
                     then (send ?menu put-puntuacion (- ?punt ?barato))
                          (send ?menu put-justificaciones
                              (add$ (str-cat "El vino es demasiado barato para el segundo plato -> -" ?barato) $?just)))))
)

(defrule ir-a-seleccionar "Empieza a seleccionar vinos"
    (declare (salience -10000))
    =>
    (focus vinos-seleccion)
)
