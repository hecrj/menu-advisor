; Reset everything
(clear)
(reset)

; Cargar ontología
(load "protege/comida.pont")

; Cargar instancias
(load-instances "protege/comida.pins")

; Clases
(load "clases.clp")

; Templates
(load templates.clp)

; Modulo principal
(defmodule MAIN (export ?ALL))

; Modulo de obtencion de los datos del usuario
(load "modulos/datos-usuario.clp")

; Modulo de clasificación heurística
(load "modulos/clasificacion.clp")

;;; Modulo de generacion de soluciones
(load "modulos/generacion.clp")

;;; Modulo de presentacion de resultados
(load "modulos/presentacion.clp")

; Run
(run)
