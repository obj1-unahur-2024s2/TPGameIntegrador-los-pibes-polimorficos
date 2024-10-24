class Nave {
  var salud 
  var property image
  var property position

  method disparar(){
    game.addVisual(new Bala(position = game.at(self.position().x(), 2), danio = 1, image = "bala1.png"))

  }

  method recibirDanio(){
    salud = 0.max(salud - 1)
  }
  method moverA(nuevaPosicion){
    position = nuevaPosicion
  }
}

class NaveEnemiga inherits Nave {

  method moverAbajo(){
    game.onTick(400, "Mover Abajo", {=> 
      if(self.position().y() > 0){
        self.moverA(self.position().down(1))
      }
      else{
        game.removeVisual(self)
        game.removeTickEvent("Mover Abajo")
      }
    })
  }

  override method disparar(){}
}

class Bala {
  var property position 
  const danio  
  const property image
  

  method moverA(nuevaPosicion){
    position = nuevaPosicion
  }

  method mover() {
    game.onTick(300, "Bala movible", {
      =>
      if (position.y() < game.height() - 1) self.moverA(position.up(1)) else game.removeVisual(self)
    })
  }

  method initialize() {
    self.mover()
  }
  method impactar() {}
}

class BalaEnemiga inherits Bala{
  override method mover() {
    game.onTick(1000, "Bala movible", {
      =>
      if (position.y() < 0) self.moverA(position.down(1)) else game.removeVisual(self)
    })
  }
} 