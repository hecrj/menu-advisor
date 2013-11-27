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

; Módulo de filtración
(load "modulos/refinamiento/filtracion.clp")

; Modulo de puntuación
(load "modulos/refinamiento/puntuacion.clp")

; Módulo de selección
(load "modulos/refinamiento/seleccion.clp")

; Modulo de presentacion de resultados
(load "modulos/presentacion.clp")

; Regla principal
(defrule MAIN::initialRule "Regla principial"
	=>
	(printout t "====================================================================" crlf)
  	(printout t "=            Sistema de recomendacion de menús Rico Rico           =" crlf)
	(printout t "====================================================================" crlf)
  	(printout t crlf)  	
	(printout t "¿Quiere un menú de ensueño?" crlf)
	(printout t "¡Responda las siguientes preguntas y Rico Rico le recomendará el mejor menú!" crlf)
	(printout t crlf)
	(focus abstraccion) ; Empezar abstrayendo datos
)

; Ejecutar
(run)
