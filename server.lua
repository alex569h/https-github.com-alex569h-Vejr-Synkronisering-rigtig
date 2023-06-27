-- MySQL-forbindelsesoplysninger
local mysql_host = "localhost"
local mysql_database = "vejr_database"
local mysql_username = "brugernavn"
local mysql_password = "adgangskode"

local db = mysql_connect(mysql_host, mysql_username, mysql_password, mysql_database)
mysql_query(db, "CREATE TABLE IF NOT EXISTS vejr (id INT AUTO_INCREMENT PRIMARY KEY, vejr VARCHAR(50), tid INT)")

local defaultWeather = "EXTRASUNNY"
local defaultTime = 12

RegisterServerEvent('vejrSync:fetchWeather')
AddEventHandler('vejrSync:fetchWeather', function()
  local source = source

  local query = mysql_query(db, "SELECT vejr, tid FROM vejr ORDER BY id DESC LIMIT 1")
  if mysql_num_rows(query) > 0 then
    local result = mysql_fetch_assoc(query)

    TriggerClientEvent('vejrSync:receiveWeather', source, result.vejr, result.tid)
  else
    TriggerClientEvent('vejrSync:receiveWeather', source, defaultWeather, defaultTime)
  end
end)

RegisterServerEvent('vejrSync:updateWeather')
AddEventHandler('vejrSync:updateWeather', function(vejr, tid)
  mysql_query(db, "INSERT INTO vejr (vejr, tid) VALUES ('" .. vejr .. "', " .. tid .. ")")
end)

AddEventHandler('onResourceStart', function(resourceName)
  if GetCurrentResourceName() == resourceName then
    -- Hent vejret og tiden fra databasen
    local query = mysql_query(db, "SELECT vejr, tid FROM vejr ORDER BY id DESC LIMIT 1")
    if mysql_num_rows(query) > 0 then
      local result = mysql_fetch_assoc(query)
      defaultWeather = result.vejr
      defaultTime = result.tid
    end
  end
end)

RegisterCommand('setvejr', function(source, args)
  local vejr = args[1]

  TriggerClientEvent('vejrSync:receiveWeather', -1, vejr, defaultTime)

  mysql_query(db, "INSERT INTO vejr (vejr, tid) VALUES ('" .. vejr .. "', " .. defaultTime .. ")")
end, false)

RegisterCommand('settiden', function(source, args)
  local tid = tonumber(args[1])

  TriggerClientEvent('vejrSync:receiveWeather', -1, defaultWeather, tid)

  mysql_query(db, "INSERT INTO vejr (vejr, tid) VALUES ('" .. defaultWeather .. "', " .. tid .. ")")
end, false)
