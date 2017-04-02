defmodule Help do
  import Plug.Conn
  def r(conn,res) do
    reply_to_web(conn,res)
  end

  def reply_to_web(conn,{:error, reason, code}) do
    put_resp_content_type(conn,"text/plain")
    send_resp(conn, code, "Error: #{inspect reason}.")
  end
  def reply_to_web(conn,result)  do
    put_resp_content_type(conn,"text/plain")
    send_resp(conn, 200, "Result: #{inspect result}.")
  end
end
#Здесь можно собрать вспомогательные функци