import balas.*
class Nave {
  var property salud 
  var property image
  var property position
  var puedeDisparar = true

  method initialize(){
    self.controlarColision()
  }

  method disparar(){
    if (puedeDisparar) {
      game.addVisual(new Bala(position = game.at(self.position().x(), 1),image = "balaJugador.png"))
      self.habilitarCooldownDeDisparo()
    }
  }

  method puedeDisparar() = puedeDisparar
  
  method habilitarCooldownDeDisparo(){
    puedeDisparar = false
    game.schedule(1000, {=> puedeDisparar = true})
  }

  method controlarColision(){
    game.onTick(0, "colision", {
      if (not game.colliders(self).isEmpty()){
        game.uniqueCollider(self).eliminar()
        self.recibirDanio()
      }
    })
    
  }

  method recibirDanio(){
    salud = 0.max(salud - 1)
    self.morirSiNoTieneVidas()
  }

  method moverA(nuevaPosicion){
    position = nuevaPosicion
  }

  method morirSiNoTieneVidas(){
    if(salud == 0){
      game.removeVisual(self)
      game.stop()
    }
  }
}

class NaveEnemiga inherits Nave {

  method moverAbajo(){
    game.onTick(1500, "Mover Abajo", {=> self.moverA(self.position().down(1))})
  }

  override method disparar() {
    game.onTick(3000, "cadencia", {=> self.disparar()})
  }

  override method morirSiNoTieneVidas(){
    if(salud == 0){
      self.moverA(game.at(self.position().x(), 0 - game.height()))
      game.removeVisual(self)
    }
  }

  method eliminar(){
    game.removeVisual(self)
  }

  override method initialize(){
    super()
    self.disparar()
    self.moverAbajo()
  }

}

