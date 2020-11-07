%		Authors: Arcilla, Jaimy Camille	and Malonzo, Marlon
%		T-7L
%
%
%		References:
%			string:strip(io:get_line("Name: "), right, $\n) - https://stackoverflow.com/questions/18439891/why-does-ioget-line-return-n-in-erlang-shell
%			timer:sleep(10) - https://erlang.org/doc/man/shell.html
%			init:stop() - https://medium.com/erlang-battleground/10-ways-to-stop-an-erlang-vm-7016bd593a5#:~:text=Well%20if%20you're%20in,erlang%3Ahalt(0).

- module ( chat ) .
- compile ( export_all ) .

init_chat () -> %this is the fuction where you initialize the first 2 processes of the first participant of the chatroom

	Name1 = string:strip(io:get_line("Name: "), right, $\n), %get the name of the 1st participant
	register ( chat1, spawn ( chat , chat1 ,[Name1]) ), %create a process named chat1 that receives the message for the 1st participant
	spawn ( chat , send_message ,[Name1]). %create another process for the 1st participant so they can send a message


chat1 (Name1) -> %function that waits for the message of the 2nd partcipant
	receive
		bye -> %if the 2nd person says bye, then disconnect and exit
			io:format ("Your partner has disconnected ~n"),
			init:stop() ;
		{ Name2, Message } -> %wait until makareceive ng reply kay then loop ulit
			io:format(Name2),
			io:format(': '),
			io:format(Message),
			io:format("~n"),
			chat1 (Name1) 
	end.

send_message(Name1) -> %function that the 1st participant is using to send a message
	Length_nodes = length(nodes()), %gets the length of the node to know if another participant is connected to the 1st participant
	if
		Length_nodes > 0 -> 
			[Head | Tail] = nodes(), %split the List of nodes into head and tail
			Node2 = Head, %use the head to get the pid of the node connected to the first node
			New_Message = string:strip(io:get_line("You: "), right, $\n), %get the message
			if 
				New_Message =:= "bye" -> %if the message is bye, exit
					{chat2, Node2} ! bye,
					init:stop();
				true ->
					{chat2, Node2} ! {Name1, New_Message},
					send_message(Name1)
			end;
		Length_nodes =:= 0 -> %if there are no participants connected to 1st participant, loop
			send_message(Name1)
	end.
	
		

init_chat2 ( Node1 ) -> %this is the fuction where you initialize another 2 processes of the second participant of the chatroom
	Name2 = string:strip(io:get_line("Name: "), right, $\n), %get the name
	net_adm:ping(Node1), %connect this node to the pid of the 1st participant
	register(chat2 ,spawn ( chat , chat2 ,[Node1, Name2 ])), %create a process named chat2 that receives the message for the 2nd participant
	spawn ( chat , send_message2 ,[Node1, Name2 ]).%create another process for the 2nd participant so they can send a message

chat2 (Node1, Name2 ) -> %function that waits for the message of the 1st partcipant
	receive
		bye -> %if the message received is bye, disconnect and exit
			io:format ("Your partner has disconnected ~n"),
			init:stop();
		{Name1, Message} -> %wait until makareceive ng reply kay then loop ulit
			io:format(Name1),
			io:format(': '),
			io:format(Message),
			io:format("~n"),
			chat2 (Node1, Name2 )
	end.
	

send_message2(Node1, Name2) -> %function that the 2nd participant is using to send a message
	timer:sleep(10), %used this function to fix the io malfunction when using it together within the spawn() function (a PL bug by Erlang)
	New_Message = string:strip(io:get_line("You: "), right, $\n),
	if
		New_Message =:= "bye" -> %if the user types bye, then send message and exit
			{ chat1, Node1 } ! bye,
			init:stop();
		true ->
			{ chat1 , Node1 } ! {Name2, New_Message},
			send_message2(Node1, Name2)
	end.
