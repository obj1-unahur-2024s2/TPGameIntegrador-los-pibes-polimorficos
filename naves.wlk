import balas.*
class Nave {
  //la hice objeto ya que en la nave enemiga se hace override de casi todos los metodos
  var salud 
  var  image 
  var  position 
  var puedeDisparar = true
  const balas = [] 

  method initialize(){
    self.actualizarBalas()
  }

  method position() = position

  method image() = image

  method imagenNormal() = "Nave_Full_Vida.png"
  method imagenDaniada() = "Nave_ConDanio.png"

  method cambiarImagen(){
    image = self.imagenDaniada()
    game.schedule(2000, {=> image = self.imagenNormal()})
  }

  method actualizarBalas(){
    game.onTick(150, "disparos nave aliada", {=> 
      balas.forEach({bala => 
        if (bala.position().y() < game.height()){
          bala.moverArriba()
        }
        else{
          bala.desaparecer()
          balas.remove(bala)
          console.println("desaparecio una bala aliada")
        }
    })})
  }

  method nuevaBala() = new Bala(position = game.at(self.position().x(), 1),image = "balaJugador.png")

  method crearBalaYDispararla(){
    self.disparar(self.nuevaBala())
  }

  method disparar(unaBala){
    if (puedeDisparar) {
      game.addVisual(unaBala)
      balas.add(unaBala)
      //self.habilitarCooldownDeDisparo()
    }
  }

  method habilitarCooldownDeDisparo(){
    puedeDisparar = false
    game.schedule(1200, {=> puedeDisparar = true})
  }

  method recibirDanio(){
    salud = 0.max(salud - 1)
    console.println("la salud de la nave aliada es " + salud)
    self.morirSiNoTieneVidas()
    self.cambiarImagen()
  }

  method moverA(nuevaPosicion){
    position = nuevaPosicion
  }

  method morirSiNoTieneVidas(){
    if(salud == 0){
      console.println("mori")
      game.removeVisual(self)
      game.removeTickEvent("disparos nave aliada")
      game.stop()
    }
  }

  method configurarParaNivel2(){
    salud = 5
  }
}

class NaveEnemiga1 inherits Nave {
  var cadencia 

  override method initialize(){
    super()
    self.cadenciaDeDisparo()
  }
   override method cambiarImagen(){}

  override method actualizarBalas(){
    game.onTick(150, self.nombreOnTickDisparos(), {=> 
      balas.forEach({bala => 
        if (bala.position().y() >= 0){
          bala.moverAbajo()
        }
        else{
          bala.desaparecer()
          balas.remove(bala)
          console.println("desaparecio una bala enemiga")
        }
    })})
  }
  
  method nombreOnTickDisparos() = "disparos nave enemiga 1"

  override method nuevaBala() = new Bala(position = game.at(self.position().x(), self.position().y() - 1)
  ,image = "balaEnemigo.png")

  override method morirSiNoTieneVidas(){
    if(salud == 0){
      game.removeVisual(self)
      game.removeTickEvent(self.nombreOnTickCadencia())
      game.removeTickEvent("izquierda nave 1")
      game.removeTickEvent("derecha nave 1")
      console.println("mori")
      console.println("se elimino el movimiento del enemigo 1")
      position = game.at(1, 11)
      // es para que la bala termine de salirse del tablero y no se quede quieta o tambien para que le haga daño
      game.schedule(3000, {=> game.removeTickEvent(self.nombreOnTickDisparos())}) 
    }
  }

  override method habilitarCooldownDeDisparo(){}

  override method configurarParaNivel2(){
    salud = 10
    image = "naveEnemiga2.png"
    cadencia = 1500
  }

  method nombreOnTickCadencia() = "cadencia nave enemiga 1"

  method cadenciaDeDisparo() {
    game.onTick(cadencia, self.nombreOnTickCadencia(), {=> self.crearBalaYDispararla()})
  }

  method moverALaIzquierda(){
    self.moverA(self.position().left(1))
  }

  method moverALaDerecha(){
    self.moverA(self.position().right(1))
  }

  method estaEnBordeIzquierdo() = self.position().x() == 0

  method estaEnBordeDerecho() = self.position().x() == 4
}

class NaveEnemiga2 inherits NaveEnemiga1{
  
  override method morirSiNoTieneVidas(){
    if(salud == 0){
      game.removeVisual(self)
      game.removeTickEvent(self.nombreOnTickCadencia())
      game.removeTickEvent("izquierda nave 2")
      game.removeTickEvent("derecha nave 2")
      console.println("mori")
      console.println("se elimino el movimiento del enemigo 2")
      position = game.at(1, 11)
      // es para que la bala termine de salirse del tablero y no se quede quieta o tambien para que le haga daño
      game.schedule(3000, {=> game.removeTickEvent(self.nombreOnTickDisparos())}) 
    }
  }

  override method nombreOnTickDisparos() = "disparos nave enemiga 2"

  override method nombreOnTickCadencia() = "cadencia nave enemiga 2"

  override method estaEnBordeIzquierdo() = self.position().x() == 5

  override method estaEnBordeDerecho() = self.position().x() == 9
}