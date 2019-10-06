Utils = {}

Utils.formatThousands = (n) ->
	left, num, right = string.match n, "^([^%d]*%d)(%d*)(.-)$"
	return left .. (num\reverse!\gsub("(%d%d%d)", "%1,")\reverse!) .. right

return Utils
