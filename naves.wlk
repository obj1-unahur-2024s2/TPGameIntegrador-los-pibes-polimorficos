import sonidos.*
import interfaz.*
import configuracion.*
import balas.*
import juego.*
class Nave {
  var salud = 0
  var  image = self.imagenNormalNivel(1)
  var  position = game.at(0, 0)
  var puedeDisparar = true
  const bala = new Bala(puedeDaniarNavesEnemigas = true)
  var nivel = 1

  method position() = position

  method image() = image

  method cambiarImagen(){
    const tiempoDeHit = 300
    image = self.imagenConDanioNivel(nivel)
    game.schedule(tiempoDeHit, {=> image = self.imagenNormalNivel(nivel)})
  }

  method cambiarNivelA(unNivel){
    nivel = unNivel
  }

  method imagenNormalNivel(unNivel) = "Nave_Full_Vida.png"

  method imagenConDanioNivel(unNivel) = "Nave_ConDanio.png"
  
  method actualizarBala(){
    bala.mover()
  }

  method crearBalaYDispararla(){
    self.crearBalaEnPosicion(position.up(1))
  }

  method crearBalaEnPosicion(unaPosicion){
    if (puedeDisparar and not bala.estaActiva()){
      self.dispararBalaEnPosicion(unaPosicion)
      self.generarSonidoDeBala()
    }
  }

  method generarSonidoDeBala(){
    generadorDeSonido.reproducirSonido("disparoLaser.mp3")
  }

  method dispararBalaEnPosicion(unaPosicion){
    bala.aparecerEn(unaPosicion)
    self.habilitarCooldownDeDisparo()
  }

  method dispararAEnemigo(){}

  method habilitarCooldownDeDisparo(){
    self.desactivarPuedeDisparar()
    game.schedule(1100, {=> self.activarPuedeDisparar()})
  }

  method desactivarPuedeDisparar(){
    puedeDisparar = false
  }

  method activarPuedeDisparar(){
    puedeDisparar = true
  }

  method recibirDanioDeYEliminarSiCorresponde(unObjeto){
    self.recibirDanio()
    unObjeto.desaparecer()
    self.disminuirVidasDeLaInterfaz()
  }

  method recibirDanio(){
    self.disminuirVidas()
    self.morirSiNoTieneVidas()
    self.cambiarImagen()
  }

  method disminuirVidas(){
    salud = 0.max(salud - 1)
    generadorDeSonido.reproducirSonido("sonidoHit.mp3")
  }

  method disminuirVidasDeLaInterfaz(){
    vidas.disminuirUnaVida()
  }

  method aumentarVidasParaModoInfinito(){
    salud = 5.min(salud + 3)
    vidas.cambiarVidasA(salud)
  }
  
  method moverA(nuevaPosicion){
    position = nuevaPosicion
  }

  method morirSiNoTieneVidas(){
    if(salud == 0){
      generadorDeSonido.reproducirSonido("muerteNave.mp3")
      self.morir()
    }
  }

  method morir(){
    juego.perder()
  }

  method configurarseParaNivel(){
    salud = 5.min(3 * nivel)
    self.configurarMoviendoA(game.origin())
  }

  method configurarParaModoInfinitoEnY(unaPosicionY){
    salud = 5
    self.configurarMoviendoA(game.origin())
  }

  method configurarMoviendoA(unaPosicion){
    configuracion.configurarColisionEn(self)
    self.configurarEnPosicion(unaPosicion)
  }

  method configurarEnPosicion(unaPosicion){
    configuracion.configurarControlesEn(self)
    self.moverA(unaPosicion)
    self.activarPuedeDisparar()
    vidas.aparecerConCantidadDeVidas(salud)
  }

  method mover(){}

}

class NaveEnemiga inherits Nave (bala = new BalaEnemiga(puedeDaniarNavesEnemigas = false)){
  const bordeIzq
  const bordeDer
  const posicionInicial = game.at(9, 9)
  var seTieneQueMoverADerecha = true
  var sePuedeMover = false

  override method imagenNormalNivel(unNivel) = "naveEnemiga" + unNivel + ".png"

  override method imagenConDanioNivel(unNivel) = "naveEnemiga" + unNivel + "_hit.png"

  override method recibirDanioDeYEliminarSiCorresponde(unObjeto){
    if (unObjeto.puedeDaniarNavesEnemigas()){
      super(unObjeto)
    }
  }

  override method disminuirVidasDeLaInterfaz(){}

  override method morir(){
    self.desactivarPuedeDisparar()
    game.removeVisual(self)
    self.quitarseDelModoCorrespondiente()
    sePuedeMover = false
  }

  method quitarseDelModoCorrespondiente(){
    if(juego.seEstaJugandoUnNivel()){
      juego.disminuirCantidadEnemigosVivosYActualizar()
    }
    else{
      juego.modoInfinito().disminuirCantidadEnemigosVivosYActualizar()
    }
  }

  override method habilitarCooldownDeDisparo(){}

  override method configurarseParaNivel(){
    salud = 7.min(3 * nivel)
    self.configurarMoviendoA(posicionInicial)
    self.configurarMovimiento()
  }
  
  override method configurarEnPosicion(unaPosicion){
    self.configurarImagenParaNivel(nivel)
    self.moverA(unaPosicion)
    self.activarPuedeDisparar()
    sePuedeMover = true
  }

  method configurarMovimiento(){
    if(position.x() < bordeDer){
      seTieneQueMoverADerecha = true
    }
    else{
      seTieneQueMoverADerecha = false
    }
  }
  
  override method configurarParaModoInfinitoEnY(unaPosicionY){
    salud = 2.randomUpTo(4).truncate(0)
    self.cambiarNivelA([1,2].anyOne())
    self.configurarParaModoInfinitoMoviendoA(game.at(0.randomUpTo(9).truncate(0), unaPosicionY))
  }

  method configurarParaModoInfinitoMoviendoA(unaPosicion){
    self.configurarMoviendoA(unaPosicion)
    self.configurarMovimientoModoInfinito()
  }

  method configurarMovimientoModoInfinito(){
    if(position.x() < 5){
      seTieneQueMoverADerecha = true
    }
    else{
      seTieneQueMoverADerecha = false
    }
  }

  override method dispararAEnemigo(){
    self.crearBalaYDispararla()
  }

  override method crearBalaYDispararla(){
    self.crearBalaEnPosicion(position)
  }

  override method generarSonidoDeBala(){}
  
  method moverALaIzquierda(){
    self.moverA(position.left(1))
  }

  method moverALaDerecha(){
    self.moverA(position.right(1))
  }

  override method mover(){
    if(sePuedeMover){
      self.moverASiguienteUbicacion()
    }
  }

  method moverASiguienteUbicacion(){
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

  method estaEnBordeIzquierdo() = position.x() == bordeIzq

  method estaEnBordeDerecho() = position.x() == bordeDer


  method configurarImagenParaNivel(unNivel){
    image = "naveEnemiga" + unNivel + ".png"
  }

}