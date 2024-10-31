object controlNave1{
  method cambiarDireccionIzquierda(unEnemigo){
    game.onTick(1000, "izquierda nave 1", {
      unEnemigo.moverALaIzquierda()
      if (unEnemigo.estaEnBordeIzquierdo()){
        game.removeTickEvent("izquierda nave 1")
        self.cambiarDireccionDerecha(unEnemigo)
      }
    })
    }

  method cambiarDireccionDerecha(unEnemigo){
      game.onTick(1000, "derecha nave 1", {
      unEnemigo.moverALaDerecha()
      if (unEnemigo.estaEnBordeDerecho()){
        game.removeTickEvent("derecha nave 1")
        self.cambiarDireccionIzquierda(unEnemigo)
        }
    })
    }
}

object controlNave2 {
  method cambiarDireccionIzquierda(unEnemigo){
    game.onTick(1000, "izquierda nave 2", {
      unEnemigo.moverALaIzquierda()
      if (unEnemigo.estaEnBordeIzquierdo()){
        game.removeTickEvent("izquierda nave 2")
        self.cambiarDireccionDerecha(unEnemigo)
      }
    })
    }

  method cambiarDireccionDerecha(unEnemigo){
    game.onTick(1000, "derecha nave 2", {
    unEnemigo.moverALaIzquierda()
      if (unEnemigo.estaEnBordeDerecho()){
        game.removeTickEvent("derecha nave 2")
        self.cambiarDireccionIzquierda(unEnemigo)
        }
    })
    }
}