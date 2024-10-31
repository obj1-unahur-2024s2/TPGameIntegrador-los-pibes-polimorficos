import naves.*
import balas.*
import spawner.*
object nivel{
  const property spawner = new Spawner (cantidadDeEnemigosASpawnear = 50) 

  method nivel1(){
    game.addVisual(nave)
    spawner.iniciarSpawn()
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