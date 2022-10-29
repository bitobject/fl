#!/bin/sh
# bin/fl eval "Fl.Repo.__adapter__.storage_down(Fl.Repo.config)"
bin/fl eval "Fl.Repo.__adapter__.storage_up(Fl.Repo.config)"
bin/fl eval "Fl.Release.migrate"
# bin/fl eval "Code.eval_file(Path.join([:code.priv_dir(:fl), \"repo\", \"seeds.exs\"]))"
bin/fl start