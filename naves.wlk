class Nave {
  var salud 
  var property image
  var property position

  method disparar(){
    game.addVisual(new Bala(position = game.at(self.position().x(), 2),image = "balaJugador.png"))
  }

  method recibirDanio(){
    salud = 0.max(salud - 1)
    self.morirSiNoTieneVidas()
  }

  method removerOnTicks(){}

  method moverA(nuevaPosicion){
    position = nuevaPosicion
  }

  method morirSiNoTieneVidas(){
    if(salud == 0)
      game.removeVisual(self)
      self.moverA(game.at(50, 10))
  }

}

class NaveEnemiga inherits Nave {

  method moverAbajo(){
    game.onTick(1000, "Mover Abajo", {=> 
      if(self.position().y() > 0){
        self.moverA(self.position().down(1))
      }
      else{
        game.removeVisual(self)
        self.removerOnTicks()
      }
    })
    }

  override method removerOnTicks(){
      game.removeTickEvent("Mover Abajo")
      game.removeTickEvent("cadencia")
    }
  
  override method disparar(){
    game.addVisual(new BalaEnemiga(position = game.at(self.position().x(), self.position().y() - 1), image = "balaEnemigo.png"))
  }

  method cadenciaDeDisparo() {
    game.onTick(3000, "cadencia", {=> self.disparar()})
  }

  method initialize() {
    self.cadenciaDeDisparo()
  }
}

class Bala {
  var property position 
  const property image

  method inizialice(){self.moverYCorroborarColision()}

  method moverA(nuevaPosicion){
    position = nuevaPosicion
  }

  method eliminarSiColisiona(){
    if(not game.colliders(self).isEmpty())
      game.uniqueCollider(self).recibirDanio()
      game.removeVisual(self)
      self.moverA(game.at(50, 50))
  }

  method moverYCorroborarColision() {
    game.onTick(250, "Bala movible", {
      =>
      if (position.y() < game.height() - 1) {self.moverA(position.up(1))} else {game.removeVisual(self)}
      self.eliminarSiColisiona()
    })
}
  method recibirDanio(){}

  method initialize() {
    self.moverYCorroborarColision()
  }
}

class BalaEnemiga inherits Bala{
  override method moverYCorroborarColision() {
    game.onTick(250, "Bala movible", {
      =>
      if (position.y() >= 0) {self.moverA(position.down(1))} else {game.removeVisual(self)}
      
    })
    
  }

} 