defmodule Medicine.Check do
  require Logger

  defstruct id: nil, callback: nil, name: nil, frequency: 10, status: :waiting,
    description: nil

  def new(callback, status \\ :waiting) do
    %Medicine.Check{id: UUID.uuid4(), callback: callback, name: callback.name,
      frequency: callback.frequency, status: status,
      description: callback.description}
  end

  defmacro check(name, freq) do
    quote bind_quoted: [name: name, freq: freq] do
      require Logger

      def frequency do
        unquote(freq)
      end

      def name do
        unquote(name)
      end

      def run(check) do
        {{year, month, day}, {hour, minute, sec}} = :calendar.local_time()
        exec_time = "#{day}/#{month}/#{year} #{hour}:#{minute}:#{sec}"
        Logger.log(:debug, "#{exec_time} - #{__MODULE__} - checking")
        Medicine.ChecksRepository.update_status(do_check(check))
      end
    end
  end

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
