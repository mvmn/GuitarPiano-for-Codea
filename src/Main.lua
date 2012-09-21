

-- Simple Piano for 7-string electric guitar users (-:

-- Use this function to perform your initial setup
function setup()
    print("Starting")
    supportedOrientations(LANDSCAPE_ANY)
    noteNames = {}
    noteNames[1]='C'
    noteNames[2]='C#'
    noteNames[3] = 'D'
    noteNames[4] = 'D#'
    noteNames[5] = 'E'
    noteNames[6] = 'F'
    noteNames[7] = 'F#'
    noteNames[8] = 'G'
    noteNames[9] = 'G#'
    noteNames[10] = 'A'
    noteNames[11] = 'H'
    noteNames[12] = 'B'
    noteNames[0] = 'B'
    
    touches = {}
end

function touched(touch)
    if touch.state == ENDED then
        touches[touch.id] = nil
    else
        touches[touch.id] = touch
    end
end

-- This function gets called once every frame
function draw()
    background(54, 54, 66, 255)
    -- draw keys (corresponding to frets of 7 string electric guitar in standard tuning)
    for j = 0, 6 do
        for i = 0, 24 do
            drawKey(j, i)
        end
    end
    -- draw fret numbers from 0 (open string) to fret 24
    fill(200,200,255)
    for i=0,24 do
        text(i, i*30+15, 7*62+10)
    end
    for k,touch in pairs(touches) do
        math.randomseed(touch.id)
        -- This ensures the same fill color is used for the same id
        fill(math.random(255),math.random(255),math.random(255))
        -- Draw ellipse at touch position
        strokeWidth(0)
        ellipse(touch.x, touch.y, 15, 15)
        noteNum = noteNumByCoord(touch.x, touch.y)
        if(noteNum>-1) then
            -- print(noteNum)
            -- print(getNoteName(noteNum))
           sound({Waveform = SOUND_SAWTOOTH, StartFrequency = getNoteFreq(noteNum)})
        end
    end
end

function getNoteFreq(num)
    freq = 0.44 * math.pow(2, (num-30)/24)
    return freq
end

function noteNumByCoord(x,y)
    result = -1
    
    if x>0 and x<25*30 and y>0 and y<7*62 then
        result = getNoteNum(math.floor(y/62), math.floor(x/30))
    end
    
    return result
end

function getNoteNum(string, fret)
    stringOffset = 0;
    if(string>4) then
        stringOffset = -1;
    end
    note = fret + string*5 + stringOffset
    return note
end

function drawKey(string, fret)
    stroke(0,0,0)
    strokeWidth(3)
    i = fret
    j = string
    note = getNoteNum(string, fret)
            
    if isBlackKey(note) then
        noteColor = color(0, 0, 0)
        textColor = color(255,255,255)
    else
        noteColor = color(255, 255, 255, 255)
        textColor = color(0,0,0)
    end
    x =i*30
    y = j*62
    fill(noteColor)
    rect(x, y, 30, 60)
    fill(textColor)
    text(getNoteName(note),x+15,y+30)
end

function getNoteName(num)
    nnum = num % 12
    octave = math.ceil(num/12)+1
    result = noteNames[nnum]
    if string.len(result)<2 then
        result = result..octave
    end
    return result
end

function isBlackKey(num) 
    result = false
    num = num % 12
    if (num == 2 or num == 4 or num==7 or num==9 or num==11) then
        result = true
    end
    return result
end

