class Nave {
  var salud 
  var property image
  var property position

  method disparar(){}

  method morir(){
    game.removeVisual(self)
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
        self.morir()
        game.removeTickEvent("Mover Abajo")
      }
    })
  }

  override method disparar(){}
}