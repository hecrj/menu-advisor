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
    (assert (SeleccionMenus))
    (assert (menus-seleccionados FALSE))
)

(defrule seleccionar-menus
    (declare (salience 100))
    ?franjas <- (FranjasPrecio (minimo ?min) (barato ?bar) (medio ?med) (caro ?car))
    ?sel <- (SeleccionMenus (baratos $?b) (medios $?m) (caros $?c))
    (not (menus-seleccionados TRUE))
    =>
    (progn$ (?menu (find-all-instances ((?m Menu)) TRUE))
        (bind ?precio (send ?menu get-precio))
        (bind ?puntuacion (send ?menu get-puntuacion))
        ;(printout t ?sel ", Menú: " ?menu ", precio: " ?precio ", punt: " ?puntuacion crlf)
        (bind $?ml (create$ ?menu))
        (if (and (>= ?precio ?min) (<= ?precio ?bar))
            then (if (= 0 (length $?b))
                     then (bind $?b $?ml)
                     else (bind ?puntuacion-vieja (send (nth 1 $?b) get-puntuacion))
                          (if (> ?puntuacion ?puntuacion-vieja)
                              then (bind $?b $?ml)
                              else (if (= ?puntuacion ?puntuacion-vieja)
                                       then (bind $?b (seleccionar-uno $?ml $?b))))))
        (if (and (> ?precio ?bar) (<= ?precio ?med))
            then (if (= 0 (length $?m))
                     then (bind $?m $?ml)
                     else (bind ?puntuacion-vieja (send (nth 1 $?m) get-puntuacion))
                          (if (> ?puntuacion ?puntuacion-vieja)
                              then (bind $?m $?ml)
                              else (if (= ?puntuacion ?puntuacion-vieja)
                                       then (bind $?m (seleccionar-uno $?ml $?m))))))
        (if (and (> ?precio ?med) (<= ?precio ?car))
            then (if (= 0 (length $?c))
                     then (bind $?c $?ml)
                     else (bind ?puntuacion-vieja (send (nth 1 $?c) get-puntuacion))
                          (if (> ?puntuacion ?puntuacion-vieja)
                              then (bind $?c $?ml)
                              else (if (= ?puntuacion ?puntuacion-vieja)
                                       then (bind $?c (seleccionar-uno $?ml $?c)))))))
    
    (modify ?sel (baratos $?b) (medios $?m) (caros $?c))
    (assert (menus-seleccionados TRUE))
)


(defrule ir-a-presentar "Presentar los resultados"
  (declare (salience -10000))
  =>
  (estado "Mostrando resultados...")
  (focus presentacion)
)
