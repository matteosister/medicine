defmodule Medicine.Check do
  require Logger

  defstruct id: nil, module: nil, name: nil, frequency: 10, status: :waiting,
    description: nil, last_check_date: nil

  @doc """
  creates a new instance of %Medicine.Check struct
  """
  def new(module, status \\ :waiting) do
    check_function(module, :name, 0)
    check_function(module, :frequency, 0)
    check_function(module, :description, 0)
    %Medicine.Check{id: UUID.uuid4(), module: module, name: module.name,
      frequency: module.frequency, status: status,
      description: module.description}
  end

  def set_last_update_time(check) do
    %{check | last_check_date: exec_time}
  end

  def exec_time do
    {{year, month, day}, {hour, minute, sec}} = :calendar.local_time()
    "#{day}/#{month}/#{year} #{hour}:#{minute}:#{sec}"
  end

  @doc """
  raise an exception if the function with the given arity doesn't
  exists in the given module
  """
  def check_function(module, function, arity) do
    unless function_exported?(module, function, arity) do
      error = "To implement a check you should implement the function"
        <> " '#{function}' in your '#{module}' module"
      raise error
    end
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
        Medicine.Check.check_function(check.module, :do_check, 1)
        check
        |> do_check
        |> set_last_update_time
        |> Medicine.ChecksRepository.updated_status
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
