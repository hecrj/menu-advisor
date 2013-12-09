(defmodule platos-seleccion
    (import MAIN ?ALL)
    (export ?ALL)
)

(deftemplate Limites
    (slot primeros (type INTEGER) (default 30))
    (slot segundos (type INTEGER) (default 30))
    (slot postres (type INTEGER) (default 15))
)

(defrule iniciar-limites "Inicia los límites"
    (declare (salience 10000))
    (not (Limites))
    =>
    (assert (Limites))
)

(defrule ordenar-recomendaciones "Ordena las recomendaciones en función de su puntuación"
    (declare (salience 9900))
    (Limites (primeros ?limite-primeros) (segundos ?limite-segundos) (postres ?limite-postres))
    (not (Recomendaciones))
    =>
    (estado "Seleccionando recomendaciones...")
    (bind $?recs (find-all-instances ((?inst Recomendacion)) TRUE))
    (bind $?primeros (create$))
    (bind $?segundos (create$))
    (bind $?postres (create$))
    (while
        (and
            (> (length $?recs) 0)
            (or
                (or (< (length $?primeros) ?limite-primeros) (< (length $?segundos) ?limite-segundos))
                (< (length $?postres) ?limite-postres)
            )
        )
        (bind ?max-rec (mejor-recomendacion $?recs))
        (bind ?plato (send ?max-rec get-plato))
        (bind $?tipos (send ?plato get-tipo))
        (if (and (member$ PRIMERO $?tipos) (< (length $?primeros) ?limite-primeros))
            then (bind $?primeros (add$ ?max-rec $?primeros)))
        (if (and (member$ SEGUNDO $?tipos) (< (length $?segundos) ?limite-segundos))
            then (bind $?segundos (add$ ?max-rec $?segundos)))
        (if (and (member$ POSTRE $?tipos) (< (length $?postres) ?limite-postres))
            then (bind $?postres (add$ ?max-rec $?postres)))
        (bind $?recs (delete-member$ $?recs ?max-rec))
    )
    (assert (Recomendaciones (primeros $?primeros) (segundos $?segundos) (postres $?postres)))
)

(defrule ir-a-filtrar-menus "Empezar a filtrar posibles menus"
  (declare (salience -10000))
  =>
  (focus menus-filtracion)
)
