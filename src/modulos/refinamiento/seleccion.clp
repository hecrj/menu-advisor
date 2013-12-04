(defmodule seleccion
	(import MAIN ?ALL)
	(export ?ALL)
)

(defrule ordenar-recomendaciones "Ordena las recomendaciones en función de su puntuación"
    (not (Recomendaciones))
    =>
    (bind $?recs (find-all-instances ((?inst Recomendacion)) TRUE))
    (bind $?primeros (create$))
    (bind $?segundos (create$))
    (bind $?postres (create$))
    (while (> (length $?recs) 0)
        (bind ?max-rec (mejor-recomendacion $?recs))
        (bind ?plato (send ?max-rec get-plato))
        (bind $?tipos (send ?plato get-tipo))
        (if (member$ PRIMERO $?tipos)
            then (bind $?primeros (add$ ?max-rec $?primeros)))
        (if (member$ SEGUNDO $?tipos)
            then (bind $?segundos (add$ ?max-rec $?segundos)))
        (if (member$ POSTRE $?tipos)
            then (bind $?postres (add$ ?max-rec $?postres)))
        (bind $?recs (delete-member$ $?recs ?max-rec))
    )
    (assert (Recomendaciones (primeros $?primeros) (segundos $?segundos) (postres $?postres)))
)

(defrule ir-a-presentar "Empieza a presentar resultados"
  (declare (salience -10000))
  (Preferencias)
  =>
  (focus presentacion)
)
