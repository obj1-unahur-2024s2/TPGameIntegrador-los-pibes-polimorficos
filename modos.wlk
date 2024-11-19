import sonidos.*
import juego.*
import naves.*
import interfaz.*

class Nivel {
  const property naves = []
  var siguiente = null
  const velocidadNavesEnemigas 
  const cadenciaNavesEnemigas
  const nroCartel

  method siguiente() = siguiente

  method cambiarSiguienteA(unValor){
    siguiente = unValor
  }

  method iniciar(){
    controladorDeImagenes.aparecerCartelDeNivel(nroCartel)
    game.schedule(5000, {
      self.quitarImagenDeCartelYConfigurar()
    })
  }

  method quitarImagenDeCartelYConfigurar(){
    controladorDeImagenes.quitarImagenes()
    self.configurar()
    juego.cambiarCantidadEnemigosVivosA(naves.size() - 1)
  }

  method configurar(){
    removedor.removerTodosLosOnTicks()
    self.agregarNaves()
    self.iniciarOnTicks()
  }

  method iniciarSiguiente(){
    juego.iniciarModo(self.siguiente())
  }

  method agregarNaves(){
    naves.forEach({nave =>
      game.addVisual(nave)
      nave.configurarseParaNivel()
    })
  }

  method iniciarOnTicks(){
    self.activarMovimientoDeLasBalas()
    self.activarDisparosNavesEnemigas()
    self.activarMovimientoNavesEnemigas()
  }

  method activarMovimientoDeLasBalas(){
    game.onTick(100, "movimiento de balas", {=>
      naves.forEach({nave => nave.actualizarBala()})
    })
  }

  method activarMovimientoNavesEnemigas(){
    game.onTick(velocidadNavesEnemigas, "movimiento enemigos", {=>
      naves.forEach({nave => nave.mover()})
    })
  }

  method activarDisparosNavesEnemigas(){
    game.onTick(cadenciaNavesEnemigas, "disparos enemigos", {=>
      generadorDeSonido.reproducirSonido("disparoLaser.mp3")
      naves.forEach({nave => nave.dispararAEnemigo()})
    })
  }

}

class ModoInfinito inherits Nivel (siguiente = self){
  var cantEnemigosPorSpawn = 1
  var cantEnemigosVivos = 0
  var nroOleada = 0

  override method iniciar(){
    juego.reiniciarValores()
    super()
  }

  override method quitarImagenDeCartelYConfigurar(){
    controladorDeImagenes.quitarImagenes()
    self.configurar()
  }

  override method configurar(){
    self.desactivarDisparosDeNavesEnemigas()
    self.reiniciarValoresModoInfinito()
    super()
    nroOleada += 1
  }

  override method agregarNaves(){
    self.agregarNaveAliada()
    self.agregarNavesEnemigas()
  }

  method desactivarDisparosDeNavesEnemigas(){
    const navesEnemigas = naves.subList(1, 8)

    navesEnemigas.forEach({nave => nave.desactivarPuedeDisparar()})
  }

  method agregarNaveAliada(){
    const naveAliada = naves.first()
    game.addVisual(naveAliada)
    naveAliada.configurarParaModoInfinitoEnY(0)
  }

  method agregarNavesEnemigas(){
    const navesEnemigas = naves.subList(1, cantEnemigosPorSpawn)
    var posicionY = 9
    navesEnemigas.forEach({nave =>
      game.addVisual(nave)
      nave.configurarParaModoInfinitoEnY(posicionY)
      cantEnemigosVivos += 1
      posicionY -= 1
    })
  }

  method reiniciarValoresModoInfinito(){
    self.reiniciarVariables()
    puntaje.reiniciarPuntaje()
  }

  method reiniciarVariables(){
    cantEnemigosPorSpawn = 1
    cantEnemigosVivos = 0
    nroOleada = 0
  }

  method disminuirCantidadEnemigosVivosYActualizar(){
    cantEnemigosVivos = 0.max(cantEnemigosVivos - 1)
    puntaje.aumentarPuntajeEn(1000)
    game.schedule(50,{self.actualizar()})
  }

  method actualizar(){
    if(cantEnemigosVivos == 0){
      nroOleada += 1
      self.otorgarVidasANaveAliada()
      self.actualizarCantidadDeEnemigosSiCorresponde()
      self.agregarNavesEnemigas()
    }
  }

  method otorgarVidasANaveAliada(){
    naves.get(0).aumentarVidasParaModoInfinito()
  }

  method actualizarCantidadDeEnemigosSiCorresponde(){
    if((nroOleada % 4) == 0){
      cantEnemigosPorSpawn = 8.min(cantEnemigosPorSpawn + 1)
    }
  }
}