defmodule Bootloader.Utils do

  def bootloader_applications() do
    [:bootloader, :kernel, :stdlib, :compiler, :elixir, :iex]
  end

  def hash(blob) do
    :crypto.hash(:sha256, blob)
    |> Base.encode16
  end

  def expand_paths(paths, dir) do
    expand_dir = Path.expand(dir)

    paths
    |> Enum.map(&Path.join(dir, &1))
    |> Enum.flat_map(&Path.wildcard/1)
    |> Enum.flat_map(&dir_files/1)
    |> Enum.map(&Path.expand/1)
    |> Enum.filter(&File.regular?/1)
    |> Enum.uniq
  end

  defp dir_files(path) do
    if File.dir?(path) do
      Path.wildcard(Path.join(path, "**"))
    else
      [path]
    end
  end


end