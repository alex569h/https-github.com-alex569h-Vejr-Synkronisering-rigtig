RegisterNetEvent('vejrSync:receiveWeather')
AddEventHandler('vejrSync:receiveWeather', function(vejr, tid)
  SetWeatherTypeOverTime(vejr, 15.0)
  NetworkOverrideClockTime(tid, 0, 0)
end)
