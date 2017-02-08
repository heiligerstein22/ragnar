defmodule Ragnar.CommonParser do
  defmacro __using__(_) do

    quote do
      def parse_raw_value(value) when value == nil, do: value

      def parse_raw_value(value) do
        Floki.text(value)
      end

      def parse_float_value(value) do
        String.replace(value, ",", ".")
        |> Float.parse
        |> elem(0)
      end

      def parse_date_value(value, format \\ "%d/%m/%Y", options \\ %{}) do
        years_to_shift = if options[:shift_to_current_year], do: Timex.now.year, else: 0
        [date, _]      = String.split(value, "\s\n")

        Timex.parse!(date, format, :strftime)
        |> Timex.shift(years: years_to_shift)
        |> Timex.to_date
      end

      def parse_datetime_value(value) do
        Timex.parse!(value, "%d/%m %H:%M", :strftime)
        |> shift_date_to_current_year
      end

      def shift_date_to_current_year(date) do
        Timex.shift(date, years: Timex.now.year)
      end
    end

  end
end
