
myhighscore.registered_games = {}


-- You can register a new arcade game using this function
myhighscore.register_game(name, definition)
	definition.description = definition.description or name
	myhighscore.registered_games[name] = definition
end
