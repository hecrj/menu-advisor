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
    (bind ?evento-inst (seleccionar-instancia Evento nombre "¿Qué tipo de evento va a realizar?"))
    (bind ?evento (send ?evento-inst get-nombre))
    (assert (Preferencias (evento ?evento)))
)

(defrule pregunta-num-comensales "Preguntar el número de comensales al cliente"
    (declare (salience 9950))
    ?prefs <- (Preferencias (comensales 0))
    =>
    (bind ?comensales (pregunta-numerica-positiva "¿Cuántos comensales van a ser?"))
    (modify ?prefs (comensales ?comensales) (dificultad (max 0 (- 100 ?comensales))))
)

(defrule pregunta-tipos-menu "Preguntar los tipos de cocina preferidas para el menú"
    (declare (salience 9900))
    ?prefs <- (Preferencias (tipos-menu desconocido))
    =>
    (bind $?respuesta (pregunta-multi "¿Qué tipo(s) de menú prefiere?" (class-subclasses Plato)))
    (modify ?prefs (tipos-menu $?respuesta))
)

(defrule pregunta-sibarita "Pregunta al cliente si es un sibarita"
    (declare (salience 9875))
    ?prefs <- (Preferencias (sibarita desconocido))
    =>
    (bind ?respuesta (pregunta-si-no "¿Es sibarita y prefiere platos para los paladares más exigentes?"))
    (modify ?prefs (sibarita ?respuesta))
)

(defrule pregunta-regional "Preguntar si el cliente prefiere platos regionales"
    (declare (salience 9850))
    ?prefs <- (Preferencias (regiones "desconocido"))
    =>
    (if (not (pregunta-si-no "¿Prefiere comida de alguna zona geográfica concreta?")) then (modify ?prefs (regiones)))
)

(defrule pregunta-regiones "Preguntar las regiones preferidas"
    (declare (salience 9849))
    ?prefs <- (Preferencias (regiones "desconocido"))
    =>
    (bind $?respuesta (seleccionar-instancias Region nombre "¿De qué zonas geográficas prefiere que sea la comida?"))
    (bind $?regiones (create$))
    (progn$ (?region $?respuesta)
        (bind $?regiones (add$ (send ?region get-nombre) $?regiones)))
    (modify ?prefs (regiones $?regiones))
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
            (bind $?ingredientes-prohibidos (add$ (send (instance-address * ?conflicto) get-nombre) $?ingredientes-prohibidos))))
    (modify ?prefs (ingredientes-prohibidos $?ingredientes-prohibidos))
)

(defrule pregunta-temperatura "Preguntar la temperatura de comida preferida"
    (declare (salience 9700))
    ?prefs <- (Preferencias (temperatura desconocido))
    =>
    (if (not (pregunta-si-no "¿Tiene alguna preferencia para la temperatura de la comida?"))
        then (modify ?prefs (temperatura sin-preferencia))
        else
        (bind ?respuesta (pregunta-indice "¿Prefiere comida caliente o fría?" (slot-allowed-values MAIN::Plato temperatura)))
        (modify ?prefs (temperatura ?respuesta)))
)

(defrule pregunta-estacion "Preguntar la estacion del año"
    (declare (salience 9600))
    (not (estacion preguntada))
    ?prefs <- (Preferencias (ingredientes-prohibidos $?prohibidos))
    =>
    (bind ?est (seleccionar-instancia Epoca nombre "¿En qué época desea consumir el menú?"))
    (bind $?disponibles (send ?est get-dispone-de))
    (bind $?epocas (find-all-instances ((?inst Epoca)) TRUE))
    (progn$ (?epoca $?epocas)
        (if (neq ?epoca ?est) then
            (bind $?dispone (send ?epoca get-dispone-de))
            (progn$ (?ingrediente $?dispone)
                (if (not (member$ ?ingrediente $?disponibles)) then
                    (bind $?prohibidos (add$ (send (instance-address * ?ingrediente) get-nombre) $?prohibidos))
                    )
                )
            )
        )
    (assert (Contexto (estacion (send ?est get-nombre))))
    (modify ?prefs (ingredientes-prohibidos $?prohibidos))
    (assert (estacion preguntada))
)

