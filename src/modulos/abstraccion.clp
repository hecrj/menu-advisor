(defmodule abstraccion
  (import MAIN ?ALL)
  (export ?ALL)
)

(defrule pregunta-nombre "Preguntar el nombre al cliente"
  (not (Cliente))
  =>
  (assert (Cliente (nombre (pregunta-general "¿Cuál es su nombre?"))))
)

(defrule pregunta-edad "Preguntar la edad al cliente"
  ?cliente <- (Cliente (edad -1))
  =>
  (bind ?edad (pregunta-numerica-positiva "¿Qué edad tiene?"))
  (bind ?alcohol (if (<= ?edad 17)
                     then FALSE
                     else desconocido
                 )
  )
  (modify ?cliente (edad ?edad))
  (assert (Preferencias (alcohol ?alcohol)))
)

(defrule pregunta-tipos-menu "Preguntar los tipos de cocina preferidas para el menú"
  ?prefs <- (Preferencias (tipos-menu desconocido))
  =>
  (bind $?respuesta (pregunta-multi "¿Qué tipo(s) de menú prefiere?" (class-subclasses Plato)))
  (modify ?prefs (tipos-menu $?respuesta))
)

(defrule pregunta-tipos-comensal "Preguntar los tipos de cliente del menú"
  ?prefs <- (Preferencias (tipos-comensal desconocido))
  =>
  (bind $?respuesta (seleccionar-instancias TipoComensal nombre "¿Qué tipo(s) de comensales tendrá el menú?"))
  (modify ?prefs (tipos-comensal $?respuesta))
)

(defrule pregunta-alcohol "Preguntar si el cliente bebe alcohol"
  ?prefs <- (Preferencias (alcohol desconocido))
  =>
  (modify ?prefs (alcohol (pregunta-si-no "¿Bebe alcohol?")))
)



(defrule ir-a-filtrar "Empieza a filtrar resultados"
  (declare (salience -10000))
  (Cliente)
  (Preferencias)
  =>
  (focus filtracion)
)