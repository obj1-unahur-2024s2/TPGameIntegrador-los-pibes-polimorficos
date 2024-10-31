import naves.*
class Spawner {
  var cantidadDeEnemigosASpawnear 
  var cantidadDeEnemigosPorSpawn = 1
  
  method crearNaveEnemiga1Con(salud, imagen, posicion){
    game.addVisual(new NaveEnemiga1 (salud = salud , image = imagen, position = posicion))
  }

  method crearNaveEnemiga2Con(salud, imagen, posicion){
    game.addVisual(new NaveEnemiga2 (salud = salud , image = imagen, position = posicion))
  }

  method spawnearNave1(){
    self.crearNaveEnemiga1Con(2, "naveEnemiga1.png", game.at(0.randomUpTo(game.width()- 1), 14))
  }

  method iniciarSpawn(){
    game.onTick(5000, "Spawn", {=> self.spawnearNave1()})
  }

  method aumentarCantidadDeEnemigosQueSpawnean(){
    game.schedule(20000, {=> cantidadDeEnemigosPorSpawn += 1})
  }

}