class Bala {
  var position 
  const property image

  method position() = position
  
  method moverA(nuevaPosicion){
    position = nuevaPosicion
  }

  method moverArriba(){
    position = self.position().up(1)
  }

  method moverAbajo(){
    position = self.position().down(1)
  }

  method desaparecer(){
    game.removeVisual(self)
  }
}