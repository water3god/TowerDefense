local Table = { 1, 2, 5, 3, 0 }
table.sort(Table, function(a, b)
	return a > b
end)
print(Table)
