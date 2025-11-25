local utilities = {}

utilities.recursiveCopy = function(dataTable)
	local tableCopy = {}

	for index, value in dataTable do
		if type(value) == "table" then
			value = utilities.recursiveCopy(value)
		end
		
		tableCopy[index] = value
	end
	
	return tableCopy
end

utilities.promiseReturn = function(maxRetries, callback, retries, err)
	if maxRetries and not retries then
		retries = 0
	elseif retries and retries > maxRetries then
		warn("Retry limit reached for ", callback)
		return false, err
	end

	local result

	local success, err = pcall(function()
		result = callback()
	end)

	if success then
		return success, result
	else
		task.wait()
		if retries then
			retries += 1
		end

		return utilities.promiseReturn(maxRetries, callback, retries, err)
	end
end

utilities.formatTimeRemaining = function(timeRemaining, onlyMinutes)
	local hours = math.floor(timeRemaining/60/60)
	local minutes = math.floor((timeRemaining/60) - (hours * 60))
	local seconds = math.floor(timeRemaining - (minutes * 60) - (hours * 60 * 60))

	hours = tostring(hours)
	minutes = tostring(minutes)
	seconds = tostring(seconds)

	if #hours < 2 then
		hours = "0".. hours
	end
	if #minutes < 2 then
		minutes = "0".. minutes
	end
	if #seconds < 2 then
		seconds = "0".. seconds
	end

	return onlyMinutes and minutes.. ":".. seconds or hours.. ":".. minutes.. ":".. seconds
end

return utilities