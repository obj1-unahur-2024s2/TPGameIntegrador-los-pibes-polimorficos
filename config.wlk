import naves.*
import balas.*
import control.*
object nivel{
  const property naveEnemiga1 = new NaveEnemiga1 (salud = 3, image = "naveEnemiga1.png", 
    position = game.at(0, 9), cadencia = 2000)
  const property naveEnemiga2 = new NaveEnemiga2 (salud = 3, image = "naveEnemiga1.png", 
    position = game.at(9, 9), cadencia = 2000)
  const property nave = new Nave (salud = 3, image = "Nave_Full_Vida.png",position = game.at(0, 0))

  method iniciarNivel1(){
    self.agregarNaves()
    self.configurarMovimientoDeNivel1()
    configuracion.colisionesYControles()
  }

  method iniciarNivel2(){
    self.agregarNaves()
    self.configurarMovimientoDeNivel2()
    self.configurarNavesParaNivel2()
    configuracion.colisionesYControles()
  }

  method agregarNaves(){
    game.addVisual(nave)
    game.addVisual(naveEnemiga1)
    game.addVisual(naveEnemiga2)
  }

  method configurarNavesParaNivel2(){
    nave.configurarParaNivel2()
    naveEnemiga1.configurarParaNivel2()
    naveEnemiga2.configurarParaNivel2()
  }

  method configurarMovimientoDeNivel1(){
    control.cambiarDireccionDerechaConVelocidadANave1(naveEnemiga1, 4000)
    control.cambiarDireccionIzquierdaConVelocidadANave2(naveEnemiga2, 4000)
  }

  method configurarMovimientoDeNivel2(){
    control.cambiarDireccionDerechaConVelocidadANave1(naveEnemiga1, 2000)
    control.cambiarDireccionIzquierdaConVelocidadANave2(naveEnemiga2, 2000)
  }
}

object configuracion {
  
  method colisionesYControles(){
    self.controles()
    self.colisiones()
  }

  method controles(){
    keyboard.left().onPressDo({
      if (nivel.nave().position().x() > 0){
        nivel.nave().moverA(nivel.nave().position().left(1))
      }}
    )

    keyboard.right().onPressDo({
      if (nivel.nave().position().x() < game.width() - 1){
        nivel.nave().moverA(nivel.nave().position().right(1))
      }}
    )

    keyboard.space().onPressDo({
      nivel.nave().crearBalaYDispararla()
    }
    )
  }

  method colisiones(){
    
    game.onCollideDo(nivel.nave(), {colision => 
        nivel.nave().recibirDanio()
        colision.desaparecer()
    })

    game.onCollideDo(nivel.naveEnemiga1(), {colision => 
        colision.desaparecer()
        nivel.naveEnemiga1().recibirDanio()
    })

    game.onCollideDo(nivel.naveEnemiga2(), {colision => 
        colision.desaparecer()
        nivel.naveEnemiga2().recibirDanio()
    })
    
  }
}