(defmodule platos-puntuacion
    (import MAIN ?ALL)
    (export ?ALL)
)

(deftemplate Pesos
    (slot tipo-preferido (type INTEGER) (default 100))
    (slot temperatura-preferida (type INTEGER) (default 75))
    (slot caliente-en-verano (type INTEGER) (default -25))
    (slot caliente-en-invierno (type INTEGER) (default 40))
    (slot region-preferida (type INTEGER) (default 50))
    (slot plato-exclusivo (type INTEGER) (default 60))
)

(defrule inicializa-Pesos "Define la ponderación de factores"
    (declare (salience 10000))
    =>
    (assert (Pesos))
)

(defrule puntuar-tipos "Puntúa una recomendación en función del tipo de plato"
    (Preferencias (tipos-menu $?tipos_menu))
    (test (> (length $?tipos_menu) 0))
    (Pesos (tipo-preferido ?peso))
    ?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
    (not (tipo-puntuado ?rec))
    =>
    (bind ?tipo_plato (class ?plato))
    (if (member$ ?tipo_plato $?tipos_menu) then
        (send ?rec put-puntuacion
            (+ ?punt ?peso))
        (send ?rec put-justificaciones
            (add$ (str-cat "El plato es de tipo " (lowcase ?tipo_plato) ", preferido por el cliente -> +" ?peso) $?just))
    else (if (neq ?tipo_plato Generico) then
        (send ?rec put-puntuacion
            (- ?punt ?peso))
        (send ?rec put-justificaciones
            (add$ (str-cat "El plato no es de un tipo genérico/preferido por el cliente: " (lowcase ?tipo_plato) " -> -" ?peso) $?just))
        )
    )
    (assert (tipo-puntuado ?rec))
)

(defrule puntuar-temperatura "Puntúa los platos en función de la temperatura preferida"
    (Preferencias (temperatura ?temperatura_preferida))
    (test (neq ?temperatura_preferida sin-preferencia))
    (Pesos (temperatura-preferida ?peso))
    ?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
    (not (temperatura-puntuada ?rec))
    =>
    (bind ?temperatura_plato (send ?plato get-temperatura))
    (if (eq ?temperatura_preferida ?temperatura_plato) then
        (send ?rec put-puntuacion
            (+ ?punt ?peso))
        (send ?rec put-justificaciones
            (add$ (str-cat "El plato se sirve " (lowcase ?temperatura_plato) ", preferido por el cliente -> +" ?peso) $?just))
    else 
        (send ?rec put-puntuacion
            (- ?punt ?peso))
        (send ?rec put-justificaciones
            (add$ (str-cat "El plato se sirve " (lowcase ?temperatura_plato) ", no preferido por el cliente -> -" ?peso) $?just))
    )
    (assert (temperatura-puntuada ?rec))
)

(defrule puntuar-verano "Puntúa los platos calientes negativamente en verano"
    (Contexto (estacion "Verano"))
    (Pesos (caliente-en-verano ?peso))
    ?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
    (test (eq (send ?plato get-temperatura) CALIENTE))
    (not (caliente-puntuado ?rec))
    =>
    (send ?rec put-puntuacion (+ ?punt ?peso))
    (send ?rec put-justificaciones
        (add$ (str-cat "Los platos calientes no suelen apetecer en verano -> " ?peso) $?just))
    (assert (caliente-puntuado ?rec))
)

(defrule puntuar-invierno "Puntúa los platos calientes positivamente en invierno"
    (Contexto (estacion "Invierno"))
    (Pesos (caliente-en-invierno ?peso))
    ?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
    (test (eq (send ?plato get-temperatura) CALIENTE))
    (not (caliente-puntuado ?rec))
    =>
    (send ?rec put-puntuacion (+ ?punt ?peso))
    (send ?rec put-justificaciones
        (add$ (str-cat "Los platos calientes suelen apetecer en invierno -> +" ?peso) $?just))
    (assert (caliente-puntuado ?rec))
)

(defrule puntuar-regiones "Puntúa los platos de las regiones escogidas"
    (Preferencias (regiones $?regiones))
    (Pesos (region-preferida ?peso))
    ?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
    (not (regiones-puntuadas ?rec))
    =>
    (bind $?regiones-plato (send ?plato get-tipico_de))
    (progn$ (?region $?regiones-plato)
            (bind ?nombre-region (send (instance-address * ?region) get-nombre))
            (if (member$ ?nombre-region $?regiones)
                then (send ?rec put-puntuacion (+ ?punt ?peso))
                     (send ?rec put-justificaciones
                           (add$ (str-cat "El plato es de " ?nombre-region ", preferido por el cliente -> +" ?peso) $?just))))
    (assert (regiones-puntuadas ?rec))
)

(defrule puntuar-eventos "Mejora la puntuación los platos propios del evento"
    (Preferencias (evento ?evento))
    ?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
    ?ev <- (object (is-a Evento) (nombre ?evento) (importancia_platos ?importancia))
    (not (evento-puntuado ?rec))
    =>
    (bind $?eventos-plato (send ?plato get-eventos))
    (progn$ (?evento-plato $?eventos-plato)
        (if (eq (send (instance-address * ?evento-plato) get-nombre) ?evento)
            then (send ?rec put-puntuacion (+ ?punt ?importancia))
            (send ?rec put-justificaciones
                (add$ (str-cat "El plato es adecuado para el evento " ?evento " -> +" ?importancia) $?just))))
    (assert (evento-puntuado ?rec))
)

(defrule puntuar-dificultad "Reduce la puntuación de los platos demasiado complejos"
    (Preferencias (dificultad ?dificultad) (comensales ?comensales))
    ?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
    (not (dificultad-puntuada ?rec))
    =>
    (bind ?dif (- (send ?plato get-dificultad) ?dificultad))
    (if (> ?dif 0)
        then (send ?rec put-puntuacion (- ?punt ?dif))
             (send ?rec put-justificaciones
                 (add$ (str-cat "El plato supera en " ?dif " la dificultad máxima de "
                           ?dificultad " para un evento de " ?comensales " comensales -> -" ?dif) $?just)))
    (assert (dificultad-puntuada ?rec))
)

(defrule puntuar-sibarita "Cuando el cliente es sibarita y el plato es exclusivo, se sube la puntuación"
    ?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
    (Pesos (plato-exclusivo ?peso))
    (test (send ?plato get-es_exclusivo))
    (not (exclusividad-puntuada ?rec))
    =>
    (send ?rec put-puntuacion (+ ?punt ?peso))
    (send ?rec put-justificaciones
        (add$ (str-cat "El plato es exclusivo, preferido por los clientes más sibaritas -> +" ?peso) $?just))
        
    (assert (exclusividad-puntuada ?rec))
)

(defrule ir-a-seleccionar "Empieza a seleccionar platos"
    (declare (salience -10000))
    (Preferencias)
    =>
    (focus platos-seleccion)
)
