- module ( chat ) .
- compile ( export_all ) .
init_chat () ->

	Name1 = string:strip(io:get_line("Name: "), right, $\n),
	register ( chat1, spawn ( chat , chat1 ,[Name1]) ) . 

chat1 (Name1) -> %magihihntay na makareceive ng message
	receive
		bye ->
			io:format (" Your partner has disconnected ~n") ;
		{ Name2, Node2, Message } ->
			io:format(Name2),
			io:format(': '),
			io:format(Message),
			io:format("~n"),
			New_Message = string:strip(io:get_line("You: "), right, $\n),
			if
				New_Message =:= "bye" ->
					Node2 ! bye;
				true ->
					Node2 ! {Name1, New_Message}
			end,
			chat1 (Name1) %wait until makareceive ng reply kay ping ulit
	end.

init_chat2 ( Node1 ) ->
	Name2 = string:strip(io:get_line("Name: "), right, $\n),
	net_adm:ping(Node1),
	spawn ( chat , chat2_init ,[Node1, Name2 ]) .

chat2_init (Node1, Name2 ) ->
	{ chat1 , Node1 } ! { Name2, self () , hello } , %initialize the first chat
	chat2(Node1, Name2 ) .

chat2 (Node1, Name2 ) ->
	receive
		bye ->
			io:format ("Your partner has disconnected ~n");
		{Name1, Message} ->
			io:format(Name1),
			io:format(': '),
			io:format(Message),
			io:format("~n"),
			New_Message = string:strip(io:get_line("You: "), right, $\n),
			if
				New_Message =:= "bye" ->
					Node1 ! bye;
				true ->
					{ chat1 , Node1 } ! {Name2, self() ,New_Message}
			end,
			chat2 (Node1, Name2 )
	end.
	
