defmodule Elide.User do
  use Elide.Web, :model

  schema "users" do
    field :email, :string
    field :fullname, :string
    field :avatar, :string
    field :provider, :string
    field :uid, :string

    timestamps
  end

  @required_fields ~w(email fullname provider uid)
  @optional_fields ~w(avatar)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
