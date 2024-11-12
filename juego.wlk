import naves.*
import configuracion.*
object juego{
  var cantidadEnemigosVivos = 1
  var estaJugando = false

  method iniciarNivel1(){
    self.limpiarJuego()
    estaJugando = true
    nivel1.iniciar()
  }

  method iniciarNivel2(){
    self.limpiarJuego()
    estaJugando = true
    nivel2.iniciar()
  }

  method iniciarModoInfinito(){
    self.limpiarJuego()
    modoInfinito.iniciar()
  }

  method actualizar(){
    if (cantidadEnemigosVivos == 0 and estaJugando){
      self.limpiarJuego()
    }
  }

  method cambiarCantidadEnemigosVivosA(unaCantidad){ 
    cantidadEnemigosVivos = unaCantidad
  }

  method disminuirCantidadEnemigosVivosYActualizar(){ 
    cantidadEnemigosVivos = 0.max(cantidadEnemigosVivos - 1)
    self.actualizar()
  }

  method limpiarJuego(){
    cantidadEnemigosVivos = 1
    modoInfinito.reiniciarValoresModoInfinito()
    removedor.removerTodosLosOnTicks()
    game.clear()
    estaJugando = false
    configuracion.iniciarJuego()
  }

}

object nivel1 {
  const naves = [ new Nave (),
    new NaveEnemiga (bordeIzq = 0, bordeDer = 4, numeroDeNave = 1, posicionInicial = game.at(0, 9)),
    new NaveEnemiga (bordeIzq = 5, bordeDer = 9, numeroDeNave = 2, posicionInicial = game.at(9, 9))
  ]

  method iniciar(){
    self.configurarNaves()
    juego.cambiarCantidadEnemigosVivosA(2)
  }

  method configurarNaves(){
    self.agregarNaves()
    self.activarDisparosNavesEnemigas()
    self.activarMovimientoDeLasBalas()
    self.activarMovimientoNavesEnemigas()
  }

  method agregarNaves(){
    naves.forEach({nave =>
      game.addVisual(nave)
      nave.configurarParaNivel1()
    })
  }

  method activarMovimientoDeLasBalas(){
    game.onTick(100, "movimiento de balas nivel 1", {=>
      naves.forEach({nave => nave.actualizarBalas()})
    })
  }

  method activarDisparosNavesEnemigas(){
    game.onTick(1500, "disparos enemigos nivel 1", {=>
      naves.forEach({nave => nave.dispararAEnemigo()})
    })
  }

  method activarMovimientoNavesEnemigas(){
    game.onTick(3000, "movimiento enemigos nivel 1", {=>
      naves.forEach({nave => nave.mover()})
    })
  }
}

object nivel2 {
  const naves = [ new Nave (position = game.at(0, 0)),
    new NaveEnemiga (nivel = 2, bordeIzq = 0, bordeDer = 4, numeroDeNave = 1, posicionInicial = game.at(0, 9)),
    new NaveEnemiga (nivel = 2, bordeIzq = 5, bordeDer = 9, numeroDeNave = 2, posicionInicial = game.at(9, 9)),
    new NaveEnemiga (nivel = 2, bordeIzq = 5, bordeDer = 9, numeroDeNave = 3, posicionInicial = game.at(5, 6)),
    new NaveEnemiga (nivel = 2, bordeIzq = 0, bordeDer = 4, numeroDeNave = 4, posicionInicial = game.at(4, 6))
  ]

  method iniciar(){
    self.configurarNaves()
    juego.cambiarCantidadEnemigosVivosA(4)
  }

  method configurarNaves(){
    self.agregarNaves()
    self.activarDisparosNavesEnemigas()
    self.activarMovimientoDeLasBalas()
    self.activarMovimientoNavesEnemigas()
  }

  method agregarNaves(){
    naves.forEach({nave =>
      game.addVisual(nave)
      nave.configurarParaNivel2()
    })
  }

  method activarMovimientoDeLasBalas(){
    game.onTick(100, "movimiento de balas nivel 2", {=>
      naves.forEach({nave => nave.actualizarBalas()})
    })
  }

  method activarDisparosNavesEnemigas(){
    game.onTick(1500, "disparos enemigos nivel 2", {=>
      naves.forEach({nave => nave.dispararAEnemigo()})
    })
  }

  method activarMovimientoNavesEnemigas(){
    game.onTick(3000, "movimiento enemigos nivel 2", {=>
      naves.forEach({nave => nave.mover()})
    })
  }
}

object modoInfinito{
  var cantEnemigosPorSpawn = 1
  var cantidadEnemigosVivos = 0
  var nroOleada = 0
  var estaJugando = false
  const property naves = []

