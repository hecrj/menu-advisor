; Reset everything
(clear)
(reset)

; Cargar ontología
(load "protege/comida.pont")

; Cargar instancias
(load-instances "protege/comida.pins")

; Exportación del MAIN
(defmodule MAIN (export ?ALL))

; Templates
(deftemplate Preferencias
	(slot tipo (type SYMBOL) (default ninguno))
)

(deftemplate Cliente
	(slot nombre (type STRING))
)

; Reglas
(defrule test "Regla de prueba"
	(not (Cliente))
	=>
	(assert (Cliente (nombre "Bob")))
	(assert (Preferencias (tipo moderna)))
)

(defrule test_pref "Test preferencias"
	(Preferencias (tipo ?t))
	=>
	(printout t "Tipo de cocina preferida: " ?t crlf)
)

(defrule list_ingredients "Listar ingredientes"
	(Cliente)
	(object (is-a Ingrediente) (nombre ?n))
	=>
	(printout t ?n crlf)
)

; Run and exit, by default
(run)
(exit)
