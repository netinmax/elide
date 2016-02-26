defmodule Elide.Repo.Migrations.CreateStat do
  use Ecto.Migration

  def up do
    execute "CREATE TYPE stats_tags AS ENUM ('browser','referrer', 'country', 'platform')"
    create table(:stats) do
      add :tag, :stats_tags
      add :value, :string
      add :count, :integer
      add :visited_at, :datetime
      add :elink_id, references(:elinks, on_delete: :nothing)

      timestamps
    end
    create index(:stats, [:elink_id])
  end

  def down do
    drop table(:stats)
    execute "DROP TYPE stats_tags"
  end
end