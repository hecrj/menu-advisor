(defmodule platos-filtracion
    (import MAIN ?ALL)
    (export ?ALL)
)

(defrule crear-recomendaciones-iniciales "Crea las recomendaciones iniciales"
    (declare (salience 10000))
    (not (recomendaciones-creadas))
    =>
    (estado "Generando recomendaciones...")
    (bind $?platos (find-all-instances ((?inst Plato)) TRUE))
    (progn$ (?plato $?platos)
        (make-instance (gensym) of Recomendacion (plato ?plato))
    )
    (assert (recomendaciones-creadas))
)

(defrule ingredientes-prohibidos "Elimina las recomendaciones de platos con ingredientes prohibidos"
    (declare (salience 9900))
    (Preferencias (ingredientes-prohibidos $?prohibidos))
    ?rec <- (object (is-a Recomendacion) (plato ?plato))
    =>
    (bind $?ingredientes (send ?plato get-ingredientes))
    (progn$ (?ingrediente $?ingredientes)
        (if (member$ (send (instance-address * ?ingrediente) get-nombre) $?prohibidos) then
            (send ?rec delete)
            (break)
        )
    )
)

(defrule platos-exclusivos-evento "Elimina los platos exclusivos de otros eventos"
    (declare (salience 9850))
    (Preferencias (evento ?evento))
    ?rec <- (object (is-a Recomendacion) (plato ?plato))
    (test (> (length (send ?plato get-exclusivo_de)) 0))
    =>
    (bind $?eventos (find-attr-ont nombre (send ?plato get-exclusivo_de)))
    (if (not (member$ ?evento $?eventos))
        then (send ?rec delete))
)

(defrule platos-demasiado-caros "Elimina las recomendaciones de platos que exceden el precio"
    (declare (salience 9800))
    (Preferencias (precio-maximo ?max))
    (test (> ?max -1))
    ?rec <- (object (is-a Recomendacion) (plato ?plato))
    (test (> (send ?plato get-precio) ?max))
    =>
    (send ?rec delete)
)

(defrule platos-sibaritas "Elimina las recomendaciones de platos exclusivos si no se quieren"
    (Preferencias (sibarita FALSE))
    ?rec <- (object (is-a Recomendacion) (plato ?plato))
    (test (send ?plato get-para_sibaritas))
    =>
    (send ?rec delete)
)

(defrule ir-a-puntuar "Empieza a puntuar platos"
  (declare (salience -10000))
  =>
  (focus platos-puntuacion)
)
