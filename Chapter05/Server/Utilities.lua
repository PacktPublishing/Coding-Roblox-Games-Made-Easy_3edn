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

return utilities