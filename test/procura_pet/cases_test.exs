defmodule ProcuraPet.CasesTest do
  use ProcuraPet.DataCase

  alias ProcuraPet.Cases

  describe "cases" do
    alias ProcuraPet.Cases.Case

    @valid_attrs %{description: "some description", title: "some title", user_fk: 42}
    @update_attrs %{
      description: "some updated description",
      title: "some updated title",
      user_fk: 43
    }
    @invalid_attrs %{description: nil, title: nil, user_fk: nil}

    def case_fixture(attrs \\ %{}) do
      {:ok, case} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Cases.create_case()

      case
    end

    test "list_cases/0 returns all cases" do
      case = case_fixture()
      assert Cases.list_cases() == [case]
    end

    test "get_case!/1 returns the case with given id" do
      case = case_fixture()
      assert Cases.get_case!(case.id) == case
    end

    test "create_case/1 with valid data creates a case" do
      assert {:ok, %Case{} = case} = Cases.create_case(@valid_attrs)
      assert case.description == "some description"
      assert case.title == "some title"
      assert case.user_fk == 42
    end

    test "create_case/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cases.create_case(@invalid_attrs)
    end

    test "update_case/2 with valid data updates the case" do
      case = case_fixture()
      assert {:ok, %Case{} = case} = Cases.update_case(case, @update_attrs)
      assert case.description == "some updated description"
      assert case.title == "some updated title"
      assert case.user_fk == 43
    end

    test "update_case/2 with invalid data returns error changeset" do
      case = case_fixture()
      assert {:error, %Ecto.Changeset{}} = Cases.update_case(case, @invalid_attrs)
      assert case == Cases.get_case!(case.id)
    end

    test "delete_case/1 deletes the case" do
      case = case_fixture()
      assert {:ok, %Case{}} = Cases.delete_case(case)
      assert_raise Ecto.NoResultsError, fn -> Cases.get_case!(case.id) end
    end

    test "change_case/1 returns a case changeset" do
      case = case_fixture()
      assert %Ecto.Changeset{} = Cases.change_case(case)
    end
  end
end
