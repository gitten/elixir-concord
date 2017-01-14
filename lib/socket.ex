defmodule Concord.Socket do
  use GenServer


  def start_link(socket_url) do
    GenServer.start_link(__MODULE__, socket_url, [name: :socket])
  end


  def init(socket_url) do
    socket = Socket.Web.connect!(socket_url)
    send self(), :receive    
    {:ok, socket}
  end


  def handle_info(:receive, socket) do
    IO.puts "waiting for message"
    socket_message = Socket.Web.recv! socket

    IO.puts "recieved message"
    IO.inspect socket_message
    
    send self(), socket_message
    {:noreply, socket}
  end


  def handle_info({:ping, _payload}, socket) do
    IO.puts "INCOMING PING!"

    :ok = socket |> Socket.Web.send!({:pong, ""})
    IO.puts "PONGED!"

    send self(), :receive
    {:noreply, socket}
  end


  def handle_info(msg, socket) do
    IO.puts "inspecting unhandler"
    IO.puts "msg: "
    IO.inspect msg
    IO.puts "socket state: "
    IO.inspect socket
    {:no_repply, socket}
  end
end

  
