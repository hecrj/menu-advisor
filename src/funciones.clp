(deffunction str-gt (?a ?b)
    (> (str-compare ?a ?b) 0)
)

(deffunction mejor-recomendacion ($?lista)
    (bind ?maximo nil)
    (bind ?elemento nil)
    (progn$ (?curr-rec $?lista)
        (bind ?curr-punt (send ?curr-rec get-puntuacion))
        (if (or (eq ?maximo nil) (> ?curr-punt ?maximo))
            then 
            (bind ?maximo ?curr-punt)
            (bind ?elemento ?curr-rec)
        )
    )
    ?elemento
)

;;; Funcion para hacer una pregunta con respuesta cualquiera
(deffunction pregunta-general (?pregunta)
    (format t "%s " ?pregunta)
    (bind ?respuesta (read))
    (while (not (lexemep ?respuesta)) do
        (format t "%s " ?pregunta)
        (bind ?respuesta (read))
    )
    ?respuesta
)

;;; Funcion para hacer una pregunta general con una serie de respuestas admitidas
(deffunction MAIN::pregunta-opciones (?question $?allowed-values)
    (format t "%s "?question)
    (progn$ (?curr-value $?allowed-values)
        (format t "[%s]" ?curr-value)
    )
    (printout t ": ")
    (bind ?answer (read))
    (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
    (while (not (member ?answer ?allowed-values)) do
      (format t "%s "?question)
      (progn$ (?curr-value $?allowed-values)
        (format t "[%s]" ?curr-value)
      )
      (printout t ": ")
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
    ?answer
)
   
;;; Funcion para hacer una pregunta de tipo si/no
(deffunction MAIN::pregunta-si-no (?question)
    (bind ?response (pregunta-opciones ?question si no))
    (if (or (eq ?response si) (eq ?response s))
       then TRUE 
       else FALSE)
)

;;; Funcion para hacer una pregunta con respuesta numerica unica
(deffunction MAIN::pregunta-numerica (?pregunta ?rangini ?rangfi)
    (format t "%s [%d, %d]: " ?pregunta ?rangini ?rangfi)
    (bind ?respuesta (read))
    (while (not(and(>= ?respuesta ?rangini)(<= ?respuesta ?rangfi))) do
        (format t "%s [%d, %d] " ?pregunta ?rangini ?rangfi)
        (bind ?respuesta (read))
    )
    ?respuesta
)

(deffunction MAIN::pregunta-numerica-positiva (?pregunta)
    (format t "%s " ?pregunta)
    (bind ?respuesta (read))
    (while (< ?respuesta 0) do
        (format t "%s " ?pregunta)
        (bind ?respuesta (read))
    )
    ?respuesta
)

;;; Funcion para hacer pregunta con indice de respuestas posibles
(deffunction MAIN::pregunta-indice (?pregunta $?valores-posibles)
    (bind ?linea (format nil "%s" ?pregunta))
    (printout t ?linea crlf)
    (bind $?valores-posibles (sort str-gt $?valores-posibles))
    (progn$ (?var ?valores-posibles) 
            (bind ?linea (format nil "  %d. %s" ?var-index ?var))
            (printout t ?linea crlf)
    )
    (bind ?respuesta (pregunta-numerica "Escoja una opción" 1 (length$ ?valores-posibles)))
    (nth ?respuesta $?valores-posibles)
)

;;; Funcion para hacer una pregunta multi-respuesta con indices
(deffunction pregunta-multi (?pregunta $?valores-posibles)
    (bind ?linea (format nil "%s" ?pregunta))
    (printout t ?linea crlf)
    (bind $?valores-posibles (sort str-gt $?valores-posibles))
    (progn$ (?var ?valores-posibles) 
            (bind ?linea (format nil "  %d. %s" ?var-index ?var))
            (printout t ?linea crlf)
    )
    (format t "%s" "Indique los números separados por un espacio: ")
    (bind ?resp (readline))
    (bind ?numeros (str-explode ?resp))
    (bind $?lista (create$ ))
    (progn$ (?var ?numeros) 
        (if (and (integerp ?var) (and (>= ?var 1) (<= ?var (length$ ?valores-posibles))))
            then 
                (if (not (member$ ?var ?lista))
                    then (bind ?lista (insert$ ?lista (+ (length$ ?lista) 1) (nth ?var $?valores-posibles)))
                )
        ) 
    )
    $?lista
)

(deffunction add$ (?element $?list)
    (bind $?list (insert$ $?list (+ (length$ $?list) 1) ?element))
    ?list
)

(deffunction find-attr (?attr $?instances)
    (bind $?list (create$))
    (bind ?getter (sym-cat get- ?attr))
    (progn$ (?instance $?instances)
        (bind $?list (add$ (send ?instance ?getter) $?list))
    )

    $?list
)

(deffunction find-attr-ont (?attr $?instances)
    (bind $?list (create$))
    (bind ?getter (sym-cat get- ?attr))
    (progn$ (?instance $?instances)
        (bind $?list (add$ (send (instance-address * ?instance) ?getter) $?list)))

    $?list
)

(deffunction seleccionar-instancias (?class ?attr ?msg)
    (bind $?instances (find-all-instances ((?inst ?class)) TRUE))
    (bind $?respuestas (pregunta-multi ?msg (find-attr ?attr $?instances)))
    (bind $?lista (create$))
    (bind ?getter (sym-cat get- ?attr))
    (progn$ (?instance $?instances)
        (if (member$ (send ?instance ?getter) $?respuestas) then
            (bind $?lista (add$ (instance-address * ?instance) $?lista))
        )
    )
    $?lista
)

(deffunction seleccionar-instancia (?class ?attr ?msg)
    (bind $?instances (find-all-instances ((?inst ?class)) TRUE))
    (bind ?respuesta (pregunta-indice ?msg (find-attr ?attr $?instances)))
    (bind ?getter (sym-cat get- ?attr))
    (progn$ (?instance $?instances)
        (if (eq (send ?instance ?getter) ?respuesta) then
            (return (instance-address * ?instance))
        )
    )
)

(deffunction plato (?rec)
  (send ?rec get-plato)
)


(deffunction color-vino (?vino)
    (send (send ?vino get-color) get-nombre)
)

(deffunction print-round-two (?float)
    (format t "%.2f" ?float)
)

(deffunction separador ()
    (printout t "------------------------------------------------------------" crlf)
)

(deffunction imprimir-recomendacion (?rec)
    (bind ?punt (send ?rec get-puntuacion))
    (bind ?plato (plato ?rec))
    (bind $?just (send ?rec get-justificaciones))

    (printout t "    " (send ?plato get-nombre) crlf)
    (printout t "      Precio: ")
    (print-round-two (send ?plato get-precio))
    (printout t " €" crlf)
    (printout t "      Puntuación: " ?punt crlf)
    (printout t "      Justificaciones:" crlf)
    (progn$ (?j $?just)
        (printout t "        " ?j crlf)
    )
    (printout t crlf)
)

(deffunction imprimir-recomendaciones ($?recs)
    (progn$ (?rec $?recs)
        (imprimir-recomendacion ?rec)
    )
)

(deffunction imprimir-vino (?conector ?vino)
    (printout t ?conector)
    (printout t (lowcase (send (instance-address * (send ?vino get-color)) get-nombre)) " " (send ?vino get-nombre) " (")
    (print-round-two (send ?vino get-precio))
    (printout t " €)" crlf)
)

(deffunction imprimir-vino-plato (?conector ?plato $?vinos)
    (if (= 2 (length $?vinos))
        then
            (bind ?vino (nth ?plato $?vinos))
            (imprimir-vino ?conector ?vino))
)

(deffunction imprimir-plato (?num ?plato $?vinos)
    (printout t "    " (send ?plato get-nombre) " (")
    (print-round-two (send ?plato get-precio))
    (printout t " €)")
    (if (not (imprimir-vino-plato " con vino " ?num $?vinos))
        then (printout t crlf))
)

(deffunction imprimir-vino-menu (?conector $?vinos)
    (if (= 1 (length $?vinos))
        then
            (bind ?vino (nth 1 $?vinos))
            (imprimir-vino ?conector ?vino))
)

(deffunction imprimir-resumen-menu (?menu)
    (imprimir-vino-menu  "  Vino para el menú:        " (send ?menu get-vinos))

    (printout t "  Precio total por persona: ")
    (print-round-two (send ?menu get-precio))
    (printout t " €" crlf)
    (printout t "  Puntuación:               " (send ?menu get-puntuacion) crlf)
)

(deffunction imprimir-menu (?menu)
    (if (neq [nil] ?menu)
        then (bind ?primero (plato (send ?menu get-primero)))
             (bind ?segundo (plato (send ?menu get-segundo)))
             (bind ?postre (plato (send ?menu get-postre)))
             (bind $?vinos (send ?menu get-vinos))
             (bind ?nvinos )
    
             (imprimir-plato 1 ?primero $?vinos)
             (imprimir-plato 2 ?segundo $?vinos)
             (imprimir-plato 3 ?postre)

             (imprimir-resumen-menu ?menu)
    
        else (printout t "No disponible, lo sentimos." crlf))
)

(deffunction imprimir-menu-detallado (?menu)
    (if (neq [nil] ?menu)
        then (bind ?primero (send ?menu get-primero))
             (bind ?segundo (send ?menu get-segundo))
             (bind ?postre (send ?menu get-postre))
             (bind $?vinos (send ?menu get-vinos))
        
             (printout t "  Platos:" crlf)
             (imprimir-recomendacion ?primero)
             (imprimir-recomendacion ?segundo)
             (imprimir-recomendacion ?postre)
             
             (imprimir-vino-plato "  Vino para el primero:     " 1 $?vinos)
             (imprimir-vino-plato "  Vino para el segundo:     " 2 $?vinos)
        
             (imprimir-resumen-menu ?menu)
        
             (printout t "  Justificaciones:" crlf)
             (bind $?just (send ?menu get-justificaciones))
             (progn$ (?j $?just)
                 (printout t "    " ?j crlf)
             )
             (printout t crlf)
        
        else (printout t "No disponible, lo sentimos." crlf))
)

(deffunction seleccionar-uno ($?lista)
    (bind ?res (+ 1 (mod (random) (length $?lista))))
    (nth ?res $?lista)
)

(deffunction estado (?mensaje)
    (printout t "> " ?mensaje crlf)
)

(deffunction puntuacion-descendente (?a ?b)
    (< (send ?a get-puntuacion) (send ?b get-puntuacion))
)
