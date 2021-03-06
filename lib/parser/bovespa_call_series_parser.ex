defmodule Ragnar.BovespaCallSeriesParser do
  alias Ragnar.Serie
  use Ragnar.CommonParser

  def parse_many(html) do
    rows = Floki.find(html, "table.serie tbody tr")
    Enum.map(rows, &parse_single(&1))
  end

  ### Private functions

  defp parse_single(row) do
    cells = Floki.find(row, "td")
    attrs = %{
      symbol:     Enum.at(cells, 0) |> parse_raw_value,
      expires_at: Enum.at(cells, 8) |> parse_raw_value
    }

    build_changeset(attrs)
  end

  defp build_changeset(attrs) do
    Serie.changeset(%Serie{}, %{
      symbol: attrs.symbol,
      expires_at: parse_date_value(attrs.expires_at)
    })
  end

end
