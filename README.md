# SimulateConnect4GameLogic
Connect 4 game logic

## Demo code
```
let game = GameViewModel()
let gameSteps = [
    [3, 1],
    [2, 2],
    [4, 1],
    [5, 2],
    [3, 1],
    [3, 2],
    [4, 1],
    [2, 2],
    [5, 1],
    [1, 2],
    [6, 1],
    [6, 2],
    [4, 1],
    [4, 2]
]

var winner = 0
for item in gameSteps {
    if game.addDisc(column: item[0], player: item[1]) {
        winner = item[1]
    }

    sleep(1)
}

if winner > 0 {
    let player = winner == 1 ? "Player 1" : "Play 2"
    print("\(player), You Win!")
}
```

![connect4.gif](connect4.gif)
