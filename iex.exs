if function_exported?(Mix, :__info__, 1) and Mix.env() == :dev do
  # if statement guards you from running it in prod, which could result in loss of logs.
  Logger.configure_backend(:console, device: Process.group_leader())
end

Application.put_env(:elixir, :ansi_enabled, true)

timestamp = fn ->
  {_date, {hour, minute, _second}} = :calendar.local_time()

  [hour, minute]
  |> Enum.map(&String.pad_leading(Integer.to_string(&1), 2, "0"))
  |> Enum.join(":")
end

IEx.configure(
  colors: [
    syntax_colors: [
      number: :light_yellow,
      atom: :light_cyan,
      string: :light_black,
      boolean: :red,
      nil: [:magenta, :bright]
    ],
    ls_directory: :cyan,
    ls_device: :yellow,
    doc_code: :green,
    doc_inline_code: :magenta,
    doc_headings: [:cyan, :underline],
    doc_title: [:cyan, :bright, :underline]
  ],
  default_prompt:
    "[#{IO.ANSI.magenta()}#{timestamp.()}#{IO.ANSI.reset()}] " <>
      "#{IO.ANSI.green()}%prefix#{IO.ANSI.light_green()}❯#{IO.ANSI.reset()}",
  alive_prompt:
    "[#{IO.ANSI.magenta()}#{timestamp.()}#{IO.ANSI.reset()}] " <>
      "(#{IO.ANSI.yellow()}%node#{IO.ANSI.reset()}) " <>
      "#{IO.ANSI.green()}%prefix#{IO.ANSI.light_green()}❯#{IO.ANSI.reset()}",
  history_size: 1000,
  inspect: [
    pretty: true,
    limit: :infinity
  ]
)
