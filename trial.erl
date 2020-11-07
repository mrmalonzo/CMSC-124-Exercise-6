- module ( trial ) .
- compile ( export_all ) .
start_pong () ->
	Name1 = io:get_line('Enter your Name: '),
	register ( pong , spawn ( trial , pong ,[Name1]) ) . %create a process of the pong function, registered sa pangalang pong

pong (Name1) -> %magihihntay na makareceive ng message
	receive
		{Name2, Node2, bye} ->
			io:format (" Bye ~n") ;
		{ Name2, Node2, Message } ->
			io:format(Name2),
			io:format(': '),
			io:format(Message),
			io:format("~n"),
			% Node2 ! hello , %sesendan niya yung nagsend sa kanya ng ping ng pong
			New_Message = io:get_line('You: '),
			Node2 ! {Name1, New_Message},
			pong (Name1) %wait until makareceive ng reply kay ping ulit
	end.

start_ping ( Pong_Node ) ->
	Name2 = io:get_line('Enter your Name: '),
	spawn ( trial , ping0 ,[3 , Pong_Node, Name2 ]) .

ping0 (N , Pong_Node, Name2 ) ->
	{ pong , Pong_Node } ! { Name2, self () , hello } ,
	ping ( N-1 , Pong_Node , Name2 ) .

ping (N , Pong_Node, Name2 ) ->
	receive
		{Name1, bye} ->
			io:format (" bye ~n");
		{Name1, Message} ->
			io:format(Name1),
			io:format(': '),
			io:format(Message),
			io:format("~n"),
			New_Message = io:get_line('You: '),
			{ pong , Pong_Node } ! {Name2, self() ,New_Message}
	end ,
	ping ( N-1 , Pong_Node , Name2 ) .
