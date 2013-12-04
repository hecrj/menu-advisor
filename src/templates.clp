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
    (range 0 ?VARIABLE)
  )
  (slot precio-maximo (type INTEGER) (default -1)) ; no se si los INTEGER pueden ser 'nil'
  (slot precio-minimo (type INTEGER) (default -1))
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
