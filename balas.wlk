import naves.*
class Bala {
  var position = game.at(0, 0)
  const property image = "balaJugador.png"
  const property puedeDaniarNavesEnemigas
  var estaActiva = false

  method position() = position

  method estaActiva() = estaActiva

  method moverA(nuevaPosicion){
    position = nuevaPosicion
  }

  method mover(){
    if (self.position().y() < game.height()){
      position = self.position().up(1)
    }
    else{
      self.desaparecer()
    }
  }

  method aparecerEn(unaPosicion){
    self.moverA(unaPosicion)
    game.addVisual(self)
    estaActiva = true
  }

  method desaparecer(){
    if(estaActiva){
      game.removeVisual(self)
      estaActiva = false
    }
  }
}

class BalaEnemiga inherits Bala (image = "balaEnemigo.png"){
  
  override method mover(){
    if (self.position().y() >= 0){
      position = self.position().down(1)
    }
    else{
      self.desaparecer()
    }
  }
}