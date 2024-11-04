object control{
  method cambiarDireccionIzquierdaConVelocidadANaveConNombre(unEnemigo, unaVelocidad, unNombre){
    game.onTick((1000..unaVelocidad).anyOne(), unNombre, {
      unEnemigo.moverALaIzquierda()
        if (unEnemigo.estaEnBordeIzquierdo()){
          game.removeTickEvent(unNombre)
          self.cambiarDireccionDerechaConVelocidadANaveConNombre(unEnemigo, unaVelocidad, unNombre)
        }
      })
  }

  method cambiarDireccionDerechaConVelocidadANaveConNombre(unEnemigo,unaVelocidad, unNombre){
    game.onTick((1000..unaVelocidad).anyOne(), unNombre, {
      unEnemigo.moverALaDerecha()
        if (unEnemigo.estaEnBordeDerecho()){
          game.removeTickEvent(unNombre)
          self.cambiarDireccionIzquierdaConVelocidadANaveConNombre(unEnemigo, unaVelocidad, unNombre)
        }
      })
  }
}

