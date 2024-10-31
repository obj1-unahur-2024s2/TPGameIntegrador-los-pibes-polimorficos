import config.*
import balas.*
object nave {
  //la hice objeto ya que en la nave enemiga se hace override de casi todos los metodos
  var property salud = 3
  var property image = "Nave_Full_Vida.png"
  var property position = game.at(0, 0)
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
        self.recibirDanio()
        game.uniqueCollider(self).eliminar()
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

  method eliminar(){}

  method puedeDaniarEnemigos() = false
}

class NaveEnemiga1 {
  var property salud 
  var property image 
  var property position 

  method initialize(){
    self.controlarColision()
    self.cadenciaDeDisparo()
    self.moverAbajo()
  }

  method moverAbajo(){
    game.onTick(2000, "Mover Abajo", {=> 
      self.moverA(self.position().down(1))
      self.removerOnTicksYMoverFueraDelTableroSiEsNecesario()
    })
  }

  method cadenciaDeDisparo() {
    game.onTick(3000, "cadencia", {=> self.disparar()})
  }

  method disparar(){
    game.addVisual(new BalaEnemiga(position = game.at(self.position().x(), self.position().y() - 1),
      image = "balaEnemigo.png"))
  }

  method morirSiNoTieneVidas(){
    if(salud == 0){
      game.removeVisual(self)
      self.removerOnTicksYMoverFueraDelTableroSiEsNecesario()
    }
  }

    method moverA(nuevaPosicion){
    position = nuevaPosicion
  }

  method eliminar(){
    game.removeVisual(self)
  }


  method controlarColision(){
    game.onTick(0, "colision", {
      if (not game.colliders(self).isEmpty() and game.uniqueCollider(self).puedeDaniarEnemigos()){
        game.uniqueCollider(self).eliminar()
        self.recibirDanio()
      }
    })
  }

  method recibirDanio(){
    salud = 0.max(salud - 1)
    self.morirSiNoTieneVidas()
  }

  method removerOnTicksYMoverFueraDelTableroSiEsNecesario(){
    if (salud == 0 or self.position().y() <= 0){
      self.moverA(game.at(0, game.height() - 1))
      nivel.spawner().disminuirCantidadEnemigosVivos()
      game.removeTickEvent("colision")
      game.removeTickEvent("cadencia")
      game.removeTickEvent("Mover Abajo")
    }
  }

  method puedeDaniarEnemigos() = false
}

class NaveEnemiga2 inherits NaveEnemiga1{

  override method cadenciaDeDisparo() {
    game.onTick(2000, "cadencia", {=> self.disparar()})
  }
}

