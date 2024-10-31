import naves.*
import balas.*
import spawner.*
object nivel{
  const property nave = new Nave (salud = 3, image = "Nave_Full_Vida.png", position = game.at(0, 0))
  const spawner = new Spawner (cantidadDeEnemigosASpawnear = 50) 

  method nivel1(){
    game.addVisual(nave)
    spawner.iniciarSpawn()
    configuracion.controles()
  }
}

object configuracion{
  
  method controles(){
    keyboard.left().onPressDo({
      if (nivel.nave().position().x() > 0)
        nivel.nave().moverA(nivel.nave().position().left(1))
      })
    keyboard.right().onPressDo({
      if (nivel.nave().position().x() < game.width() - 1)
      nivel.nave().moverA(nivel.nave().position().right(1))
      })
    
    keyboard.space().onPressDo({
      nivel.nave().disparar()
    })
  }

}