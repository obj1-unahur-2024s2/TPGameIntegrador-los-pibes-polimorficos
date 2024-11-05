import naves.*
class Bala {
  var position 
  const property image
  const property puedeDaniarNavesEnemigas
  const naveDuenia
  
  method position() = position
  
  method moverA(nuevaPosicion){
    position = nuevaPosicion
  }

  method moverArribaYEliminarSiCorrespondeDeLaNaveDuenia(){
    if (self.position().y() < game.height()){
      position = self.position().up(1)
    }
    else{
      self.desaparecerYEliminarseDeLaListaDeLaNaveDuenia()
      console.println("desaparecio una bala aliada")
    }
  }

  method moverAbajoYEliminarSiCorrespondeDeLaNaveDuenia(){
    if (self.position().y() >= 0){
      position = self.position().down(1)
    }
    else{
      self.desaparecerYEliminarseDeLaListaDeLaNaveDuenia()
      console.println("desaparecio una bala enemiga")
    }
  }

  method desaparecerYEliminarseDeLaListaDeLaNaveDuenia(){
    naveDuenia.balas().remove(self)
    console.println("Se elimino una bala de la lista de " + naveDuenia)
    game.removeVisual(self)
  }
}