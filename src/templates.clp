(deftemplate Preferencias
    (multislot tipos-menu 
        (type SYMBOL) 
        (default desconocido))
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
    (slot dificultad
        (type INTEGER)
        (range 0 100))
    (slot precio-maximo
        (type INTEGER)
        (default -1)) ; los INTEGER no pueden ser nil
    (slot precio-minimo
        (type INTEGER)
        (default -1))
    
    ; 0 = no quiere vino, 1 = quiere un vino, 2 = quiere un vino para el primero y uno para el segundo
    (slot vino
        (type INTEGER)
        (default -1))
    (slot tipo-vino (type STRING)
        (default "Sin preferencia")
        (allowed-strings
            "Tinto"
            "Blanco"
            "Rosado"
            "Sin preferencia"
            ))
    (slot exclusivo 
        (type SYMBOL)
        (default desconocido))
)

(deftemplate FranjasPrecio
    (slot minimo (type FLOAT) (default 0.0))
    (slot barato (type FLOAT) (default 15.0))
    (slot medio (type FLOAT) (default 30.0))
    (slot caro (type FLOAT) (default 45.0))
)

(deftemplate SeleccionMenus
    (multislot barato
        (type INSTANCE)
        (allowed-classes Menu))
    (multislot medio
        (type INSTANCE)
        (allowed-classes Menu))
    (multislot caro
        (type INSTANCE)
        (allowed-classes Menu))
)

(deftemplate Contexto
    (slot estacion
        (type STRING)
        (allowed-strings
            "Primavera"
            "Verano"
            "Otoño"
            "Invierno"
            ))
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
