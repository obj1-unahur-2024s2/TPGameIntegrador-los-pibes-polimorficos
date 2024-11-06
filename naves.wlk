import control.*
import configuracion.*
import balas.*
import juego.*
class Nave {
  var salud = 0
  var  image = "Nave_Full_Vida.png"
  var  position 
  var puedeDisparar = true
  const property balas = [] 

  method initialize(){
    configuracion.configurarColisionEn(self)
    configuracion.configurarControlesEn(self)
  }

  method position() = position

  method image() = image

  method cambiarImagen(){
    image = "Nave_ConDanio.png"
    game.schedule(1000, {=> image = "Nave_Full_Vida.png"})
  }

  method actualizarBalas(){
    game.onTick(100, "disparos nave aliada", {=> 
      balas.forEach({bala => bala.moverArribaYEliminarSiCorrespondeDeLaNaveDuenia()})
    })
  }

  method nuevaBala() = new Bala(position = game.at(self.position().x(), 1),image = "balaJugador.png", 
    puedeDaniarNavesEnemigas = true, naveDuenia = self)

  method crearBalaYDispararla(){
    self.disparar(self.nuevaBala())
  }

  method disparar(unaBala){
    if (puedeDisparar) {
      game.addVisual(unaBala)
      balas.add(unaBala)
      self.habilitarCooldownDeDisparo()
    }
  }

  method habilitarCooldownDeDisparo(){
    puedeDisparar = false
    game.schedule(334, {=> puedeDisparar = true})
  }

  method recibirDanioDeYEliminarSiCorresponde(unObjeto){
    self.recibirDanio()
    unObjeto.desaparecerYEliminarseDeLaListaDeLaNaveDuenia()
    console.println("la salud de la nave aliada es " + salud)
  }

  method recibirDanio(){
    salud = 0.max(salud - 1)
    self.morirSiNoTieneVidas()
    self.cambiarImagen()
  }

  method moverA(nuevaPosicion){
    position = nuevaPosicion
  }

  method morirSiNoTieneVidas(){
    if(salud == 0){
      self.morir()
    }
  }

  method morir(){
    game.removeVisual(self)
    self.eliminarOnTicks()
    juego.limpiarJuego()
  }

  method eliminarOnTicks(){
    game.removeTickEvent("disparos nave aliada")
  }

  method configurarParaNivel1(){
    salud = 3
    self.actualizarBalas()
  }

  method configurarParaNivel2(){
    salud = 10
    self.actualizarBalas()
  }
}

class NaveEnemiga inherits Nave {
  var cadencia = 0
  const nivel 
  const bordeIzq
  const bordeDer
  const numeroDeNave
  
  override method initialize(){
    configuracion.configurarColisionEn(self)
  }
  
  override method cambiarImagen(){
    image = "naveEnemiga" + nivel + "_hit.png"
    game.schedule(1000, {=> image = "naveEnemiga" + nivel + ".png"})
  }

  override method actualizarBalas(){
    game.onTick(100, self.nombreOnTickDisparos(), {=> 
      balas.forEach({bala => bala.moverAbajoYEliminarSiCorrespondeDeLaNaveDuenia()})
    })
  }
  
  override method nuevaBala() = new Bala(position = game.at(self.position().x(), self.position().y() - 1)
  ,image = "balaEnemigo.png", puedeDaniarNavesEnemigas = false, naveDuenia = self)

  override method recibirDanioDeYEliminarSiCorresponde(unObjeto){
    if (unObjeto.puedeDaniarNavesEnemigas()){
      self.recibirDanio()
      unObjeto.desaparecerYEliminarseDeLaListaDeLaNaveDuenia()
    }
  }

  override method morir(){
    game.removeVisual(self)
    self.eliminarOnTicks()
    juego.disminuirCantidadEnemigosVivos()
  }

  method nombreOnTickCadencia() = "cadencia nave enemiga " + numeroDeNave

  method nombreOnTickMov() = "movimiento nave " + numeroDeNave

  method nombreOnTickDisparos() = "disparos nave enemiga " + numeroDeNave
  
  override method habilitarCooldownDeDisparo(){}

  override method configurarParaNivel1(){
    salud = 5
    cadencia = 2000
    image = "naveEnemiga1.png"
    self.configurarBalasDisparosYMovimiento()
    console.println("la nave enemiga tiene " + salud + " vidas")
  }

  override method configurarParaNivel2(){
    salud = 10
    cadencia = 1000
    image = "naveEnemiga2.png"
    self.configurarBalasDisparosYMovimiento()
    console.println("la nave enemiga tiene " + salud + " vidas")
  }

  method configurarBalasDisparosYMovimiento(){
    self.cadenciaDeDisparo()
    self.actualizarBalas()
    self.activarMovimientoParaNumeroDeNave(numeroDeNave)
  }

  override method eliminarOnTicks(){
    game.removeTickEvent(self.nombreOnTickCadencia())
    game.removeTickEvent(self.nombreOnTickMov())
    game.schedule(5000, {=> game.removeTickEvent(self.nombreOnTickDisparos())}) 
  }

  method activarMovimientoParaNumeroDeNave(unNumero){
    if(unNumero.odd()){
      control.cambiarDireccionDerechaConVelocidadANaveConNombre(self, 3000, self.nombreOnTickMov())
    }
    else{
      control.cambiarDireccionIzquierdaConVelocidadANaveConNombre(self, 3000, self.nombreOnTickMov())
    }
  }

  method cadenciaDeDisparo() {
    game.onTick(cadencia, self.nombreOnTickCadencia(), {=> self.crearBalaYDispararla()})
  }

  method moverALaIzquierda(){
    self.moverA(self.position().left(1))
  }

  method moverAbajo(){
    self.moverA(self.position().down(1))
  }

  method moverALaDerecha(){
    self.moverA(self.position().right(1))
  }

  method estaEnBordeIzquierdo() = self.position().x() == bordeIzq

  method estaEnBordeDerecho() = self.position().x() == bordeDer
}