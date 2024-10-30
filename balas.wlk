import naves.*
class Bala {
  var property position 
  const property image
  var puedeHacerDanio = true

  method initialize(){
    self.moverYCorroborarColision()
  }

  method moverA(nuevaPosicion){
    position = nuevaPosicion
  }

  method puedeHacerDanio() = puedeHacerDanio

  method hacerDanioSiEstaColisionando(){
    if(not game.colliders(self).isEmpty() and puedeHacerDanio){
      game.uniqueCollider(self).colisionar()
      self.colisionar()
    }
  }

  method moverYCorroborarColision() {
    game.onTick(150, "Bala movible", { =>
      if (position.y() < game.height() - 1){
        self.moverA(position.up(1))
      } 
      else {
        game.removeVisual(self)
      }
      self.hacerDanioSiEstaColisionando()
    })
  }

  method colisionar(){
    game.removeVisual(self)
    puedeHacerDanio = false
  }

}

class BalaEnemiga inherits Bala{
  override method moverYCorroborarColision() {
    game.onTick(200, "Bala movible", { =>
      if (position.y() >= 0) {
        self.moverA(position.down(1))
      } 
      else {
        game.removeVisual(self)
      }
      self.hacerDanioSiEstaColisionando()
    }) 
  }
} 