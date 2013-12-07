(defmodule menus-puntuacion
    (import MAIN ?ALL)
    (export ?ALL)
)

(deftemplate Pesos
    (slot pesadez (type INTEGER) (default 50))
    (slot ligereza (type INTEGER) (default 50))
    (slot vino-primero (type INTEGER) (default 50))
    (slot vino-segundo (type INTEGER) (default 50))
)

(defrule inicializa-Pesos "Define la ponderación de factores"
    (declare (salience 10000))
    =>
    (assert (Pesos))
)


(defrule puntuar-menu-platos "Puntúa un menú en función de la puntuación de sus platos"
    (not (platos-puntuados))
    =>
    (bind $?menus (find-all-instances ((?inst MenuAbstracto)) TRUE))
    (progn$ (?menu $?menus)
        (bind ?menu-punt
            (+
                (+
                    (send (send ?menu get-primero) get-puntuacion)
                    (send (send ?menu get-segundo) get-puntuacion)
                )
                (send (send ?menu get-postre) get-puntuacion)
            )
        )
        (send ?menu put-puntuacion (+ (send ?menu get-puntuacion) ?menu-punt))
        (if (< ?menu-punt 0)
            then (bind ?signo "-")
            else (bind ?signo "+"))
        (send ?menu put-justificaciones
            (add$ (str-cat "Los platos del menú suman una puntuación total -> " ?signo ?menu-punt) (send ?menu get-justificaciones)))
    )
    (assert (platos-puntuados))
)

(defrule puntuar-pesadez "Puntúa un menú demasiado pesado negativamente"
    (Pesos (pesadez ?peso-pesadez))
    (not (pesadez-puntuada))
    =>
    (bind $?menus (find-all-instances ((?inst MenuAbstracto)) TRUE))
    (progn$ (?menu $?menus)
        (bind ?prim (plato (send ?menu get-primero)))
        (bind ?seg (plato (send ?menu get-segundo)))
        (if (and (eq PESADO (send ?prim get-pesadez)) (eq PESADO (send ?seg get-pesadez)))
            then (bind ?punt (send ?menu get-puntuacion))
                 (bind $?just (send ?menu get-justificaciones))
                 (send ?menu put-puntuacion (- ?punt ?peso-pesadez))
                 (send ?menu put-justificaciones
                     (add$ (str-cat "El primero y el segundo son platos pesados, los comensales lo pueden encontrar excesivo -> -" ?peso-pesadez) $?just))
                 ;(printout t "Pesadez: " ?menu crlf))
        )
    )
    (assert (pesadez-puntuada))
)

(defrule puntuar-ligereza "Puntúa un menú demasiado ligero negativamente"
    (Pesos (ligereza ?peso-ligereza))
    (not (ligereza-puntuada))
    =>
    (bind $?menus (find-all-instances ((?inst MenuAbstracto)) TRUE))
    (progn$ (?menu $?menus)
        (bind ?prim (plato (send ?menu get-primero)))
        (bind ?seg (plato (send ?menu get-segundo)))
        (if (and (eq LIGERO (send ?prim get-pesadez)) (eq LIGERO (send ?seg get-pesadez)))
            then (bind ?punt (send ?menu get-puntuacion))
                 (bind $?just (send ?menu get-justificaciones))
                 (send ?menu put-puntuacion (- ?punt ?peso-ligereza))
                 (send ?menu put-justificaciones
                     (add$ (str-cat "El primero y el segundo son platos ligeros, los comensales pueden no saciarse -> -" ?peso-ligereza) $?just))
                 ;(printout t "Ligereza: " ?menu crlf))
        )
    )
    (assert (ligereza-puntuada))
)

(defrule puntuar-vino-primero "Puntúa los menús en función de si el vino encaja con el primer plato"
    (Pesos (vino-primero ?peso-vino-primero))
    (not (vino-primero-puntuado))
    =>
    (bind $?menus (find-all-instances ((?inst MenuAbstracto)) TRUE))
    (progn$ (?menu $?menus)
        (bind $?color-vinos (send ?menu get-color-vinos))
        (if (> (length $?color-vinos) 0) then
            (bind ?prim (send ?menu get-primero))
            (bind ?genPrim (send (plato ?prim) get-genero))
            (bind ?predPrim (send (instance-address * ?genPrim) get-predilecto))
            (bind ?color (nth 1 $?color-vinos))
            (if (and (neq ?predPrim [nil]) (eq ?color (send (instance-address * ?predPrim) get-nombre))) then
                (bind ?punt (send ?menu get-puntuacion))
                (bind $?just (send ?menu get-justificaciones))
                (send ?menu put-puntuacion (+ ?punt ?peso-vino-primero))
                (send ?menu put-justificaciones
                    (add$ (str-cat "El primer plato es de un género que encaja bien con el color del vino -> +" ?peso-vino-primero) $?just)))
            ))
    (assert (vino-primero-puntuado))
)

(defrule puntuar-vino-segundo "Puntúa los menús en función de si el vino encaja con el segundo plato"
    (Pesos (vino-segundo ?peso-vino-segundo))
    (not (vino-segundo-puntuado TRUE))
    =>
    (bind $?menus (find-all-instances ((?inst MenuAbstracto)) TRUE))
    (progn$ (?menu $?menus)
        (bind $?color-vinos (send ?menu get-color-vinos))
        (if (> (length $?color-vinos) 0) then ; tiene que ser un menú con vino
            (bind ?seg (send ?menu get-segundo))
            (bind ?genSeg (send (plato ?seg) get-genero))
            (bind ?predSeg (send (instance-address * ?genSeg) get-predilecto))
            (bind ?color (nth (length $?color-vinos) $?color-vinos))
            (if (and (neq ?predSeg [nil]) (eq ?color (send (instance-address * ?predSeg) get-nombre))) then
                (bind ?punt (send ?menu get-puntuacion))
                (bind $?just (send ?menu get-justificaciones))
                (send ?menu put-puntuacion (+ ?punt ?peso-vino-segundo))
                (send ?menu put-justificaciones
                    (add$ (str-cat "El segundo plato es de un género que encaja bien con el color del vino -> +" ?peso-vino-segundo) $?just)))
            ))
    (assert (vino-segundo-puntuado TRUE))
)

(defrule ir-a-seleccionar "Empieza a seleccionar menús"
  (declare (salience -10000))
  =>
  (estado "Seleccionando menús...")
  (focus menus-seleccion)
)
