defmodule LiveviewCounters.FetchData do
  @url "https://jsonplaceholder.typicode.com/todos/"

  defp get_page(i), do: @url <> to_string(i)

  def async(i) do
    task =
      Task.async(fn ->
        # Process.sleep(3000)
        HTTPoison.get(get_page(i))
      end)

    case Task.yield(task) do
      {:ok, {:ok, %HTTPoison.Response{status_code: 200, body: body}}} ->
        body = Poison.decode!(body)
        true = :ets.insert(:counters, {:data, body})
        {:ok, body}

      {:ok, {:error, %HTTPoison.Error{reason: reason}}} ->
        {:error, reason}
    end
  end
end
