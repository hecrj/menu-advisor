(defmodule presentacion
    (import MAIN ?ALL)
    (export ?ALL)
)

(defrule summary "Imprime un pequeño resumen"
    (Preferencias (tipos-menu $?tipos))
    =>
    ;(assert (presentar-recomendaciones))
    (assert (presentar-menus))
)

(defrule imprimir-recomendaciones "Imprime la lista completa de recomendaciones candidatas"
    ?presenta <- (presentar-recomendaciones)
    (Recomendaciones (primeros $?primeros) (segundos $?segundos) (postres $?postres))
    =>
    (printout t "Platos ordenados por puntuación:" crlf)

    (separador)
    (printout t "Primeros:" crlf)
    (imprimir-recomendaciones $?primeros)
    
    (separador)
    (printout t "Segundos:" crlf)
    (imprimir-recomendaciones $?segundos)
    
    (separador)
    (printout t "Postres:" crlf)
    (imprimir-recomendaciones $?postres)
    
    (retract ?presenta)
)

(defrule imprimir-menus "Imprime los menús"
    (declare (salience -10000))
    ?imprimir <- (presentar-menus)
    (object (is-a SeleccionMenus) (baratos $?baratos) (medios $?medios) (caros $?caros))
    =>
    (separador)
    (printout t "Primera propuesta (más cara):" crlf)
    (imprimir-menus $?caros)

    (separador)
    (printout t "Segunda propuesta (coste medio):" crlf)
    (imprimir-menus $?medios)

    (separador)
    (printout t "Tercera propuesta (más barata):" crlf)
    (imprimir-menus $?baratos)

    (separador)

    (if (pregunta-si-no "¿Desea ver las justificaciones de la recomendación?")
        then (assert (imprimir-justificaciones)))

    (retract ?imprimir)
)

(defrule imprimir-justificaciones "Imprime las justificaciones de cada menú recomendado"
    ?imprimir <- (imprimir-justificaciones)
    (object (is-a SeleccionMenus) (baratos $?baratos) (medios $?medios) (caros $?caros))
    =>
    (separador)
    (printout t "Primera propuesta (más cara):" crlf)
    (imprimir-menus-detallados $?caros)

    (separador)
    (printout t "Segunda propuesta (coste medio):" crlf)
    (imprimir-menus-detallados $?medios)

    (separador)
    (printout t "Tercera propuesta (más barata):" crlf)
    (imprimir-menus-detallados $?baratos)

    (separador)

    (retract ?imprimir)
)