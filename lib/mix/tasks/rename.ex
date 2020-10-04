defmodule Mix.Tasks.Rename do
  use Mix.Task

  defmodule State do
    defstruct options: [], files: [], module_name: nil, original: nil

    @template [strict: [dry_run: :boolean]]
    @original "SnowhiteTemplate"
    def init(args) do
      {options, [module_name | _], _} = OptionParser.parse(args, @template)

      if not module_name_valid?(module_name),
        do:
          raise(
            "Expected a Pascal case module name (like `SnowhiteTemplate`) but got #{module_name}"
          )

      %State{
        options: options,
        module_name: get_cases(module_name),
        original: get_cases(@original)
      }
    end

    @regex ~r/^[A-Z][a-zA-Z0-9]+$/
    defp module_name_valid?(module_name), do: Regex.match?(@regex, module_name)

    def dry_run?(%State{options: options}), do: Keyword.get(options, :dry_run) == true

    def module_name(%State{module_name: {name, _}}), do: name

    def atom_name(%State{module_name: {_, name}}), do: name

    def replace(%State{} = state, string) do
      out = replace_occurences(state, string)

      if out === string do
        {:noop, out}
      else
        {:ok, out}
      end
    end

    def replace_occurences(
          %State{original: {module, atom}, module_name: {new_module, new_atom}},
          string
        ) do
      replacements = [
        {module, new_module},
        {atom, new_atom}
      ]

      Enum.reduce(replacements, string, fn {old, new}, acc -> String.replace(acc, old, new) end)
    end

    defp get_cases(module_name), do: {module_name, Macro.underscore(module_name)}
  end

  @impl Mix.Task
  def run(options) do
    options
    |> State.init()
    |> clean_folders()
    |> put_files()
    |> rename()
    |> replace()
  end

  @cleanable_folders [
    "assets/node_modules",
    "_build",
    ".elixir_ls"
  ]
  defp clean_folders(%State{} = state) do
    Enum.each(@cleanable_folders, fn folder ->
      log("Removing #{folder}")

      wet(state, fn -> File.rm_rf!(folder) end)
    end)

    state
  end

  @ignore [
    "assets/node_modules",
    ".elixir_ls",
    "deps",
    "_build",
    "priv/static",
    "lib/mix/tasks/rename.ex"
  ]

  defp put_files(%State{} = state) do
    files = find_files()

    %State{state | files: files}
  end

  defp find_files do
    "./**"
    |> Path.wildcard()
    |> Enum.reject(&ignored?/1)
  end

  defp ignored?(path) do
    Enum.any?(@ignore, &String.starts_with?(path, &1))
  end

  defp rename(%State{files: files} = state) do
    files = Enum.map(files, &rename(state, &1))

    %State{state | files: files}
  end

  defp rename(%State{} = state, file) do
    file = update_file_path(state, file)

    case State.replace(state, file) do
      {:ok, new_file} ->
        log("Renaming #{file} to #{new_file}")
        wet(state, fn -> File.rename!(file, new_file) end)

        if State.dry_run?(state), do: file, else: new_file

      {:noop, _} ->
        log("Skipped #{file}")
        file
    end
  end

  defp update_file_path(state, file_name) do
    [head | tail] =
      file_name
      |> Path.split()
      |> Enum.reverse()

    updated_tail = Enum.map(tail, &State.replace_occurences(state, &1))

    [head | updated_tail]
    |> Enum.reverse()
    |> Path.join()
  end

  defp replace(%State{files: files} = state) do
    Enum.each(files, &replace(state, &1))

    state
  end

  defp replace(%State{} = state, file) do
    if not File.dir?(file) do
      old_content = File.read!(file)

      case State.replace(state, old_content) do
        {:ok, new_content} ->
          log("Replacing content in file #{file}")
          wet(state, fn -> File.write!(file, new_content) end)

        {:noop, _} ->
          log("Skipping #{file}")
      end
    end
  end

  defp wet(state, fun) do
    if not State.dry_run?(state) do
      fun.()
    else
      log("! Skipped due to dry run")
    end
  end

  defp log(message) do
    IO.puts(message)
  end
end
