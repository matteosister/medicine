defmodule Medicine.ChecksRepository do
  use GenServer
  require Logger
  alias Medicine.Check

  #
  # Public API
  #
  def init(checks) do
    Logger.log(:debug, "Checks - init")
    state = checks
    |> Enum.map(&(Check.new(&1)))
    |> Enum.map(&init_timer/1)
    {:ok, state}
  end

  def start_link do
    Logger.log(:debug, "Checks - start_link")
    checks = Application.get_env(:medicine, :checks, [])
    GenServer.start_link(__MODULE__, checks, name: :checks)
  end

  def add_check(check) do
    GenServer.cast :checks, {:add, check}
  end

  def update_status(check) do
    GenServer.cast :checks, {:update_status, check}
  end

  def check_status(check) do
    GenServer.call :checks, {:get_status, check}
  end

  def get_all do
    checks = GenServer.call :checks, :get_all
    checks
    |> Enum.sort_by(&(&1.name))
  end

  #
  # GenServer implementation
  #
  def handle_cast({:add, check}, checks) do
    {:noreply, [check|checks]}
  end

  def handle_cast({:update_status, new_check}, checks) do
    # TODO: remove this hardcoded reference
    MedicineWeb.Endpoint.broadcast!("checks:all", "update_status", new_check)
    other_checks = Enum.reject(checks, fn (c) -> c.callback == new_check.callback end)
    {:noreply, [new_check|other_checks]}
  end

  def handle_call({:get_status, check}, _from, checks) do
    IO.inspect checks
    the_check = Enum.find checks, nil, fn (c) -> c.callback == check.callback end
    case the_check do
      nil -> {:noreply, checks}
      {status, _} -> {:reply, status, checks}
    end
  end

  def handle_call(:get_all, _from, checks) do
    {:reply, checks, checks}
  end

  defp init_timer(check = %Check{name: name, callback: callback}) do
    Logger.log(:debug, "Checks - initialize timer for check \"#{name}\" every #{check.frequency} seconds")
    :timer.apply_interval(check.frequency * 1000, callback, :run, [check])
    check
  end
end
