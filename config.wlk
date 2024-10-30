import naves.*
import balas.*
object nivel{
  const property nave = new Nave (salud = 3, image = "Nave_Full_Vida.png", position = game.at(0, 0))
  const property naveEnemiga = new NaveEnemiga (salud = 10, image = "naveEnemiga1.png", position = game.at(0, 9))
  method nivel1(){
    game.addVisual(nave)
    game.addVisual(naveEnemiga)
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
      if (nivel.nave().position().x() < game.width() - 2)
      nivel.nave().moverA(nivel.nave().position().right(1))
      })
    
    keyboard.space().onPressDo({
      nivel.nave().disparar()
    })
  }

  
}