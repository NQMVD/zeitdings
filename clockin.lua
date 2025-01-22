saveFileName = 'timecard.txt'

local function loadData()
    if fs.exists(saveFileName) then
        local file = fs.open(saveFileName, 'r')
        local data = textutils.unserialize(file.readAll())
        file.close()
        return data
    end
    return {}
end

local function saveData(data)
    local file = fs.open(saveFileName, 'w')
    file.write(textutils.serialize(data))
    file.close()
end

local function getCurrentDate()
    return os.date("%A %d %B %Y")
end

local function getCurrentTime()
    return os.time("local")
end

local function getLatestEntry(data)
    local length = table.length(data)
    return data[length]
end

local function formatTime(time)
    return textutils.formatTime(time, true)
end

-- MAIN PROGRAM

local data = loadData()
local currentDate = getCurrentDate()
local currentTime = getCurrentTime()
local today = getLatestEntry()

if today.clockOut then
    print"Already clocked OUT today!"
    print("Span: ", formatTime(today.clockIn)..' - 'formatTime(today.clockOut))
    print("Duration:", tostring(data.clockOut - data.clockIn))
else
    if today.date == currentDate then
        local timeElapsed = (currentTime - today.clockIn)
        local timeRemaining = 8 - timeElapsed
        print"Currently clocked IN"
        print("Start:", formatTime(today.clockIn))

        if timeRemaining > 0 then
            print("Remaining:")
        else
            print("Done!")
        end
    else
        today = {
            data = currentDate,
            clockIn = currentTime
        }
        table.insert(data, today)
        saveData(today)
        print("Clocked in at:", formatTime(currentTime))
    end
end
