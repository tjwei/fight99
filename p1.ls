var player, platforms, cursor, stars
var start-time
var score
emitters = []
int = (n) -> n .|. 0
WIDTH = 1280
HEIGHT = 720
game = new Phaser.Game WIDTH, HEIGHT, Phaser.AUTO, '', do
  preload: !->
    game.load
      ..crossOrigin = \anonymous
      ..~image
        .. \clear \images/clear.png
        .. \start \images/start.png
        .. \background \images/Background-4.png
      ..~spritesheet
        .. \flighter \images/fighter.png 64 64
        .. \ball \images/icon1.png 16 16
  create: !->
    game
      ..scale.fullScreenScaleMode = Phaser.ScaleManager.SHOW_ALL
      ..physics.start-system Phaser.Physics.ARCADE
      ..add
        ..image 0 0 \background
          ..alpha = 0.5
        player := ..sprite game.world.centerX-32, game.world.centerY-32, \flighter
          ..frame = 3
          game.physics.arcade.enable ..
          ..body
            ..gravity.y = 0
            ..collideWorldBounds = true
          ..animations.add \left [9 10 11 10] 10 true
          ..animations.add \right [18 19 20 19] 10 true
          ..scale.setTo 1 1
        score := ..text 16 46 '0' {fontSize: '32px', fill: '#fff'}
        emitter-setting = (e, v, d) ->
          if v
            e.width = game.world.width
            e.setYSpeed 200*d, 100*d
            e.setXSpeed -100 100
          else
            e.setXSpeed 200*d, 100*d
            e.setYSpeed -100 100
            e.height = game.world.height
          e.gravity = 0
          e.makeParticles \ball [to 6] 200 true false
          e.start false 8000 500
          emitters[*]=e
        ..emitter game.world.centerX, game.world.height, 200
          emitter-setting .., true -1
        ..emitter game.world.centerX, 0, 200
          emitter-setting .., true 1
        ..emitter game.world.width, game.world.centerY, 200
          emitter-setting .., false -1
        ..emitter 0, game.world.centerY, 200
          emitter-setting .., false 1
      ..input
        cursor := ..keyboard.createCursorKeys!
        ..onDown.add _, @ <| !-> game.scale.startFullScreen false
    start-time := new Date!
  update: !->
    player
      ..frame = 3
      [x, y] = [0, 0]
      if cursor.left.isDown
        ..frame = 1
        x = -150
      if cursor.right.isDown
        ..frame = 5
        x = 150
      if cursor.up.isDown
        y = -150
      if cursor.down.isDown
        y = 150
      ..body.velocity
        [..x, ..y] = [x, y]
    secs = ((new Date! - start-time)/1000) .toFixed 1
    score.text = secs + "s"
