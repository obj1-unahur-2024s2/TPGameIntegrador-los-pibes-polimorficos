object control{
  method cambiarDireccionIzquierdaConVelocidadANave1(unEnemigo,unaVelocidad){
    game.onTick(unaVelocidad, "izquierda nave 1", {
      unEnemigo.moverALaIzquierda()
        if (unEnemigo.estaEnBordeIzquierdo()){
          game.removeTickEvent("izquierda nave 1")
          self.cambiarDireccionDerechaConVelocidadANave1(unEnemigo,unaVelocidad)
        }
      })
  }

  method cambiarDireccionDerechaConVelocidadANave1(unEnemigo,unaVelocidad){
    game.onTick(unaVelocidad, "derecha nave 1", {
      unEnemigo.moverALaDerecha()
        if (unEnemigo.estaEnBordeDerecho()){
          game.removeTickEvent("derecha nave 1")
          self.cambiarDireccionIzquierdaConVelocidadANave1(unEnemigo,unaVelocidad)
        }
      })
  }

  method cambiarDireccionIzquierdaConVelocidadANave2(unEnemigo,unaVelocidad){
    game.onTick(unaVelocidad, "izquierda nave 2", {
      unEnemigo.moverALaIzquierda()
        if (unEnemigo.estaEnBordeIzquierdo()){
          game.removeTickEvent("izquierda nave 2")
          self.cambiarDireccionDerechaConVelocidadANave2(unEnemigo,unaVelocidad)
        }
      })
  }

  method cambiarDireccionDerechaConVelocidadANave2(unEnemigo,unaVelocidad){
    game.onTick(unaVelocidad, "derecha nave 2", {
      unEnemigo.moverALaDerecha()
        if (unEnemigo.estaEnBordeDerecho()){
          game.removeTickEvent("derecha nave 2")
          self.cambiarDireccionIzquierdaConVelocidadANave2(unEnemigo,unaVelocidad)
        }
      })
  }
}

