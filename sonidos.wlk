object generadorDeSonido {
  const musicaDeFondo = game.sound("musicaDeFondo.mp3")
  var volumenDeFondo = 0.1

  method iniciarMusicaDeFondo(){
    musicaDeFondo.volume(volumenDeFondo)
    musicaDeFondo.shouldLoop(true)  
    musicaDeFondo.play()
  }

  method aumentarVolumenDeMusicaDeFondo(){
    volumenDeFondo = 1.min(volumenDeFondo + 0.1)
    musicaDeFondo.volume(volumenDeFondo)
  }

  method disminuirVolumenDeMusicaDeFondo(){
    volumenDeFondo = 0.1.max(volumenDeFondo - 0.1)
    musicaDeFondo.volume(volumenDeFondo)
  }

  method alternarMusicaDeFondo(){
    if(not musicaDeFondo.paused()){
      self.pausarMusicaDeFondo()
    }
    else{
      self.reanudarMusicaDeFondo()
    }
  }

  method pausarMusicaDeFondo(){
    musicaDeFondo.pause()
  }

  method reanudarMusicaDeFondo(){
    musicaDeFondo.resume() 
  }

  method bajarVolumenDeMusicaAlMinimo(){
    musicaDeFondo.volume(0.01)
  }

  method volverVolumenDeMusicaALaNormalidad(){
    musicaDeFondo.volume(volumenDeFondo)
  }

  method reproducirSonido(unSonido){
    game.sound(unSonido).play()
  }
}