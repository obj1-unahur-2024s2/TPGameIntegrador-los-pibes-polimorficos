import naves.*
class Bala {
  var position 
  const property image
  const property puedeDaniarNavesEnemigas
  
  method position() = position
  
  method moverA(nuevaPosicion){
    position = nuevaPosicion
  }

  method moverArribaYEliminarSiCorrespondeDe(unObjeto){
    if (self.position().y() < game.height()){
      position = self.position().up(1)
    }
    else{
      self.desaparecerYEliminarseDeLaListaDe(unObjeto)
      console.println("desaparecio una bala aliada")
    }
  }

  method moverAbajoYEliminarSiCorrespondeDe(unObjeto){
    if (self.position().y() >= 0){
      position = self.position().down(1)
    }
    else{
      self.desaparecerYEliminarseDeLaListaDe(unObjeto)
      console.println("desaparecio una bala enemiga")
    }
  }

  method desaparecerYEliminarseDeLaListaDe(unObjeto){
    unObjeto.balas().remove(self)
    console.println("Se elimino una bala de una lista")
    game.removeVisual(self)
  }
}