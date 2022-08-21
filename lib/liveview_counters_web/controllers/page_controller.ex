defmodule LiveviewCountersWeb.PageController do
  use LiveviewCountersWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
