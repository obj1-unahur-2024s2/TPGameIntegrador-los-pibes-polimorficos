import naves.*
import configuracion.*
object juego{
  var seInicioUnNivel = false
  var cantidadEnemigosVivos = 1

  method iniciarNivel(unNivel){
    if (not seInicioUnNivel){
      self.agregarNavesParaNivel(unNivel)
      self.controlDeEnemigos()
      console.println("se inicio el nivel " + unNivel)
      seInicioUnNivel = true 
    }
  }

  method controlDeEnemigos(){
    game.onTick(1000, "nivel", {=> 
      if (cantidadEnemigosVivos == 0){
        self.reiniciarJuego()
      }})
  }

  method desactivarSeInicioUnNivel(){
    seInicioUnNivel = false
  }

  method disminuirCantidadEnemigosVivos(){ 
    cantidadEnemigosVivos = 0.max(cantidadEnemigosVivos - 1)
  }

  method agregarNavesParaNivel(unNivel){
    const naves = self.listaDeNavesParaNivel(unNivel)
    cantidadEnemigosVivos = unNivel * 2
    naves.forEach({nave => 
      game.addVisual(nave) 
      nave.configurarParaNivel(unNivel)
    })
  }

  method listaDeNavesParaNivel(unNivel) = if(unNivel == 1){self.listaDeNavesDeNivel1()} 
                                          else {self.listaDeNavesDeNivel2()}
  

  method listaDeNavesDeNivel1() = [ new Nave (image = "Nave_Full_Vida.png",position = game.at(0, 0)),
      new NaveEnemiga (image = "naveEnemiga1.png", position = game.at(0, 9), nivel = 1, bordeIzq = 0, 
        bordeDer = 4, numeroDeNave = 1),
      new NaveEnemiga (image = "naveEnemiga1.png", position = game.at(9, 9), nivel = 1, bordeIzq = 5, 
        bordeDer = 9, numeroDeNave = 2)
    ]
  
  method listaDeNavesDeNivel2() = [ new Nave (image = "Nave_Full_Vida.png",position = game.at(0, 0)),
      new NaveEnemiga (image = "naveEnemiga1.png", position = game.at(0, 9), nivel = 2, bordeIzq = 0, 
        bordeDer = 4, numeroDeNave = 1),
      new NaveEnemiga (image = "naveEnemiga1.png", position = game.at(9, 9), nivel = 2, bordeIzq = 5, 
        bordeDer = 9, numeroDeNave = 2),
      new NaveEnemiga (image = "naveEnemiga1.png", position = game.at(5, 6), nivel = 2, bordeIzq = 5, 
        bordeDer = 9, numeroDeNave = 3),
      new NaveEnemiga (image = "naveEnemiga1.png", position = game.at(4, 6), nivel = 2, bordeIzq = 0, 
        bordeDer = 4, numeroDeNave = 4)
    ]


  method reiniciarJuego(){
    cantidadEnemigosVivos = 1
    console.println("la cantidad de enemigos vivos ahora es " + cantidadEnemigosVivos)
    self.desactivarSeInicioUnNivel()
    game.clear()
    configuracion.iniciarJuego()
  }
}

