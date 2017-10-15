defmodule EsEh.Application do
  @moduledoc false

  use Application

  import Supervisor.Spec

  def start(_type, _args) do
    EsEh.start_link()
  end
end
