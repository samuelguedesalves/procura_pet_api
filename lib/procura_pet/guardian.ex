defmodule ProcuraPet.Guardian do
  @moduledoc false

  use Guardian, otp_app: :procura_pet

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    resource =
      String.to_integer(id)
      |> ProcuraPet.Accounts.get_user!()

    {:ok, resource}
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
