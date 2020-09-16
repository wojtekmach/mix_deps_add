defmodule Mix.Tasks.Deps.Add do
  use Mix.Task

  @shortdoc "Adds a dependency"

  @moduledoc """
  Adds a dependency.

      mix deps.add hex ex_doc

  ## Command line options

      * `--dry-run` - displays updated mix.exs file without saving it.

  """

  @switches [dry_run: :boolean]

  @impl true
  def run(args) do
    {opts, args} = OptionParser.parse!(args, strict: @switches)

    case args do
      ["hex", package] ->
        package
        |> hex_add()
        |> process(opts)
    end
  end

  defp process({:ok, config}, opts) do
    mix_exs =
      "mix.exs"
      |> File.read!()
      |> Fix.fix([add_dep(config)], [], compile: false)

    if opts[:dry_run] do
      IO.puts(mix_exs)
    else
      File.write!("mix.exs", mix_exs)
    end
  end

  defp add_dep(config) do
    fn
      {:defp, meta, [{:deps, _, args} = fun, body]} when args in [[], nil] ->
        [{{_, _, [:do]} = do_ast, block_ast}] = body
        {:__block__, meta1, [deps]} = block_ast
        {name, requirement} = Code.string_to_quoted!(config)

        deps =
          deps ++
            [
              {:__block__, [],
               [{{:__block__, [], [name]}, {:__block__, [delimiter: "\""], [requirement]}}]}
            ]

        new_body = [{do_ast, {:__block__, meta1, [deps]}}]
        {:defp, meta, [fun, new_body]}

      other ->
        other
    end
  end

  defp hex_add(name) do
    case hex_get_package(name) do
      {:ok, {code, _headers, body}} when code in 200..299 ->
        {:ok, body["configs"]["mix.exs"]}

      {:ok, {404, _, _}} ->
        {:error, "No package with name #{name}"}

      other ->
        {:error, "Failed to retrieve package information\n\n#{inspect(other, pretty: true)}"}
    end
  end

  defp hex_get_package(name) do
    config = :hex_core.default_config()
    :hex_api_package.get(config, name)
  end
end
