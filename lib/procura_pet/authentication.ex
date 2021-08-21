defmodule ProcuraPet.Authentication do
  alias ProcuraPet.{Accounts, Token, Accounts.User}

  @doc """
  Auth user.

  ## Examples

      iex> auth_user("example@email.com", "1234")
      {:ok, %{toke: "...", user: %User{}}}

      iex> auth_user("example@email.com", "1234")
      {:error, reason}

  """
  @spec auth_user(String.t(), String.t()) ::
          {:ok, %{token: String.t(), user: %User{}}} | {:error, String.t()}
  def auth_user(email, password) do
    with {:ok, %{id: user_id, password: hash_pass}} <- Accounts.get_user_by_email(email),
         true <- Bcrypt.verify_pass(password, hash_pass),
         {:ok, token, _} <- Token.generate_and_sign(%{user_id: user_id}) do
      {:ok, %{token: token, user: user}}
    else
      {:error, %Ecto.Changeset{} = _changeset} -> {:error, "user not found"}
      {:error, reason} -> {:error, reason}
      _ -> {:error, "email or password not match"}
    end
  end
end
