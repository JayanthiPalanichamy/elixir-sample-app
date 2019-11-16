defmodule HighestStock do
  @url "http://dev.markitondemand.com/MODApis/Api/v2/Quote/json?symbol="

  @moduledoc """
  Documentation for HighestStock.
  """

  @doc """
  Hello world.

  ## Examples

      iex> HighestStock.hello()
      :world

  """
  def hello do
    :world
  end

  def stockFor(stock_code) do
    request = [@url, stock_code]
    |> Path.join("")
    |> HTTPoison.get()
    case request do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok,  Jason.decode!(body)}
  end
  end

  @stock ~w(FB GOOGL MSFT AMZN)

  def highest() do

    stocks = Enum.map(@stock, fn (stock) -> stockFor(stock) end)
    Enum.map(stocks, fn({:ok, body}) -> body end)
    |> Enum.max_by(fn (body) -> body["LastPrice"] end)
    |> Map.get("Name")

  end
end
