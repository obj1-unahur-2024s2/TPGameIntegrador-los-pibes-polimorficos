import interfaz.*
import juego.*
import sonidos.*
object configuracion {

  method configurarTeclasDeNivelesYMenu(){
    keyboard.num1().onPressDo({juego.iniciarNivel1()})
    keyboard.num2().onPressDo({juego.iniciarNivel2()})
    keyboard.num3().onPressDo({juego.iniciarNivel3()})
    keyboard.num4().onPressDo({juego.iniciarModoInfinito()})
    keyboard.r().onPressDo({controladorDeImagenes.iniciar()})
  }

  method configurarTeclasDeSonido(){
    keyboard.up().onPressDo({generadorDeSonido.aumentarVolumenDeMusicaDeFondo()})
    keyboard.down().onPressDo({generadorDeSonido.disminuirVolumenDeMusicaDeFondo()})
    keyboard.p().onPressDo({generadorDeSonido.alternarMusicaDeFondo()})
  }

  method configurarControlesEn(unObjeto){
    keyboard.left().onPressDo({
      if (unObjeto.position().x() > 0){
        unObjeto.moverA(unObjeto.position().left(1))
      }}
    )

    keyboard.right().onPressDo({
      if (unObjeto.position().x() < game.width() - 1){
        unObjeto.moverA(unObjeto.position().right(1))
      }}
    )

    keyboard.space().onPressDo({ 
      unObjeto.crearBalaYDispararla()
    })
  }

  method configurarColisionEn(unObjeto){
    game.onCollideDo(unObjeto, {colision => 
      unObjeto.recibirDanioDeYEliminarSiCorresponde(colision)
    })
  }
}