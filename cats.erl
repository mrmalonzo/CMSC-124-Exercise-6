% Filename should be: cats.erl, c(cats) - to compile
- module ( cats ) . % filename
- compile ( export_all ) . % tells which functions to compile

cat()->
	receive % waits for the mailbox to have a message
		{From, come_here} -> %From contains the process id of the sender of message
			From ! " Shut up , hooman. ~n" , %sends a message
			cat(); %need to restart cat function after receiveing a messaeg para di na need buhayin pa ulit
		{From, catfood} ->% to send a message use ProcessVariable ! {self(), message}. Then flush(). to get the message 
			From ! " Thank you! ~n";
		_ -> %if message is not come_here or not catfood
			io:format ("I’m your master. ~n"),
			cat()
	end.

% to create a process for this function, Cat = spawn(cats,cat,[]). cats - filename, cat - function name, [] - parameters
% to send a message Cat ! catfood. restart the cat after sending a message because the process dies after the first message
% f(Cat) - to free Cat variable


% 