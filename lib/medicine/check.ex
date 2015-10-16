defmodule Medicine.Check do
  require Logger

  defstruct id: nil, module: nil, name: nil, frequency: 10, status: :waiting,
    description: nil

  @doc """
  creates a new instance of %Medicine.Check struct
  """
  def new(module, status \\ :waiting) do
    %Medicine.Check{id: UUID.uuid4(), module: module, name: module.name,
      frequency: module.frequency, status: status,
      description: module.description}
  end

  @doc """
  macro to define check name and frequency
  """
  defmacro check(name, freq) do
    quote bind_quoted: [name: name, freq: freq] do
      require Logger

      def frequency do
        unquote(freq)
      end

      def name do
        unquote(name)
      end

      @doc """
      called from the repository, when ready to check
      """
      def run(check) do
        {{year, month, day}, {hour, minute, sec}} = :calendar.local_time()
        exec_time = "#{day}/#{month}/#{year} #{hour}:#{minute}:#{sec}"
        Logger.log(:debug, "#{exec_time} - #{__MODULE__} - checking")
        Medicine.ChecksRepository.update_status(do_check(check))
      end
    end
  end

  @doc """
  macro to define check description
  """
  defmacro description(desc) do
    quote bind_quoted: [desc: desc] do
      def description do
        unquote(desc)
      end
    end
  end
end

defimpl Poison.Encoder, for: Medicine.Check do
  def encode(%Medicine.Check{id: id, name: name, status: status, description: description}, _options) do
    %{id: id, name: name, status: status, description: description}
    |> Poison.Encoder.encode([])
  end
end
