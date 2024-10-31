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
    game.onTick(150, "Bala Movible aliada", { => 
    self.moverA(position.up(1))
    self.removerSiEsNecesario()
    })
  }

  method removerSiEsNecesario(){
    if (self.position().y() > game.height()){
      self.eliminar()
    }
  }

  method eliminar(){
    game.removeVisual(self)
    self.moverA(game.at(self.position().x(), game.height() + 1))
  }

  method puedeDaniarEnemigos() = true
}

class BalaEnemiga inherits Bala{
  override method habilitarMovimiento() {
    game.onTick(150, "Bala movible enemiga", { => 
      self.moverA(position.down(1))
      self.removerSiEsNecesario()
    }) 
  }

  override method puedeDaniarEnemigos() = false

  override method removerSiEsNecesario(){
    if (self.position().y() < 0){
      game.removeVisual(self)
      game.removeTickEvent("Bala Movible enemiga")
    }
  }
} 