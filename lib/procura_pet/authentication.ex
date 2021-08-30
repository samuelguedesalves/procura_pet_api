defmodule ProcuraPet.Authentication do
  alias ProcuraPet.{Accounts, Guardian, Accounts.User}

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
    with %User{} = user <- Accounts.get_user_by_email(email),
         %{id: user_id, password: hash_pass} <- user,
         true <- Bcrypt.verify_pass(password, hash_pass),
         {:ok, token, _} <- Guardian.encode_and_sign(%{id: user_id}) do
      {:ok, %{token: token, user: user}}
    else
      {:error, %Ecto.Changeset{} = _changeset} -> {:error, "user not found"}
      {:error, reason} -> {:error, reason}
      _ -> {:error, "email or password not match"}
    end
  end
end