  method iniciar(){
    estaJugando = true
    self.agregarYConfigurarNaveAliada()
    self.actualizarOleadaYEnemigos()
    self.agregarPuntajeYConfigurarDisparos()
  }

  method agregarPuntajeYConfigurarDisparos(){
    self.activarMovimientoDeLasBalas()
    self.activarDisparosNavesEnemigas()
    self.activarMovimientoNavesEnemigas()
    game.addVisual(puntaje)
  }

  method reiniciarValoresModoInfinito(){
    self.reiniciarVariables()
    estaJugando = false
    puntaje.reiniciarPuntaje()
    naves.clear()
  }

  method reiniciarVariables(){
    cantEnemigosPorSpawn = 1
    cantidadEnemigosVivos = 0
    nroOleada = 0
  }

  method agregarYConfigurarNaveAliada(){
    const naveAliada = new Nave()
    game.addVisual(naveAliada)
    naves.add(naveAliada)
    naveAliada.configurarParaNivel2()
  }

  method actualizarOleadaYEnemigos(){
    if (cantidadEnemigosVivos == 0 and estaJugando){
      nroOleada += 1
      self.aumentarCantEnemigosPorSpawnSiCorresponde()
      self.spawnearNavesEnemigas()
    }
  }

  method aumentarCantEnemigosPorSpawnSiCorresponde(){
    if (nroOleada % 4 == 0){
      cantEnemigosPorSpawn = 9.min(cantEnemigosPorSpawn + 1)
    }
  }

  method disminuirCantidadEnemigosVivosYActualizar(){
    cantidadEnemigosVivos = 0.max(cantidadEnemigosVivos - 1)
    puntaje.aumentarPuntajeEn(100)
    self.actualizarOleadaYEnemigos()
  }

  method spawnearNavesEnemigas(){
    var posicionY = 9
    var numeroDeNave = 1

    (1..cantEnemigosPorSpawn).forEach({ valor =>
      self.crearNaveEnemigoEnPosicionConNumero(game.at((1..8).anyOne(), posicionY), numeroDeNave)
      posicionY -= 1
      numeroDeNave += 1
    })
  }

  method crearNaveEnemigoEnPosicionConNumero(unaPosicion,unNumero) {
    const naveEnemiga = new NaveEnemiga(nivel = (1..2).anyOne(), bordeIzq = 0, bordeDer = 9, 
      numeroDeNave = unNumero, posicionInicial = unaPosicion, seTieneQueMoverADerecha = [true, false].anyOne())
    
    game.addVisual(naveEnemiga)
    naves.add(naveEnemiga)
    naveEnemiga.configurarParaModoInfinito()
    cantidadEnemigosVivos += 1
  }

  method activarMovimientoDeLasBalas(){
    game.onTick(100, "movimiento de balas modo infinito", {=>
      naves.forEach({nave => nave.actualizarBalas()})
    })
  }

  method activarDisparosNavesEnemigas(){
    game.onTick(1500, "disparos enemigos modo infinito", {=>
      naves.forEach({nave => nave.dispararAEnemigo()})
    })
  }

  method activarMovimientoNavesEnemigas(){
    game.onTick(3000, "movimiento enemigos modo infinito", {=>
      naves.forEach({nave => nave.mover()})
    })
  }
}

object puntaje {
  var puntaje = 0

  method text() = "" + puntaje

  method position() = game.at(9, 10)

  method reiniciarPuntaje(){
    puntaje = 0
  }

  method aumentarPuntajeEn(unaCantidad){
    puntaje += unaCantidad
  }

  method textColor() = "FFFFFF"
}

object removedor {
  
  method removerTodosLosOnTicks(){
    self.removerOnTicksNaves()
    self.removerOnTicksBalas()
    self.removerOnTicksDisparos()
  }

  method removerOnTicksNaves(){
    game.removeTickEvent("movimiento enemigos nivel 1")
    game.removeTickEvent("movimiento enemigos nivel 2")
    game.removeTickEvent("movimiento enemigos modo infinito")
  }

  method removerOnTicksBalas(){
    game.removeTickEvent("movimiento de balas nivel 1")
    game.removeTickEvent("movimiento de balas nivel 2")
    game.removeTickEvent("movimiento de balas modo infinito")
  }

  method removerOnTicksDisparos(){
    game.removeTickEvent("disparos enemigos nivel 1")
    game.removeTickEvent("disparos enemigos nivel 2")
    game.removeTickEvent("disparos enemigos modo infinito")
  }
}
