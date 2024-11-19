import sonidos.*
import interfaz.*
import naves.*
import configuracion.*
import modos.*
object juego{
  var cantidadEnemigosVivos = 1
  var seEstaJugandoUnNivel = false
  var modoActual = null

  const nivel1 = new Nivel(naves = [ new Nave (),
    new NaveEnemiga (bordeIzq = 0, bordeDer = 4, posicionInicial = game.at(0, 9)),
    new NaveEnemiga (bordeIzq = 5, bordeDer = 9, posicionInicial = game.at(9, 9))
  ], velocidadNavesEnemigas = 2200, cadenciaNavesEnemigas = 2000, nroCartel = 1)

  const nivel2 = new Nivel (naves = [ new Nave (nivel = 2),
    new NaveEnemiga (nivel = 2, bordeIzq = 0, bordeDer = 4, posicionInicial = game.at(0, 9)),
    new NaveEnemiga (nivel = 2, bordeIzq = 5, bordeDer = 9, posicionInicial = game.at(9, 9)),
    new NaveEnemiga (nivel = 2, bordeIzq = 5, bordeDer = 9, posicionInicial = game.at(5, 6)),
    new NaveEnemiga (nivel = 2, bordeIzq = 0, bordeDer = 4, posicionInicial = game.at(4, 6))
  ], velocidadNavesEnemigas = 2000, cadenciaNavesEnemigas = 1700, nroCartel = 2)

  const nivel3 = new Nivel (naves = [ new Nave (nivel = 3),
    new NaveEnemiga (nivel = 1, bordeIzq = 0, bordeDer = 4, posicionInicial = game.at(0, 9)),
    new NaveEnemiga (nivel = 1, bordeIzq = 5, bordeDer = 9, posicionInicial = game.at(9, 9)),
    new NaveEnemiga (nivel = 2, bordeIzq = 5, bordeDer = 9, posicionInicial = game.at(5, 7)),
    new NaveEnemiga (nivel = 2, bordeIzq = 0, bordeDer = 4, posicionInicial = game.at(4, 7)),
    new NaveEnemiga (nivel = 3, bordeIzq = 0, bordeDer = 9, posicionInicial = game.at(3, 5)),
    new NaveEnemiga (nivel = 3, bordeIzq = 0, bordeDer = 9, posicionInicial = game.at(6, 4))
  ], velocidadNavesEnemigas = 1800, cadenciaNavesEnemigas = 1500, nroCartel = 3)

  const property modoInfinito = new ModoInfinito (naves = [ new Nave (),
    new NaveEnemiga (bordeIzq = 0, bordeDer = 9),
    new NaveEnemiga (bordeIzq = 0, bordeDer = 9),
    new NaveEnemiga (bordeIzq = 0, bordeDer = 9),
    new NaveEnemiga (bordeIzq = 0, bordeDer = 9),
    new NaveEnemiga (bordeIzq = 0, bordeDer = 9),
    new NaveEnemiga (bordeIzq = 0, bordeDer = 9),
    new NaveEnemiga (bordeIzq = 0, bordeDer = 9),
    new NaveEnemiga (bordeIzq = 0, bordeDer = 9)
  ], velocidadNavesEnemigas = 2200, cadenciaNavesEnemigas = 2000, nroCartel = 4)

  method initialize(){
    nivel1.cambiarSiguienteA(nivel2)
    nivel2.cambiarSiguienteA(nivel3)
    nivel3.cambiarSiguienteA(controladorDeImagenes)
  }

  method seEstaJugandoUnNivel() = seEstaJugandoUnNivel

  method modoActual() = modoActual

  method iniciarNivel1(){
    self.iniciarModo(nivel1)
  }
  
  method iniciarNivel2(){
    self.iniciarModo(nivel2)
  }

  method iniciarNivel3(){
    self.iniciarModo(nivel3)
  }

  method iniciarModoInfinito(){
    self.iniciarModo(modoInfinito)
  }

  method iniciarModo(unModo){
    game.clear()
    configuracion.configurarTeclasDeSonido()
    seEstaJugandoUnNivel = true
    unModo.iniciar()
    modoActual = unModo
  }

  method actualizar(){
    if (cantidadEnemigosVivos == 0 and seEstaJugandoUnNivel){
      self.ganar()
    }
  }

  method ganar(){
    self.limpiarTableroYAparecerCartel("ganaste.png")
    generadorDeSonido.reproducirSonido("sonidoVictoria.mp3")
    game.schedule(5000,{
      generadorDeSonido.volverVolumenDeMusicaALaNormalidad()
      modoActual.iniciarSiguiente()
    })
  }

  method perder(){
    self.limpiarTableroYAparecerCartel("gameOver.png")
    self.mostrarPuntajeSiEsNecesario()
    generadorDeSonido.reproducirSonido("sonidoDerrota.mp3")
    game.schedule(5000,{
      generadorDeSonido.volverVolumenDeMusicaALaNormalidad()
      self.iniciarModo(self.modoActual())
    })
  }

  method mostrarPuntajeSiEsNecesario(){
    if(not seEstaJugandoUnNivel){
      puntaje.mostrarPuntajeObtenido()
    }
  }

  method cambiarCantidadEnemigosVivosA(unaCantidad){ 
    cantidadEnemigosVivos = unaCantidad
  }

  method disminuirCantidadEnemigosVivosYActualizar(){ 
    cantidadEnemigosVivos = 0.max(cantidadEnemigosVivos - 1)
    self.actualizar()
  }

  method limpiarTableroYAparecerCartel(unCartel){
    game.clear()
    generadorDeSonido.bajarVolumenDeMusicaAlMinimo()
    controladorDeImagenes.aparecerCartelChicoConImagen(unCartel)
  }

  method limpiarJuego(){
    self.reiniciarValores()
    game.clear()
    configuracion.configurarTeclasDeNivelesYMenu()
    configuracion.configurarTeclasDeSonido()
  }

  method reiniciarValores(){
    cantidadEnemigosVivos = 1
    removedor.removerTodosLosOnTicks()
    seEstaJugandoUnNivel = false
  }
}

object removedor {

  method removerTodosLosOnTicks(){
    game.removeTickEvent("movimiento de balas")
    game.removeTickEvent("disparos enemigos")
    game.removeTickEvent("movimiento enemigos")
    game.removeTickEvent("animacion menu")
  }
}