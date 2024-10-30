import naves.*
class Bala {
  var property position 
  const property image

  method initialize(){
    self.habilitarMovimiento()
  }

  method moverA(nuevaPosicion){
    position = nuevaPosicion
  }

  method habilitarMovimiento() {
    game.onTick(150, "Bala movible", { => self.moverA(position.up(1))})
  }

  method eliminar(){
    game.removeVisual(self)
  }
}

class BalaEnemiga inherits Bala{
  override method habilitarMovimiento() {
    game.onTick(150, "Bala movible", { => self.moverA(position.down(1))}) 
  }
} 