% Type and save this file with the filename: pingpong.erl
- module ( pingpong ) .
- compile ( export_all ) .
start_pong () ->
	register ( pong , spawn ( pingpong , pong ,[]) ) . %create a process of the pong function, registered sa pangalang pong

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
	spawn ( pingpong , ping ,[3 , Pong_Node ]) .

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

% cd("/UPLB/TY-FS/CMSC124/LAB/WEEK6").

%kay kat : pingpong:start_pong(). lang
%kay Kei : pingpong:start_ping('kat@Marlon-Predator').
