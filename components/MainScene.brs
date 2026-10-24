sub init()
    m.letters = [
        { letter: "A", word: "Apple", color: "0xFF6B6BFF" },
        { letter: "B", word: "Ball", color: "0x4D96FFFF" },
        { letter: "C", word: "Cat", color: "0xFFA630FF" },
        { letter: "D", word: "Dog", color: "0x9B5DE5FF" },
        { letter: "E", word: "Elephant", color: "0x3DB2A8FF" },
        { letter: "F", word: "Fish", color: "0x00A6EDFF" },
        { letter: "G", word: "Grapes", color: "0x8E44ADFF" },
        { letter: "H", word: "House", color: "0xE67E22FF" },
        { letter: "I", word: "Ice cream", color: "0xF15BB5FF" },
        { letter: "J", word: "Juice", color: "0xF28C28FF" },
        { letter: "K", word: "Kite", color: "0x2EC4B6FF" },
        { letter: "L", word: "Lion", color: "0xE9A800FF" },
        { letter: "M", word: "Moon", color: "0x5C6BC0FF" },
        { letter: "N", word: "Nose", color: "0xEF6F6CFF" },
        { letter: "O", word: "Octopus", color: "0xC2185BFF" },
        { letter: "P", word: "Pig", color: "0xF78FB3FF" },
        { letter: "Q", word: "Queen", color: "0x7E57C2FF" },
        { letter: "R", word: "Rainbow", color: "0x26A69AFF" },
        { letter: "S", word: "Sun", color: "0xF4A100FF" },
        { letter: "T", word: "Tree", color: "0x43A047FF" },
        { letter: "U", word: "Umbrella", color: "0x1E88E5FF" },
        { letter: "V", word: "Volcano", color: "0xE53935FF" },
        { letter: "W", word: "Whale", color: "0x039BE5FF" },
        { letter: "X", word: "X-ray", color: "0x6D4C9FFF" },
        { letter: "Y", word: "Yo-yo", color: "0xD81B60FF" },
        { letter: "Z", word: "Zebra", color: "0x546E7AFF" }
    ]
    m.index = 0
    m.clock = CreateObject("roTimespan")

    big = CreateObject("roSGNode", "Font")
    big.uri = "font:BoldSystemFont"
    big.size = 300
    m.top.findNode("letter").font = big
    small = CreateObject("roSGNode", "Font")
    small.uri = "font:BoldSystemFont"
    small.size = 120
    m.top.findNode("word").font = small

    show(0)
    m.top.setFocus(true)
end sub

sub show(i as integer)
    item = m.letters[i]
    l = LCase(item.letter)
    m.top.findNode("bg").color = item.color
    m.top.findNode("letter").text = item.letter + l
    m.top.findNode("word").text = item.word
    m.top.findNode("picture").uri = "pkg:/images/" + l + ".png"

    audio = m.top.findNode("audio")
    audio.control = "stop"
    content = CreateObject("roSGNode", "ContentNode")
    content.url = "pkg:/sounds/" + l + ".wav"
    audio.content = content
    audio.control = "play"
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    ' ponytail: swallowing Back violates Roku store certification; fine for sideloading. If publishing, require Back 3x quickly to exit.
    if not press then return true
    if m.clock.TotalMilliseconds() < 300 then return true
    m.clock.Mark()

    n = m.letters.count()
    if key = "left" or key = "rewind" then
        m.index = (m.index + n - 1) mod n
    else
        m.index = (m.index + 1) mod n
    end if
    show(m.index)
    return true
end function
