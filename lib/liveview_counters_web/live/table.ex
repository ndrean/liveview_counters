defmodule Table do
  use Phoenix.Component

  def display(assigns) do
    if assigns.place,
      do: ~H"""
      <div>
          <table>
            <caption>Data from user: <%= "user"%></caption>
            <thead>
              <tr>
                <th colspan="2">Coordinates lat/lng</th>

                <th>Found address</th>
              </tr>
            </thead>
            <tbody>
            <%= for coord <- @place["coords"] do %>
            <Row.display row={coord} id={"r-#{coord["id"]}"}/>
            <% end %>
            </tbody>
          </table>
        </div>
        <p>distance: <%= if @place, do: @place["distance"], else: 0 %></p>
      """,
      else: ~H"""
      """
  end
end

defmodule Row do
  use Phoenix.Component

  def display(assigns) do
    IO.puts("row")

    ~H"""
    <tr id={"tr-#{@row["id"]}"} >
      <td><%= @row["lat"] %></td>
      <td><%= @row["lng"] %></td>
      <td><%= @row["name"] %></td>
    </tr>
    """
  end
end
