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
      //self.habilitarCooldownDeDisparo()
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
        self.colisionar()
      }
    })
  }

  method colisionar(){
    game.uniqueCollider(self).eliminar()
    self.recibirDanio()
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

  method puedeDaniarEnemigos() = false
}

class NaveEnemiga1 {
  var property salud 
  var property image 
  var property position 

  method initialize(){
    self.controlarColision()
    self.cadenciaDeDisparo()
  }

  method controlarColision(){
    game.onTick(0, "colision nave enemiga 1", {
      if (not game.colliders(self).isEmpty()){
        self.colisionar()
      }
    })
  }

  method colisionar(){
    game.uniqueCollider(self).eliminar()
    self.recibirDanio()
  }

  method recibirDanio(){
    salud = 0.max(salud - 1)
    self.morirSiNoTieneVidas()
  }

  method cadenciaDeDisparo() {
    game.onTick(3000, "cadencia nave enemiga 1", {=> self.disparar()})
  }

  method disparar(){
    game.addVisual(new BalaEnemiga(position = game.at(self.position().x(), self.position().y() - 1),
      image = "balaEnemigo.png"))
  }

  method morirSiNoTieneVidas(){
    if(salud == 0){
      game.removeVisual(self)
      game.removeTickEvent("cadencia nave enemiga 1")
    }
  }

  method moverALaIzquierda(){
    position = self.position().left(1)
  }

  method moverALaDerecha(){
    position = self.position().right(1)
  }

  method estaEnBordeIzquierdo() = self.position().x() == 0

  method estaEnBordeDerecho() = self.position().x() == 4
}

class NaveEnemiga2 inherits NaveEnemiga1{

  override method cadenciaDeDisparo() {
    game.onTick(2000, "cadencia nave enemiga 2", {=> self.disparar()})
  }

  override method estaEnBordeIzquierdo() = self.position().x() == 5

  override method estaEnBordeDerecho() = self.position().x() == game.width() - 1
}

