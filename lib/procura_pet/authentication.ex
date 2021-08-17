defmodule ProcuraPet.Authentication do
  alias ProcuraPet.{Accounts, Token, Accounts.User}

  @doc """
  Auth user.

  ## Examples

      iex> auth_user(%{email: "example@email.com", password: "1234"})
      {:ok, %{toke: "...", user: %User{}}}

      iex> auth_user(%{email: "example@email.com", password: "1234"})
      {:error, reason}

  """
  @spec auth_user(%{email: String.t(), password: String.t()}) ::
          {:ok, %{token: String.t(), user: %User{}}} | {:error, String.t()}
  def auth_user(%{email: email, password: password}) do
    case find_user(email) do
      {:ok, user} ->
        with %{id: user_id, password: hash_pass} <- user,
            true <- Bcrypt.verify_pass(password, hash_pass),
            {:ok, token, _} <- Token.generate_and_sign(%{user_id: user_id}) do
          {:ok, %{token: token, user: user}}
        else
          {:error, reason} -> {:error, reason}
          _ -> {:error, "email or password not match"}
        end

      {:error, reason} -> {:error, reason}

    end
  end

  @spec find_user(String.t) :: {:ok, %User{}} | {:error, String.t}
  defp find_user(email) do
    case Accounts.get_user_by_email(email) do
      %User{} = user -> {:ok, user}
      _ -> {:error, "user not found"}
    end
  end
end
