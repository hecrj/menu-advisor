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

  ; 0 = no quiere vino, 1 = quiere un vino, 2 = quiere un vino para el primero y uno para el segundo
  (slot vino (type INTEGER) (default -1))

  (slot tipo-vino (type STRING) (default "Sin preferencia")
    (allowed-strings "Tinto"
                     "Rojo"
                     "Negro"
                     "Sin preferencia"
    )
  ) 
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
