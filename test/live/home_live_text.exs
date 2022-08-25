defmodule LiveviewCountersWeb.HomeLiveTest do
  use LiveviewCountersWeb.ConnCase
  import Phoenix.LiveViewTest

  test "first button present?", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/home")
    assert has_element?(view, "button#b1", "Increment: +1")
    # open_browser(view)
  end

  test "increment button 1 on click prints Counter: 1", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/home")

    view |> element("button#b1", "Increment: +1") |> render_click()
    assert has_element?(view, "#counter", "1")
  end
end
