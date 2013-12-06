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
    =>
    (assert (SeleccionMenus))
)

(defrule seleccionar-menus
    (declare (salience 100))
    ?franjas <- (FranjasPrecio (minimo ?min) (barato ?bar) (medio ?med) (caro ?car))
    ?sel <- (SeleccionMenus (baratos $?b) (medios $?m) (caros $?c))
    ?menu <- (object (is-a Menu) (puntuacion ?puntuacion) (precio ?precio))
    (not (menu-seleccionado ?menu))
    =>
    (bind $?ml (create$ ?menu))
    (if (and (>= ?precio ?min) (<= ?precio ?bar))
        then (if (= 0 (length $?b))
                 then (modify ?sel (baratos $?ml))
                 else (bind ?puntuacion-vieja (send (nth 1 $?b) get-puntuacion))
                      (if (> ?puntuacion ?puntuacion-vieja)
                          then (modify ?sel (baratos $?ml))
                          else (if (= ?puntuacion ?puntuacion-vieja)
                                   then (modify ?sel (baratos (seleccionar-uno $?ml $?b)))))))
    (if (and (> ?precio ?bar) (<= ?precio ?med))
        then (if (= 0 (length $?m))
                 then (modify ?sel (medios $?ml))
                 else (bind ?puntuacion-vieja (send (nth 1 $?m) get-puntuacion))
                      (if (> ?puntuacion ?puntuacion-vieja)
                          then (modify ?sel (medios $?ml))
                          else (if (= ?puntuacion ?puntuacion-vieja)
                                   then (modify ?sel (medios (seleccionar-uno $?ml $?m)))))))
    (if (and (> ?precio ?med) (<= ?precio ?car))
        then (if (= 0 (length $?c))
                 then (modify ?sel (caros $?ml))
                 else (bind ?puntuacion-vieja (send (nth 1 $?c) get-puntuacion))
                      (if (> ?puntuacion ?puntuacion-vieja)
                          then (modify ?sel (caros $?ml))
                          else (if (= ?puntuacion ?puntuacion-vieja)
                                   then (modify ?sel (caros (seleccionar-uno $?ml $?c)))))))

    (assert (menu-seleccionado ?menu))
)


(defrule ir-a-presentar "Presentar los resultados"
  (declare (salience -10000))
  =>
  (focus presentacion)
)
