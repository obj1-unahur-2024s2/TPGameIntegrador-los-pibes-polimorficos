import naves.*
import balas.*
import control.*
object nivel{
  const naveEnemiga1 = new NaveEnemiga1 (salud = 20, image = "naveEnemiga1.png", position = game.at(0, 14))
  const naveEnemiga2 = new NaveEnemiga2 (salud = 20, image = "naveEnemiga1.png", position = game.at(9, 14))
  method nivel1(){
    game.addVisual(nave)
    game.addVisual(naveEnemiga1)
    game.addVisual(naveEnemiga2)
    controlNave1.cambiarDireccionDerecha(naveEnemiga1)
    controlNave2.cambiarDireccionIzquierda(naveEnemiga2)
    configuracion.controles()
  } 
}

object configuracion {
  
  method controles(){
    keyboard.left().onPressDo({
      if (nave.position().x() > 0){
        nave.moverA(nave.position().left(1))
      }}
    )

    keyboard.right().onPressDo({
      if (nave.position().x() < game.width() - 1){
        nave.moverA(nave.position().right(1))
      }}
    )

    keyboard.space().onPressDo({
      nave.disparar()
    }
    )
  }
}