import configuracion.*
import balas.*
import juego.*
class Nave {
  var salud = 0
  var  image = "Nave_Full_Vida.png"
  var  position = game.at(0, 0)
  var puedeDisparar = true
  const property balas = [] 

  method position() = position

  method image() = image

  method cambiarImagen(){
    image = "Nave_ConDanio.png"
    game.schedule(500, {=> image = "Nave_Full_Vida.png"})
  }

  method actualizarBalas(){
    balas.forEach({bala => bala.moverArribaYEliminarSiCorrespondeDeLaNaveDuenia()})
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
      //self.habilitarCooldownDeDisparo()
    }
  }

  method dispararAEnemigo(){}

  method habilitarCooldownDeDisparo(){
    puedeDisparar = false
    game.schedule(500, {=> puedeDisparar = true})
  }

  method recibirDanioDeYEliminarSiCorresponde(unObjeto){
    self.recibirDanio()
    unObjeto.desaparecerYEliminarseDeLaListaDeLaNaveDuenia()
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

  method eliminarOnTicks(){}

  method configurarParaNivel1(){
    salud = 3
    self.configurar()
    self.moverA(game.origin())
  }

  method configurarParaNivel2(){
    salud = 10
    self.configurar()
    self.moverA(game.origin())
  }

  method configurar(){
    configuracion.configurarColisionEn(self)
    configuracion.configurarControlesEn(self)
  }

  method mover() {}
}

class NaveEnemiga inherits Nave {
  var cadencia = 0
  const nivel = 1
  const bordeIzq
  const bordeDer
  const numeroDeNave
  const posicionInicial 
  var seTieneQueMoverADerecha = true
  
  override method cambiarImagen(){
    image = "naveEnemiga" + nivel + "_hit.png"
    game.schedule(500, {=> image = "naveEnemiga" + nivel + ".png"})
  }

  override method actualizarBalas(){
    balas.forEach({bala => bala.moverAbajoYEliminarSiCorrespondeDeLaNaveDuenia()})
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
    juego.disminuirCantidadEnemigosVivosYActualizar()
    modoInfinito.disminuirCantidadEnemigosVivosYActualizar()
    game.schedule(1200, {=> modoInfinito.naves().remove(self)})
    puedeDisparar = false
  }

  method nombreOnTickMov() = "movimiento nave " + numeroDeNave

  override method habilitarCooldownDeDisparo(){}

  override method configurarParaNivel1(){
    salud = 5
    cadencia = 2000
    self.configurar()
  }

  override method configurarParaNivel2(){
    salud = 10
    cadencia = 1000
    self.configurar()
  }

  override method configurar(){
    configuracion.configurarColisionEn(self)
    self.configurarImagenParaNivel(nivel)
    self.moverA(posicionInicial)
    puedeDisparar = true
    self.configurarMovimiento()
  }

  override method eliminarOnTicks(){
    game.removeTickEvent(self.nombreOnTickMov())
  }

  override method dispararAEnemigo(){
    self.crearBalaYDispararla()
  }
  
  method moverALaIzquierda(){
    self.moverA(self.position().left(1))
  }

  method moverALaDerecha(){
    self.moverA(self.position().right(1))
  }

  override method mover(){
    if(seTieneQueMoverADerecha){
      self.moverALaDerecha()
    }
    else{
      self.moverALaIzquierda()
    }
    self.actualizarVarMovimiento()
  }

  method actualizarVarMovimiento(){
    if(self.estaEnBordeDerecho() or self.estaEnBordeIzquierdo()){
      seTieneQueMoverADerecha = not seTieneQueMoverADerecha
    }
  }

  method estaEnBordeIzquierdo() = self.position().x() == bordeIzq

  method estaEnBordeDerecho() = self.position().x() == bordeDer

  method configurarParaModoInfinito(){
    salud = 5
    cadencia = 2000
    self.configurarImagenParaNivel(nivel)
    self.configurar()
  }

  method configurarImagenParaNivel(unNivel){
    image = "naveEnemiga" + unNivel + ".png"
  }

  method configurarMovimiento(){
    if(numeroDeNave.odd()){
      seTieneQueMoverADerecha = true
    }
    else{
      seTieneQueMoverADerecha = false
    }
  }
}