- module ( chat ) .
- compile ( export_all ) .


init_chat() ->
	Name1 = io:get_line('Enter your Name: '),
	waitForPartner(Name1).

waitForPartner(Name1) ->
	receive
		{chatIsHere, Name2, Node2} ->
			register(n1, spawn(chat, chat1, [Name1, Name2, Node2, '']))
	end.


chat1(Name1, Name2, Node2, Message) ->
	Message = io:get_line('You: '),
	{chat2, Node2} ! {Name1, Name2, self() ,Message},
	receive
		{Name1, Name2, self() , bye} ->
			io:format (" Your partner has disconnected ~n");
		_ ->
			io:format(Name2),
			io:format(': '),
			io:format(Message)
	end.




init_chat2(Node1) ->
	Name2 = io:get_line('Enter your Name: '),
	{waitForPartner, Node1} ! {chatIsHere, Name2, self()},
	spawn ( chat , chat2 ,[n1, Name2, Node1 , '']).


chat2(Name1, Name2, Node1, Message) ->
	Message = io:get_line('You: '),
	{n1, Node1} ! {Name1, Name2, self() ,Message},
	receive
		{Name1, Name2, self() , bye} ->
			io:format (" Your partner has disconnected ~n");
		_ ->
			io:format(Name1),
			io:format(': '),
			io:format(Message)
	end.



