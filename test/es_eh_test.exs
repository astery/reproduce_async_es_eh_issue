defmodule EsEhTest do
  use ExUnit.Case

  alias EsEh.SimpleEvent
  import Logger

  @aggregate_id "b4dddd2b-95aa-431d-eb7a-32b72e276397"
  @event %SimpleEvent{aggregate_id: @aggregate_id, message: "hello"}

  setup do
    Application.put_env(:es_eh, :receiver, self())
  end

  test "should receive all sent events" do
    Enum.each(1..100, &test_round/1)
  end

  def test_round(number) do
    Logger.warn("Round number: #{number}")

    reset()
    assert {:ok, 1} = Commanded.EventStore.append_to_stream(@aggregate_id, 0, Commanded.Event.Mapper.map_to_event_data([@event]))
    assert_receive {:event, %SimpleEvent{message: "hello"}}
  end

  def reset do
    Application.stop(:es_eh)
    Application.stop(:commanded)
    Application.stop(:eventstore)

    reset_storage()

    Application.ensure_all_started(:postgrex)
    Application.ensure_all_started(:eventstore)
    Application.ensure_all_started(:commanded)
    Application.ensure_all_started(:es_eh)

    # wait_until_evestore_subscribers_subscribe()

    :ok
  end

  def reset_storage do
    if Code.ensure_compiled?(EventStore.Storage) do
      storage_config = Application.get_env(:eventstore, EventStore.Storage)
                       |> Keyword.merge(pool: DBConnection.Poolboy)

      {:ok, conn} = Postgrex.start_link(storage_config)

      EventStore.Storage.Initializer.reset!(conn)

      Process.exit(conn, :normal)
    end
  end

  defp wait_until_evestore_subscribers_subscribe() do
    Process.sleep(50)
  end
end
