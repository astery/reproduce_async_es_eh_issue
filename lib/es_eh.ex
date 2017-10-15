defmodule EsEh do
  use Commanded.Event.Handler, name: "EsEh"

  import Logger

  def handle(event, _) do
    Logger.debug("EsEh received: #{inspect event}")
    send_event(Application.get_env(:es_eh, :receiver), event)

    :ok
  end

  defp send_event(nil, _), do: Logger.warn("""
    :receiver parameter not set. Can be ignored on application start
    It's happens because old not events not cleaned, and param will be set not on app start, but when test starts.
  """)
  defp send_event(pid, event), do: send(pid, {:event, event})
end
