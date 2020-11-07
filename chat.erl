- module ( chat ) .
- compile ( export_all ) .


init_chat() ->
	Name1 = io:get_line('Enter your Name: '),
	register(n1, spawn(chat, chat1, [Name1])).


chat1(Name1) ->
	receive
		{Name2, Node2 , bye} ->
			io:format (" Your partner has disconnected ~n");
		{Name2, Node2 , Message} ->
			io:format(Name2),
			io:format(': '),
			io:format(Message),
			New_Message = io:get_line('You: '),
			{chat2, Node2} ! {Name1, self() , New_Message},
			chat1(Name1)
	end.
	




init_chat2(Node1) ->
	Name2 = io:get_line('Enter your Name: '),
	spawn ( chat , chat2 ,[Node1, Name2]).


chat2(Node1, Name2) ->
	New_Message = io:get_line('You: '),
	{n1, Node1} ! {Name2, self() , New_Message},
	receive
		{Name1, Node1 , bye} ->
			io:format (" Your partner has disconnected ~n");
		{Name1, Node1 , Message} -> 
			io:format(Name1),
			io:format(': '),
			io:format(Message),
			chat2(Node1, Name2)
	end.



