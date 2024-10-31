import naves.*
class Spawner {
  var cantidadDeEnemigosASpawnear 
  var cantidadEnemigosVivos = 0
  
  method crearNaveEnemiga1Con(salud, imagen, posicion){
    game.addVisual(new NaveEnemiga1 (salud = salud , image = imagen, position = posicion))
  }

  method crearNaveEnemiga2Con(salud, imagen, posicion){
    game.addVisual(new NaveEnemiga2 (salud = salud , image = imagen, position = posicion))
  }

  method spawnearNave1(){
    self.crearNaveEnemiga1Con(2, "naveEnemiga1.png", game.at(0.randomUpTo(game.width()- 1), 14))
  }

  method aumentarCantidadEnemigosVivos(){
    cantidadEnemigosVivos += 1
    console.println("" + cantidadEnemigosVivos)
  }

  method disminuirCantidadEnemigosVivos(){
    cantidadEnemigosVivos = 0.max(cantidadEnemigosVivos - 1)
    console.println("" + cantidadEnemigosVivos)
  }

  method iniciarSpawn(){
    game.onTick(1000, "Spawn", {=> 
      if (cantidadEnemigosVivos == 0){
        self.spawnearNave1()
        self.aumentarCantidadEnemigosVivos()
      }
    })
  }

}