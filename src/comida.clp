; Reset everything
(clear)
(reset)

; Cargar ontología
(load "protege/comida.pont")

; Cargar instancias
(load-instances "protege/comida.pins")

; Modulo principal
(defmodule MAIN (export ?ALL))

; Clases
(load "clases.clp")

; Templates
(load "templates.clp")

; Funciones
(load "funciones.clp")

; Módulo de abstracción de datos
(load "modulos/abstraccion.clp")

; Módulo de filtración de platos
(load "modulos/refinamiento/platos/filtracion.clp")

; Modulo de puntuación de platos
(load "modulos/refinamiento/platos/puntuacion.clp")

; Módulo de selección de platos
(load "modulos/refinamiento/platos/seleccion.clp")

; Módulo de filtración de menús
(load "modulos/refinamiento/menus/filtracion.clp")

; Modulo de puntuación de menús
(load "modulos/refinamiento/menus/puntuacion.clp")

; Módulo de selección de menús
(load "modulos/refinamiento/menus/seleccion.clp")

; Modulo de presentacion de resultados
(load "modulos/presentacion.clp")

; Regla principal
(defrule MAIN::initialRule "Regla principial"
    =>
    (printout t "====================================================================" crlf)
    (printout t "=            Sistema de recomendacion de menús Rico Rico           =" crlf)
    (printout t "====================================================================" crlf)
    (printout t crlf)      
    (printout t "¿Quiere un menú de ensueño para su próxima celebración?" crlf)
    (printout t "¡Responda las siguientes preguntas y Rico Rico le recomendará el mejor menú!" crlf)
    (printout t crlf)
    (focus abstraccion) ; Empezar abstrayendo datos
)

; Ejecutar
(run)