(defrule pregunta-ingredientes-prohibidos "Preguntar si se quieren prohibir ingredientes"
    (declare (salience 9550))
    (not (ingredientes prohibidos preguntado))
    ?prefs <- (Preferencias (ingredientes-prohibidos $?prohibidos))
    =>
    (if (pregunta-si-no "¿Quiere evitar algún ingrediente en la elaboración de los platos? (la lista de ingredientes disponibles puede ser extensa)") then
        (bind $?nombres-ingredientes (find-attr nombre (find-all-instances ((?i Ingrediente)) (not (member$ ?i:nombre $?prohibidos)))))
        (progn$ (?prohibido (pregunta-multi "¿Qué ingredientes quiere evitar en la elaboración?" $?nombres-ingredientes))
            (add$ ?prohibido $?nombres-ingredientes))
        (modify ?prefs (ingredientes-prohibidos $?prohibidos)))
    (assert (ingredientes prohibidos preguntado))
)

(defrule pregunta-precio "Preguntar si el cliente tiene preferencias de precio"
    (declare (salience 9500))
    (not (precio preguntado))
    =>
    (assert (precio preguntado))
    (if (pregunta-si-no "¿Quiere indicar limitaciones de precio?") then (assert (pedir precio)))
)

(defrule pregunta-precio-maximo "Preguntar el precio máximo"
    (declare (salience 9400))
    (pedir precio)
    (not (precio maximo pedido))
    ?prefs <- (Preferencias (precio-maximo -1))
    =>
    (bind ?precio-max (pregunta-numerica-positiva "¿Cuál es el precio máximo?"))
    (modify ?prefs (precio-maximo ?precio-max))
    (assert (precio maximo pedido))
)

(defrule pregunta-precio-minimo "Preguntar el precio mínimo"
    (declare (salience 9300))
    (pedir precio)
    (not (precio minimo pedido))
    ?prefs <- (Preferencias (precio-minimo -1))
    =>
    (bind ?precio-min (pregunta-numerica-positiva "¿Cuál es el precio mínimo?"))
    (modify ?prefs (precio-minimo ?precio-min))
    (assert (precio minimo pedido))
)

(defrule preferencia-bebida "Preguntar que prefiere para la bebida"
    (declare (salience 9200))
    (not (bebida preguntado))
    ?prefs <- (Preferencias (vino -1))
    =>
    (bind ?opciones (create$ "Vino (sólo uno)" "Vino (uno distinto para cada plato)" "Otra cosa"))
    (bind ?respuesta (pregunta-indice "¿Qué prefiere para la bebida?" ?opciones))
    (if (eq ?respuesta "Vino (sólo uno)") then
        (modify ?prefs (vino 1))
        (assert (preguntar vino))
        )
    (if (eq ?respuesta "Vino (uno distinto para cada plato)") then 
        (modify ?prefs (vino 2))
        (assert (preguntar vino))
        )
    (if (eq ?respuesta "Otra cosa") then (modify ?prefs (vino 0)))
    (assert (bebida preguntado))
)

(defrule preferencia-vino "Preguntar el tipo de vino preferido"
    (declare (salience 9100))
    (preguntar vino)
    (not (vino preguntado))
    ?prefs <- (Preferencias)
    =>
    (bind $?colores (find-all-instances ((?inst ColorVino)) TRUE))
    (bind $?nombres-colores (find-attr nombre $?colores))
    (bind $?respuesta (pregunta-multi "¿Qué tipo de vino prefiere?" $?nombres-colores))
    (if (> (length $?respuesta) 0)
        then (modify ?prefs (colores-vino $?respuesta))
        else (modify ?prefs (colores-vino $?nombres-colores)))
    (assert (vino preguntado))
)
 
(defrule ir-a-filtrar "Empieza a filtrar platos"
    (declare (salience -10000))
    (Preferencias)
    =>
    (focus platos-filtracion)
)
