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
    (while (< ?respuesta 1) do
        (format t "%s " ?pregunta)
        (bind ?respuesta (read))
    )
    ?respuesta
)

;;; Funcion para hacer pregunta con indice de respuestas posibles
(deffunction MAIN::pregunta-indice (?pregunta $?valores-posibles)
    (bind ?linea (format nil "%s" ?pregunta))
    (printout t ?linea crlf)
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

(deffunction imprimir-recomendacion (?rec)
    (bind ?punt (send ?rec get-puntuacion))
    (bind ?plato (plato ?rec))
    (bind $?just (send ?rec get-justificaciones))

    (printout t "    " (send ?plato get-nombre) crlf)
    (printout t "      Puntuación: " ?punt crlf)
    (printout t "      Precio: " (send ?plato get-precio) crlf)
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

(deffunction imprimir-menu (?menu)
    (bind ?primero (plato (send ?menu get-primero)))
    (bind ?segundo (plato (send ?menu get-segundo)))
    (bind ?postre (plato (send ?menu get-postre)))
    
    (printout t "    " (send ?primero get-nombre) " (" (send ?primero get-precio) "€)" crlf)
    (printout t "    " (send ?segundo get-nombre) " (" (send ?segundo get-precio) "€)" crlf)
    (printout t "    " (send ?postre get-nombre)  " (" (send ?postre get-precio) "€)" crlf)
    (printout t "")
    (printout t "  Precio total: " (send ?menu get-precio) "€" crlf)
    (printout t "  Puntuación:   " (send ?menu get-puntuacion) crlf)
)

(deffunction imprimir-menus ($?menus)
    (if (neq 0 (length $?menus))
        then
            (progn$ (?menu $?menus)
                (imprimir-menu ?menu)
            )
        else (printout t "No disponible, lo sentimos." crlf))
)

(deffunction imprimir-menu-detallado (?menu)
    (printout t "  Platos:" crlf)
    (imprimir-recomendacion (send ?menu get-primero))
    (imprimir-recomendacion (send ?menu get-segundo))
    (imprimir-recomendacion (send ?menu get-postre))

    (printout t "  Precio total: " (send ?menu get-precio) "€" crlf)
    (printout t "  Puntuación:   " (send ?menu get-puntuacion) crlf)
    (printout t "  Justificaciones:" crlf)
    (bind $?just (send ?menu get-justificaciones))
    (progn$ (?j $?just)
        (printout t "    " ?j crlf)
    )
    (printout t crlf)
)

(deffunction imprimir-menus-detallados ($?menus)
    (if (neq 0 (length $?menus))
        then
            (progn$ (?menu $?menus)
                (imprimir-menu-detallado ?menu)
            )
        else (printout t "No disponible, lo sentimos." crlf))
)
