- module ( try ) .
- compile ( export_all ) .
start_pong () ->
	register ( pong , spawn ( try , pong ,[]) ) . %create a process of the pong function, registered sa pangalang pong

pong () -> %magihihntay na makareceive ng message
	receive
		finished ->
			io:format (" Pong finished ~n") ;
		{ ping , Ping_Pid } ->
			io:format (" Pong got ping ~n") ,
			Ping_Pid ! pong , %sesendan niya yung nagsend sa kanya ng ping ng pong
			pong () %wait until makareceive ng reply kay ping ulit
	end.

start_ping ( Pong_Node ) ->
	spawn ( try , ping ,[3 , Pong_Node ]) .

ping (0 , Pong_Node ) ->
	{ pong , Pong_Node } ! finished ,
	io:format (" Ping finished ~n") ;

ping (N , Pong_Node ) ->
	{ pong , Pong_Node } ! { ping , self () } ,
	receive
		pong ->
		io:format (" Ping got pong ~n")
	end ,
	ping ( N-1 , Pong_Node ) .
