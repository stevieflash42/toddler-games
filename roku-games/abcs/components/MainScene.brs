sub init()
    m.letters = ParseJson(ReadAsciiFile("pkg:/words.json"))
    m.index = 0
    m.clock = CreateObject("roTimespan")

    ' Custom sizes need the *File system font URIs; plain font:BoldSystemFont is not valid here.
    big = CreateObject("roSGNode", "Font")
    big.uri = "font:BoldSystemFontFile"
    big.size = 300
    m.top.findNode("letter").font = big
    small = CreateObject("roSGNode", "Font")
    small.uri = "font:BoldSystemFontFile"
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
