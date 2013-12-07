(defmodule menus-seleccion
    (import MAIN ?ALL)
    (export ?ALL)
)

;creo un unordered fact de tipo FranjasPrecio y si el usuario ha
;indicado restricciones de precio maximo/minimo, reescalo las franjas por defecto
(defrule inicializar-franjas
    (declare (salience 10000))
    (not (franjas-inicializadas))
    =>
    (assert (FranjasPrecio))
    (assert (franjas-inicializadas))
)

(defrule actualizar-franja-min
    (declare (salience 9000))
    (not (franja-min-actualizada))
    (Preferencias (precio-minimo ?pmin))
    (test (not (eq ?pmin -1)))
    ?franjas <- (FranjasPrecio)
    =>
    (modify ?franjas (minimo ?pmin))
    (assert (franja-min-actualizada))
)

(defrule actualizar-franja-max
    (declare (salience 8000))
    (not (franja-max-actualizada))
    (Preferencias (precio-maximo ?max))
    (test (not (eq ?max -1)))
    ?franjas <- (FranjasPrecio)
    =>
    (modify ?franjas (caro ?max))
    (assert (actualizar-franjas-intermedias))
    (assert (franja-max-actualizada))
)

(defrule actualizar-franjas-intermedias
    (declare (salience 7000))
    (not (franjas-medias-actualizadas))
    ?franjas <- (FranjasPrecio (minimo ?min) (barato ?bar) (medio ?med) (caro ?car))
    (actualizar-franjas-intermedias)
    =>
    (bind ?dif (- ?car ?min))
    (modify ?franjas (barato (+ ?min (/ ?dif 3.0))) (medio (+ ?min (/ ?dif 1.5))))
    (assert (franjas-medias-actualizadas))
)

(defrule inicializar-seleccion-menus
    (declare (salience 1000))
    (not (menus-seleccionados ?))
    =>
    (make-instance (gensym) of SeleccionMenus)
    (assert (menus-seleccionados FALSE))
)

(defrule seleccionar-menus
    (declare (salience 100))
    ?franjas <- (FranjasPrecio (minimo ?min) (barato ?bar) (medio ?med) (caro ?car))
    ?sel <- (object (is-a SeleccionMenus))
    (not (menus-seleccionados TRUE))
    =>
    (progn$ (?menu (find-all-instances ((?m Menu)) TRUE))
        (bind ?precio (send ?menu get-precio))
        (bind ?puntuacion (send ?menu get-puntuacion))
        ;(printout t ?sel ", Menú: " ?menu ", precio: " ?precio ", punt: " ?puntuacion crlf)
        (bind $?ml (create$ ?menu))
        (if (and (>= ?precio ?min) (<= ?precio ?bar))
            then (bind $?b (send ?sel get-baratos))
                 (if (= 0 (length $?b))
                     then (send ?sel put-baratos $?ml)
                     else (bind ?puntuacion-vieja (send (nth 1 $?b) get-puntuacion))
                          (if (> ?puntuacion ?puntuacion-vieja)
                              then (send ?sel put-baratos $?ml)
                              else (if (= ?puntuacion ?puntuacion-vieja)
                                       then (send ?sel put-baratos (seleccionar-uno $?ml $?b))))))
        (if (and (> ?precio ?bar) (<= ?precio ?med))
            then (bind $?m (send ?sel get-medios))
                 (if (= 0 (length $?m))
                     then (send ?sel put-medios $?ml)
                     else (bind ?puntuacion-vieja (send (nth 1 $?m) get-puntuacion))
                          (if (> ?puntuacion ?puntuacion-vieja)
                              then (send ?sel put-medios $?ml)
                              else (if (= ?puntuacion ?puntuacion-vieja)
                                       then (send ?sel put-medios (seleccionar-uno $?ml $?m))))))
        (if (and (> ?precio ?med) (<= ?precio ?car))
            then (bind $?c (send ?sel get-caros))
                 (if (= 0 (length $?c))
                     then (send ?sel put-caros $?ml)
                     else (bind ?puntuacion-vieja (send (nth 1 $?c) get-puntuacion))
                          (if (> ?puntuacion ?puntuacion-vieja)
                              then (send ?sel put-caros $?ml)
                              else (if (= ?puntuacion ?puntuacion-vieja)
                                       then (send ?sel put-caros (seleccionar-uno $?ml $?c)))))))
    (assert (menus-seleccionados TRUE))
)


(defrule ir-a-presentar "Presentar los resultados"
  (declare (salience -10000))
  =>
  (focus presentacion)
)
