(deftemplate Preferencias
  (multislot tipos-menu (type SYMBOL) (default desconocido))
  (multislot ingredientes-prohibidos
    (type STRING)
    (default "desconocido"))
  (slot temperatura
    (type SYMBOL)
    (default desconocido))
  (slot evento
        (type STRING)
        (default ""))
  (multislot regiones
             (type STRING)
             (default "desconocido"))
  (slot comensales
    (type INTEGER)
    (range 0 ?VARIABLE))
)

(deftemplate Contexto
  (slot estacion
    (type STRING)
    (allowed-strings "Primavera"
                     "Verano"
                     "Otoño"
                     "Invierno"
    )
  )
)

(deftemplate Recomendaciones
  (multislot primeros
    (type INSTANCE)
    (allowed-classes Recomendacion))
  (multislot segundos
    (type INSTANCE)
    (allowed-classes Recomendacion))
  (multislot postres
    (type INSTANCE)
    (allowed-classes Recomendacion))
)
