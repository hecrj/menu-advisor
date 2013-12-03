(defmodule abstraccion
  (import MAIN ?ALL)
  (export ?ALL)
)

;(defrule pregunta-nombre "Preguntar el nombre al cliente"
;  (not (Cliente))
;  =>
;  (assert (Cliente (nombre (pregunta-general "¿Cuál es su nombre?"))))
;)

(defrule pregunta-evento "Preguntar el tipo de evento al cliente"
  (declare (salience 10000))
  =>
  (bind ?evento (pregunta-indice "¿Qué tipo de evento va a realizar?" (deftemplate-slot-allowed-values MAIN::Preferencias evento)))
  (assert (Preferencias (evento ?evento)))
)

(defrule pregunta-tipos-menu "Preguntar los tipos de cocina preferidas para el menú"
  (declare (salience 9900))
  ?prefs <- (Preferencias (tipos-menu desconocido))
  =>
  (bind $?respuesta (pregunta-multi "¿Qué tipo(s) de menú prefiere?" (class-subclasses Plato)))
  (modify ?prefs (tipos-menu $?respuesta))
)

(defrule pregunta-tipos-comensal "Preguntar los tipos de cliente del menú"
  (declare (salience 9800))
  ?prefs <- (Preferencias (ingredientes-prohibidos "desconocido"))
  =>
  (bind $?respuesta (seleccionar-instancias TipoComensal nombre "¿Qué tipo(s) de comensales tendrá el menú?"))
  
  (bind $?ingredientes-prohibidos (create$))
  (progn$ (?tipo $?respuesta)
    (bind $?conflictos (send ?tipo get-conflictos))
    (progn$ (?conflicto $?conflictos)
      (bind $?ingredientes-prohibidos (add$ (send (instance-address * ?conflicto) get-nombre) $?ingredientes-prohibidos))
    )
  )
  (modify ?prefs (ingredientes-prohibidos $?ingredientes-prohibidos))
)

(defrule pregunta-temperatura "Preguntar la temperatura de comida preferida"
  (declare (salience 9700))
  ?prefs <- (Preferencias (temperatura desconocido))
  =>
  (bind ?respuesta (pregunta-indice "¿Prefiere comida caliente o fría?" (slot-allowed-values MAIN::Plato temperatura)))
  (modify ?prefs (temperatura ?respuesta))
)

(defrule pregunta-estacion "Preguntar la estacion del año"
  (declare (salience 9600))
  =>
  (bind ?est (pregunta-indice "¿Cuál es la estación del año actual?" (deftemplate-slot-allowed-values MAIN::Contexto estacion)))
  ; TODO Añadir ingredientes prohibidos!
  (assert (Contexto (estacion ?est)))
)

(defrule ir-a-filtrar "Empieza a filtrar resultados"
  (declare (salience -10000))
  (Preferencias)
  =>
  (focus filtracion)
)
