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
    (SeleccionMenus (barato $?barato) (medio $?medio) (caro $?caro))
    =>
    (printout t "------------------------------" crlf)
    (printout t "Primera propuesta (más cara):" crlf)
    (if (neq 0 (length $?caro))
        then (imprimir-menu (nth 1 $?caro))
        else (printout t "No disponible, lo sentimos" crlf))

    (printout t "------------------------------" crlf)
    (printout t "Segunda propuesta (coste medio):" crlf)
    (if (neq 0 (length $?medio))
        then (imprimir-menu (nth 1 $?medio))
        else (printout t "No disponible, lo sentimos" crlf))

    (printout t "------------------------------" crlf)
    (printout t "Tercera propuesta (más barata):" crlf)
    (if (neq 0 (length $?barato))
        then (imprimir-menu (nth 1 $?barato))
        else (printout t "No disponible, lo sentimos" crlf))

    (printout t "------------------------------" crlf)

    (retract ?imprimir)
)