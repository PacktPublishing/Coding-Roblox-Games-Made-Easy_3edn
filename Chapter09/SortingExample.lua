local tab = {3, 1, 2}

table.sort(tab, function(a, b)
    return a < b
end)

print(tab)