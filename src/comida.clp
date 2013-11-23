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

; Modulo de obtencion de los datos del cliente
(load "modulos/datos-cliente.clp")

; Modulo de clasificación heurística
(load "modulos/clasificacion.clp")

; Modulo de generacion de soluciones
(load "modulos/generacion.clp")

; Modulo de presentacion de resultados
(load "modulos/presentacion.clp")


; Regla principal
(defrule MAIN::initialRule "Regla principial"
	(declare (salience 10))
	=>
	(printout t "====================================================================" crlf)
  	(printout t "=            Sistema de recomendacion de menús HIN FOOD            =" crlf)
	(printout t "====================================================================" crlf)
  	(printout t crlf)  	
	(printout t "¿Quiere un menú de ensueño?" crlf)
	(printout t "¡Responda las siguientes preguntas y HIN FOOD le recomendará el mejor menú!" crlf)
	(printout t crlf)
	(focus datos-cliente)
)

; Ejecutar
(run)
