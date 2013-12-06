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
)

(defrule imprimir-recomendaciones "Imprime la lista completa de recomendaciones candidatas"
    ?presenta <- (presentar-recomendaciones)
    (Recomendaciones (primeros $?primeros) (segundos $?segundos) (postres $?postres))
    =>
    (printout t "Platos ordenados por puntuación:" crlf)

    (printout t "Primeros:" crlf)
    (imprimir-recomendaciones $?primeros)
    (printout t "------------------------------" crlf)

    (printout t "Segundos:" crlf)
    (imprimir-recomendaciones $?segundos)
    (printout t "------------------------------" crlf)

    (printout t "Postres:" crlf)
    (imprimir-recomendaciones $?postres)
    (printout t "------------------------------" crlf)
    
    (retract ?presenta)
    (assert (presentar-menus))
)

(defrule imprimir-menus "Imprime los menús"
    ?imprimir <- (presentar-menus)
    (SeleccionMenus (barato ?barato) (medio ?medio) (caro ?caro))
    =>
    (printout t "------------------------------" crlf)
    (printout t "Primera propuesta:" crlf)
    (imprimir-menu ?caro)
    (printout t "------------------------------" crlf)
    (printout t "Segunda propuesta:" crlf)
    (imprimir-menu ?medio)
    (printout t "------------------------------" crlf)
    (printout t "Tercera propuesta:" crlf)
    (imprimir-menu ?barato)

    (retract ?imprimir)
)