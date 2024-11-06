import juego.*
object configuracion {

  method iniciarJuego(){
    keyboard.num1().onPressDo({juego.iniciarNivel1()})
    keyboard.num2().onPressDo({juego.iniciarNivel2()})
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

    keyboard.space().onPressDo({ unObjeto.crearBalaYDispararla()})

    keyboard.p().onPressDo({juego.limpiarJuego()})
  }

  method configurarColisionEn(unObjeto){
    game.onCollideDo(unObjeto, {colision => 
        unObjeto.recibirDanioDeYEliminarSiCorresponde(colision)
    })
  }
}