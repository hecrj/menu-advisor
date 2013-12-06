(defmodule presentacion
    (import MAIN ?ALL)
    (export ?ALL)
)

(defrule summary "Imprime un pequeño resumen"
    (Preferencias (tipos-menu $?tipos))
    =>
    (printout t "Tipos escogidos:" crlf)
    (progn$ (?tipo $?tipos)
        (printout t "    " ?tipo crlf)
    )
    (printout t "Recomendaciones candidatas" crlf)
    (assert (presentar-recomendaciones))
    (assert (presentar-menus))
)

(defrule imprimir-recomendaciones "Imprime la lista completa de recomendaciones candidatas"
    ?presenta <- (presentar-recomendaciones)
    (Recomendaciones (primeros $?primeros) (segundos $?segundos) (postres $?postres))
    =>
    (printout t "Platos ordenados por puntuación:" crlf)

    (printout t "------------------------------" crlf)
    (printout t "Primeros:" crlf)
    (imprimir-recomendaciones $?primeros)
    
    (printout t "------------------------------" crlf)
    (printout t "Segundos:" crlf)
    (imprimir-recomendaciones $?segundos)
    
    (printout t "------------------------------" crlf)
    (printout t "Postres:" crlf)
    (imprimir-recomendaciones $?postres)
    
    (retract ?presenta)
)

(defrule imprimir-menus "Imprime los menús"
    (declare (salience -10000))
    ?imprimir <- (presentar-menus)
    (SeleccionMenus (baratos $?baratos) (medios $?medios) (caros $?caros))
    =>
    (printout t "------------------------------" crlf)
    (printout t "Primera propuesta (más cara):" crlf)
    (imprimir-menus $?caros)

    (printout t "------------------------------" crlf)
    (printout t "Segunda propuesta (coste medio):" crlf)
    (imprimir-menus $?medios)

    (printout t "------------------------------" crlf)
    (printout t "Tercera propuesta (más barata):" crlf)
    (imprimir-menus $?baratos)

    (printout t "------------------------------" crlf)

    (if (pregunta-si-no "¿Desea ver las justificaciones de la recomendación?")
        then (assert (imprimir-justificaciones)))

    (retract ?imprimir)
)

(defrule imprimir-justificaciones "Imprime las justificaciones de cada menú recomendado"
    ?imprimir <- (imprimir-justificaciones)
    (SeleccionMenus (baratos $?baratos) (medios $?medios) (caros $?caros))
    =>
    (printout t "------------------------------" crlf)
    (printout t "Primera propuesta (más cara):" crlf)
    (imprimir-menus-detallados $?caros)

    (printout t "------------------------------" crlf)
    (printout t "Segunda propuesta (coste medio):" crlf)
    (imprimir-menus-detallados $?medios)

    (printout t "------------------------------" crlf)
    (printout t "Tercera propuesta (más barata):" crlf)
    (imprimir-menus-detallados $?baratos)

    (printout t "------------------------------" crlf)

    (retract ?imprimir)
)