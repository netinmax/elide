defmodule Elide.OrganizationControllerTest do
  use Elide.ConnCase

  alias Elide.Organization
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "requires user auth on all actions" do
    Enum.each([
      get(conn, organization_path(conn, :new)),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  setup do
    user = insert_user(email: "foobar@buz.com")
    conn = assign(conn(), :current_user, user)
    {:ok, conn: conn, user: user}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, organization_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing organizations"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, organization_path(conn, :new)
    assert html_response(conn, 200) =~ "New organization"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, organization_path(conn, :create), organization: @valid_attrs
    assert redirected_to(conn) == organization_path(conn, :index)
    assert Repo.get_by(Organization, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, organization_path(conn, :create), organization: @invalid_attrs
    assert html_response(conn, 200) =~ "New organization"
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    organization = Repo.insert! %Organization{owner_id: user.id}
    conn = get conn, organization_path(conn, :show, organization)
    assert html_response(conn, 200) =~ "Show organization"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, organization_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, user: user} do
    organization = Repo.insert! %Organization{owner_id: user.id}
    conn = get conn, organization_path(conn, :edit, organization)
    assert html_response(conn, 200) =~ "Edit organization"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    organization = Repo.insert! %Organization{owner_id: user.id}
    conn = put conn, organization_path(conn, :update, organization), organization: @valid_attrs
    assert redirected_to(conn) == organization_path(conn, :show, organization)
    assert Repo.get_by(Organization, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    organization = Repo.insert! %Organization{owner_id: user.id}
    conn = put conn, organization_path(conn, :update, organization), organization: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit organization"
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    organization = Repo.insert! %Organization{owner_id: user.id}
    conn = delete conn, organization_path(conn, :delete, organization)
    assert redirected_to(conn) == organization_path(conn, :index)
    refute Repo.get(Organization, organization.id)
  end
end
