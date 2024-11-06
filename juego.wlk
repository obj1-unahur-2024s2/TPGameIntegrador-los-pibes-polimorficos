import naves.*
import configuracion.*
object juego{
  var cantidadEnemigosVivos = 1

  method iniciarNivel1(){
    self.limpiarJuego()
    nivel1.iniciar()
    self.controlDeEnemigos()
  }

  method iniciarNivel2(){
    self.limpiarJuego()
    nivel2.iniciar()
    self.controlDeEnemigos()
  }

  method controlDeEnemigos(){
    game.onTick(1000, "nivel", {=> 
      if (cantidadEnemigosVivos == 0){
        self.limpiarJuego()
      }
    })
  }

  method cambiarCantidadEnemigosVivosA(unaCantidad){ 
    cantidadEnemigosVivos = unaCantidad
  }

  method disminuirCantidadEnemigosVivos(){ 
    cantidadEnemigosVivos = 0.max(cantidadEnemigosVivos - 1)
  }

  method limpiarJuego(){
    cantidadEnemigosVivos = 1
    console.println("la cantidad de enemigos vivos ahora es " + cantidadEnemigosVivos)
    game.clear()
    configuracion.iniciarJuego()
  }

}

object nivel1 {

  method iniciar(){
    self.configurarNaves()
    juego.cambiarCantidadEnemigosVivosA(2)
  }

  method configurarNaves(){
    self.naves().forEach({nave =>
      game.addVisual(nave)
      nave.configurarParaNivel1()
    })
  }

  method naves() = [ new Nave (position = game.at(0, 0)),
      new NaveEnemiga (position = game.at(0, 9), nivel = 1, bordeIzq = 0, bordeDer = 4, numeroDeNave = 1),
      new NaveEnemiga (position = game.at(9, 9), nivel = 1, bordeIzq = 5, bordeDer = 9, numeroDeNave = 2)
    ]
}

object nivel2 {

  method iniciar(){
    self.configurarNaves()
    juego.controlDeEnemigos()
    juego.cambiarCantidadEnemigosVivosA(4)
  }

  method configurarNaves(){
    self.naves().forEach({nave =>
      game.addVisual(nave)
      nave.configurarParaNivel2()
    })
  }

  method naves() = [ new Nave (position = game.at(0, 0)),
      new NaveEnemiga ( position = game.at(0, 9), nivel = 2, bordeIzq = 0, bordeDer = 4, numeroDeNave = 1),
      new NaveEnemiga ( position = game.at(9, 9), nivel = 2, bordeIzq = 5, bordeDer = 9, numeroDeNave = 2),
      new NaveEnemiga ( position = game.at(5, 6), nivel = 2, bordeIzq = 5, bordeDer = 9, numeroDeNave = 3),
      new NaveEnemiga ( position = game.at(4, 6), nivel = 2, bordeIzq = 0, bordeDer = 4, numeroDeNave = 4)
    ]
}

