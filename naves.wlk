import control.*
import configuracion.*
import balas.*
import juego.*
class Nave {
  var salud = 0
  var  image 
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
    salud = 0.max(salud - 1)
    unObjeto.desaparecerYEliminarseDeLaListaDeLaNaveDuenia()
    console.println("la salud de la nave aliada es " + salud)
    self.morirSiNoTieneVidas()
    self.cambiarImagen()
  }

  method moverA(nuevaPosicion){
    position = nuevaPosicion
  }

  method morirSiNoTieneVidas(){
    if(salud == 0){
      console.println("mori")
      game.removeVisual(self)
      game.removeTickEvent("disparos nave aliada")
      juego.reiniciarJuego()
    }
  }

  method configurarParaNivel(unNivel){
    if (unNivel == 1){
      self.configurarParaNivel1()
    }
    else{
      self.configurarParaNivel2()
    }
  }

  method configurarParaNivel1(){
    salud = 3
    console.println("la nave aliada tiene " + salud + " vidas")
    self.actualizarBalas()
  }

  method configurarParaNivel2(){
    salud = 10
    console.println("la nave aliada tiene " + salud + " vidas")
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
      salud = 0.max(salud - 1)
      unObjeto.desaparecerYEliminarseDeLaListaDeLaNaveDuenia()
      console.println("la salud de la nave enemiga que recibio daño es " + salud)
      self.morirSiNoTieneVidas()
      self.cambiarImagen()
    }
  }

  override method morirSiNoTieneVidas(){
    if(salud == 0){
      game.removeVisual(self)
      self.removerOnTicks(self.nombreOnTickCadencia(), self.nombreOnTickMov(), self.nombreOnTickDisparos())
      juego.disminuirCantidadEnemigosVivos()
    }
  }

  method nombreOnTickCadencia() = "cadencia nave enemiga " + numeroDeNave

  method nombreOnTickMov() = "movimiento nave " + numeroDeNave

  method nombreOnTickDisparos() = "disparos nave enemiga " + numeroDeNave
  
  override method habilitarCooldownDeDisparo(){}

  override method configurarParaNivel1(){
    self.configuracionNivel1ParaNumeroDeNave(numeroDeNave)
    console.println("la nave enemiga tiene " + salud + " vidas")
  }

  override method configurarParaNivel2(){
    self.configuracionNivel2ParaNumeroDeNave(numeroDeNave)
    console.println("la nave enemiga tiene " + salud + " vidas")
  }

  method removerOnTicks(candencia,movimiento,disparos){
    game.removeTickEvent(candencia)
    game.removeTickEvent(movimiento)
    console.println("murio una nave enemiga")
    console.println("se elimino el movimiento de una nave enemiga")
    game.schedule(5000, {=> game.removeTickEvent(disparos)}) 
  }

  method configuracionNivel1ParaNumeroDeNave(unNumero){
    salud = 5
    cadencia = 2000
    self.cadenciaDeDisparo()
    self.actualizarBalas()
    self.activarMovimientoParaNumeroDeNave(unNumero)
  }

  method activarMovimientoParaNumeroDeNave(unNumero){
    if(unNumero.odd()){
      control.cambiarDireccionDerechaConVelocidadANaveConNombre(self, 3000, self.nombreOnTickMov())
    }
    else{
      control.cambiarDireccionIzquierdaConVelocidadANaveConNombre(self, 3000, self.nombreOnTickMov())
    }
  }

  method configuracionNivel2ParaNumeroDeNave(unNumero){
    salud = 10
    cadencia = 1000
    image = "naveEnemiga2.png"
    self.cadenciaDeDisparo()
    self.actualizarBalas()
    self.activarMovimientoParaNumeroDeNave(unNumero)
  }

  method cadenciaDeDisparo() {
    game.onTick(cadencia, self.nombreOnTickCadencia(), {=> self.crearBalaYDispararla()})
  }

  method moverALaIzquierda(){
    self.moverA(self.position().left(1))
  }

  method moverALaDerecha(){
    self.moverA(self.position().right(1))
  }

  method estaEnBordeIzquierdo() = self.position().x() == bordeIzq

  method estaEnBordeDerecho() = self.position().x() == bordeDer
}