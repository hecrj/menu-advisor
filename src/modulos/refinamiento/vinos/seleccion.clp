(defmodule vinos-seleccion
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
    ?sel <- (SeleccionMenus (barato ?b) (medio ?m) (caro ?c))
    (not (menus-seleccionados TRUE))
    =>
    (estado "Seleccionando vinos...")
    (progn$ (?menu (find-all-instances ((?m Menu)) TRUE))
        (bind ?precio (send ?menu get-precio))
        (bind ?puntuacion (send ?menu get-puntuacion))
        ;(printout t ?sel ", Menú: " ?menu ", precio: " ?precio ", punt: " ?puntuacion crlf)
        (if (and (>= ?precio ?min) (<= ?precio ?bar))
            then (if (eq [nil] ?b)
                     then (bind ?b ?menu)
                     else (bind ?puntuacion-vieja (send ?b get-puntuacion))
                          (if (> ?puntuacion ?puntuacion-vieja)
                              then (bind ?b ?menu)
                              else (if (= ?puntuacion ?puntuacion-vieja)
                                       then (bind ?b (seleccionar-uno ?menu ?b))))))
        (if (and (> ?precio ?bar) (<= ?precio ?med))
            then (if (eq [nil] ?m)
                     then (bind ?m ?menu)
                     else (bind ?puntuacion-vieja (send ?m get-puntuacion))
                          (if (> ?puntuacion ?puntuacion-vieja)
                              then (bind ?m ?menu)
                              else (if (= ?puntuacion ?puntuacion-vieja)
                                       then (bind $?m (seleccionar-uno ?menu ?m))))))
        (if (and (> ?precio ?med) (<= ?precio ?car))
            then (if (eq [nil] ?c)
                     then (bind ?c ?menu)
                     else (bind ?puntuacion-vieja (send ?c get-puntuacion))
                          (if (> ?puntuacion ?puntuacion-vieja)
                              then (bind $?c ?menu)
                              else (if (= ?puntuacion ?puntuacion-vieja)
                                       then (bind $?c (seleccionar-uno ?menu ?c)))))))
    
    (modify ?sel (barato ?b) (medio ?m) (caro ?c))
    (assert (menus-seleccionados TRUE))
)

(defrule ir-a-filtrar-menus "Presentar resultados"
  (declare (salience -10000))
  =>
  (focus presentacion)
)
