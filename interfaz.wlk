import configuracion.*
import juego.*
object controladorDeImagenes {
  //frames del menu
  const frame1 = new Frame (image = "menuFrame1.png")
  const frame2 = new Frame (image = "menuFrame2.png")
  const frame3 = new Frame (image = "menuFrame3.png")
  const frame4 = new Frame (image = "menuFrame4.png")

  //carteles grandes
  const menu = new Menu()
  const cartelNivel = new CartelGrande()

  //carteles chicos
  const cartelChico = new CartelChico()

  method iniciar(){
    juego.limpiarJuego()
    self.agregarMenuYFrames()
  }

  method agregarMenuYFrames(){
    self.asignarSiguientesALosFrames()
    menu.cambiarImagenA(frame1)
    menu.aparecer()
  }
  
  method asignarSiguientesALosFrames(){
    frame1.asignarSiguiente(frame2)
    frame2.asignarSiguiente(frame3)
    frame3.asignarSiguiente(frame4)
    frame4.asignarSiguiente(frame1)
  }

  method quitarImagenes(){
    menu.desaparecer()
    cartelNivel.desaparecer()
    cartelChico.desaparecer()
  }

  method aparecerCartelDeNivel(unValor){
    game.clear()
    configuracion.configurarTeclasDeNivelesYMenu()
    configuracion.configurarTeclasDeSonido()
    cartelNivel.cambiarImagenA("cartelNivel" + unValor + ".png")
    cartelNivel.aparecer()
  }

  method aparecerCartelChicoConImagen(unaImagen){
    cartelChico.cambiarImagenA(unaImagen)
    cartelChico.aparecer()
  }
}

class CartelChico {
  var imagen = null

  method position() = game.at(3,5)

  method image() = imagen

  method cambiarImagenA(unaImagen){
    imagen = unaImagen
  }

  method aparecer(){
    game.addVisual(self)
  }

  method desaparecer(){
    game.removeVisual(self)
  }
}

class CartelGrande inherits CartelChico {

  override method position() = game.at(1,1)
}

class Menu inherits CartelGrande(){

  override method image() = imagen.image()

  override method aparecer(){
    super()
    self.iniciarAnimacion()
  }

  override method desaparecer(){
    super()
    game.removeTickEvent("animacion menu")
  }

  method iniciarAnimacion(){
    game.onTick(500, "animacion menu", {=> self.cambiarFotograma()})
  }

  method cambiarFotograma(){
    imagen = imagen.siguiente()
  }
}

class Frame{
  const property image
  var siguiente = null

  method asignarSiguiente(unValor){
    siguiente = unValor
  }

  method siguiente() = siguiente
}

object puntaje {
  var puntaje = 0
  var bonus = 0
  var texto = ""
  var posicion = game.at(9, 10)

  method text() = texto + puntaje

  method position() = posicion

  method reiniciarPuntaje(){
    puntaje = 0
    bonus = 0
    self.moverA(game.at(9, 10))
    self.cambiarTextoA("")
    game.addVisual(self)
  }

  method moverA(unaPosicion){
    posicion = unaPosicion
  }
  
  method cambiarTextoA(unTexto){
    texto = "" + unTexto
  }

  method aumentarPuntajeEn(unaCantidad){
    puntaje += unaCantidad + bonus
    bonus += 50
  }

  method textColor() = "FFFFFF"

  method mostrarPuntajeObtenido(){
    self.moverA(game.at(4, 4))
    self.cambiarTextoA("             Puntaje: ")
    game.addVisual(self)
  }
}

object vidas {
  var vidasActuales = 3

  method image() = "cartelCon" + vidasActuales + "Vidas.png"

  method position() = game.at(0, 10)

  method aparecerConCantidadDeVidas(unaCantidad){
    self.cambiarVidasA(unaCantidad)
    game.addVisual(self)
  }

  method disminuirUnaVida(){
    vidasActuales = 1.max(vidasActuales - 1)
  }

  method cambiarVidasA(unaCantidad){
    vidasActuales = 5.min(unaCantidad)
  }
}